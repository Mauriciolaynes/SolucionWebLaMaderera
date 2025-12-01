<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Nuevo Pedido de Compra</title>
<!-- Incluye aquí tus CSS, por ejemplo Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    .container {
        max-width: 960px;
    }
    .card-header {
        background-color: #f8f9fa;
    }
</style>
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4">Generar Pedido de Compra</h2>

    <!-- Mensajes de éxito o error -->
    <c:if test="${not empty success}">
        <div class="alert alert-success" role="alert">
            ${success}
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">
            ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/pedidos-compra/resumen" method="post">
        <div class="card">
            <div class="card-header">
                <h4>Datos del Pedido</h4>
            </div>
            <div class="card-body">
                <!-- Selección de Proveedor -->
                <div class="mb-3">
                    <label for="proveedor" class="form-label">Proveedor:</label>
                    <select id="proveedor" name="proveedor.idProveedor" class="form-select" required>
                        <option value="">Seleccione un proveedor</option>
                        <c:forEach items="${proveedores}" var="proveedor">
                            <option value="${proveedor.idProveedor}">${proveedor.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <!-- El detalle de productos DEBE estar dentro del formulario -->
            <div class="card mt-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4>Detalle de Productos</h4>
                    <button type="button" class="btn btn-primary" onclick="agregarFila()">Añadir Producto</button>
                </div>
                <div class="card-body">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Producto</th>
                                <th>Cantidad</th>
                                <th>Precio Compra (S/)</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody id="tabla-detalles">
                            <!-- Las filas de productos se añadirán aquí dinámicamente -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="mt-4 text-end">
            <button type="button" class="btn btn-primary" onclick="enviarSeguro()">Ver Resumen del Pedido</button>
            <a href="${pageContext.request.contextPath}/compras" class="btn btn-secondary">Volver</a>
        </div>
    </form>
</div>

<!-- Plantilla para la fila de producto (oculta) -->
<!-- Usamos la etiqueta <template> que está diseñada para esto -->
<template id="plantilla-fila">
    <tr>
        <td>
            <select class="form-select producto-select" required></select>
        </td>
        <td>
            <input type="number" class="form-control" min="1" value="1" required>
        </td>
        <td>
            <input type="number" class="form-control" step="0.01" min="0" value="0.00" required>
        </td>
        <td>
            <button type="button" class="btn btn-danger" onclick="eliminarFila(this)">Eliminar</button>
        </td>
    </tr>
</template>

<!-- Bloque de datos JSON para los productos. Es la forma más segura de pasar datos. -->
<script id="productos-json-data" type="application/json">
    ${productosJson}
</script>

<script>
    let listaDeProductos = []; 
    let indiceFila = 0;

    function reindexarFilas() {
        const filas = document.getElementById('tabla-detalles').querySelectorAll('tr');
        indiceFila = 0; 
        
        filas.forEach(fila => {
            const inputs = fila.querySelectorAll('select, input');
            
            // Asignación explícita
            if (inputs.length >= 3) {
                // Producto
                inputs[0].name = 'detalles[' + indiceFila + '].producto.idProducto';
                // Cantidad
                inputs[1].name = 'detalles[' + indiceFila + '].cantidad';
                // Precio
                inputs[2].name = 'detalles[' + indiceFila + '].precioCompra';
            }
            indiceFila++;
        });
        console.log("Reindexado completo. Filas: " + indiceFila);
    }

    function enviarSeguro() {
        // 1. Reindexar
        reindexarFilas();
        
        if (indiceFila === 0) {
            alert("Debes agregar al menos un producto.");
            return;
        }

        // 2. LIMPIEZA DE SEGURIDAD (NUEVO)
        // Buscamos si quedó algún input con corchetes vacíos [] y lo desactivamos
        // para que NO se envíe y no cause error.
        const inputsRotos = document.querySelectorAll('[name*="[]"]');
        if (inputsRotos.length > 0) {
            console.warn("Se encontraron inputs rotos, desactivándolos...");
            inputsRotos.forEach(input => input.disabled = true);
        }

        // 3. Imprimir lo que se envía
        console.log("--- ENVIANDO ---");
        const datos = new FormData(document.querySelector('form'));
        for (var pair of datos.entries()) {
            console.log(pair[0] + ', ' + pair[1]);
        }

        // 4. Enviar
        document.querySelector('form').submit();
    }

    function eliminarFila(boton) {
        const fila = boton.closest('tr');
        fila.remove();
        reindexarFilas();
    }
    
    function agregarFila() {
        const plantilla = document.getElementById('plantilla-fila');
        // Clonar nodo
        const nuevaFila = plantilla.content.cloneNode(true);
        // IMPORTANTE: cloneNode de template devuelve un DocumentFragment, 
        // necesitamos acceder a sus hijos antes de insertarlo o buscar dentro.
        
        // Truco: Lo insertamos primero para que sea un elemento real del DOM
        const tabla = document.getElementById('tabla-detalles');
        tabla.appendChild(nuevaFila);
        
        // Ahora obtenemos la última fila insertada (la que acabamos de poner)
        const filaInsertada = tabla.lastElementChild;
        
        const selectProducto = filaInsertada.querySelector('.producto-select');
        
        const idProveedorSeleccionado = document.getElementById('proveedor').value;
        
        if (!idProveedorSeleccionado) {
            filaInsertada.remove(); // Borramos si no hay proveedor
            alert('Por favor, seleccione un proveedor primero.');
            return; 
        }
        
        const idFiltro = idProveedorSeleccionado.toString();

        // Filtrado
        const productosFiltrados = listaDeProductos.filter(p => {
            const pId = p.idProveedor != null ? p.idProveedor.toString() : "";
            return pId === idFiltro;
        }); 

        // Llenar Select
        selectProducto.innerHTML = '';
        const opcionDefecto = document.createElement('option');
        opcionDefecto.value = "";
        opcionDefecto.textContent = "Seleccione un producto";
        selectProducto.appendChild(opcionDefecto);

        if (productosFiltrados.length > 0) {
            productosFiltrados.forEach(p => {
                const opcion = document.createElement('option');
                opcion.value = p.idProducto;
                opcion.textContent = p.nombre || ("Producto " + p.idProducto);
                opcion.dataset.precio = p.precioCompra;
                opcion.style.color = "black"; 
                selectProducto.appendChild(opcion);
            });
        } else {
            const opcionVacia = document.createElement('option');
            opcionVacia.textContent = "--- No hay productos ---";
            opcionVacia.disabled = true;
            selectProducto.appendChild(opcionVacia);
        }

        // Listener de precio
        selectProducto.addEventListener('change', function() {
            const opcionSeleccionada = this.options[this.selectedIndex];
            const precio = opcionSeleccionada.dataset.precio ?? 0; 
            const fila = this.closest('tr');
            const inputs = fila.querySelectorAll('input');
            if(inputs.length > 1) {
                inputs[1].value = precio;
            }
        });

        // Reindexamos al final
        reindexarFilas();
    }

    function actualizarFilasPorProveedor() {
        const tablaDetalles = document.getElementById('tabla-detalles');
        tablaDetalles.innerHTML = '';
        indiceFila = 0;
    }

    document.addEventListener('DOMContentLoaded', function() {
        try {
            const productosDataElement = document.getElementById('productos-json-data');
            const productosJsonString = productosDataElement.textContent.trim();
            listaDeProductos = productosJsonString ? JSON.parse(productosJsonString) : [];
        } catch (e) { console.error("Error JSON:", e); }

        const selectorProveedor = document.getElementById('proveedor');
        selectorProveedor.addEventListener('change', actualizarFilasPorProveedor);
        
        document.querySelector('form').addEventListener('submit', function(e) {
             e.preventDefault();
             enviarSeguro();
        });
    });
</script>

</body>
</html>