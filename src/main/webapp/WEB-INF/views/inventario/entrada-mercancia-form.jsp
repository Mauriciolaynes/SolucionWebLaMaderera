<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Entrada de Mercancía</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
    <style>
        .productos-list {
            margin-top: 20px;
        }
        .producto-item {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            align-items: center;
        }
        .producto-item select, .producto-item input {
            flex: 1;
        }
        .btn-agregar {
            background-color: #28a745;
            color: white;
            padding: 8px 16px;
            border: none;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn-eliminar {
            background-color: #dc3545;
            color: white;
            padding: 5px 10px;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📦 Registrar Entrada de Mercancía</h1>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        
        <form action="<c:url value='/inventario/entradas/guardar'/>" method="post" id="formEntrada">
            
            <div class="form-group">
                <label for="numeroFactura">Número de Factura:</label>
                <input type="text" id="numeroFactura" name="numeroFactura" required 
                       placeholder="Ej: FAC-2025-001">
            </div>
            
            <div class="form-group">
                <label for="idProveedor">Proveedor:</label>
                <select id="idProveedor" name="idProveedor">
                    <option value="">-- Seleccione proveedor (opcional) --</option>
                    <c:forEach items="${proveedores}" var="prov">
                        <option value="${prov.idProveedor}">${prov.nombre}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group">
                <label for="observaciones">Observaciones:</label>
                <textarea id="observaciones" name="observaciones" rows="3" 
                          placeholder="Información adicional sobre la entrada..."></textarea>
            </div>
            
            <hr>
            
            <h3>Productos Recibidos</h3>
            <div class="productos-list" id="productosContainer">
                <!-- Primer producto por defecto -->
                <div class="producto-item">
                    <select name="idProducto[]" required>
                        <option value="">-- Seleccione producto --</option>
                        <c:forEach items="${productos}" var="prod">
                            <option value="${prod.idProducto}">${prod.nombre}</option>
                        </c:forEach>
                    </select>
                    <input type="number" name="cantidad[]" min="1" value="1" 
                           placeholder="Cantidad" required>
                    <button type="button" class="btn-eliminar" onclick="eliminarProducto(this)"
                            style="display:none;">Eliminar</button>
                </div>
            </div>
            
            <button type="button" class="btn-agregar" onclick="agregarProducto()">
                ➕ Agregar otro producto
            </button>
            
            <hr>
            
            <input type="hidden" name="productosJson" id="productosJson">
            
            <div class="form-actions">
                <button type="submit" class="btn-primary">✅ Registrar Entrada</button>
                <a href="<c:url value='/inventario/listar'/>" class="btn-secondary">Cancelar</a>
            </div>
        </form>
    </div>
    
    <script>
        let productoCount = 1;
        
        function agregarProducto() {
            productoCount++;
            const container = document.getElementById('productosContainer');
            const newItem = container.children[0].cloneNode(true);
            
            // Limpiar valores
            newItem.querySelector('select').selectedIndex = 0;
            newItem.querySelector('input').value = 1;
            newItem.querySelector('.btn-eliminar').style.display = 'inline-block';
            
            container.appendChild(newItem);
            
            // Mostrar botón eliminar en todos menos el primero
            actualizarBotonesEliminar();
        }
        
        function eliminarProducto(btn) {
            if (document.querySelectorAll('.producto-item').length > 1) {
                btn.parentElement.remove();
                actualizarBotonesEliminar();
            }
        }
        
        function actualizarBotonesEliminar() {
            const items = document.querySelectorAll('.producto-item');
            items.forEach((item, index) => {
                const btn = item.querySelector('.btn-eliminar');
                btn.style.display = (items.length > 1) ? 'inline-block' : 'none';
            });
        }
        
        // Antes de enviar el formulario, crear JSON de productos
        document.getElementById('formEntrada').addEventListener('submit', function(e) {
            const selectsProducto = document.getElementsByName('idProducto[]');
            const inputsCantidad = document.getElementsByName('cantidad[]');
            
            let jsonData = [];
            for (let i = 0; i < selectsProducto.length; i++) {
                if (selectsProducto[i].value && inputsCantidad[i].value) {
                    jsonData.push(selectsProducto[i].value + ':' + inputsCantidad[i].value);
                }
            }
            
            document.getElementById('productosJson').value = jsonData.join(',');
        });
    </script>
</body>
</html>
