<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${cotizacion.idCotizacion == null ?
'Nueva Cotización' : 'Editar Cotización'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            max-width: 1000px;
        }
        .card-header {
            background-color: #e9ecef;
            font-weight: bold;
        }
        .table-detalle th, .table-detalle td {
            vertical-align: middle;
        }
        /* Ajuste para el botón de eliminar dentro de la tabla */
        .btn-sm-custom {
            padding: .25rem .5rem;
            font-size: .875rem;
            line-height: 1.5;
            border-radius: .2rem;
        }
    </style>
</head>
<body>

<div class="container mt-5 mb-5">
    
    <h2 class="mb-4 text-center">
        ${cotizacion.idCotizacion == null ?
'Registrar Nueva Cotización' : 'Editar Cotización #${cotizacion.idCotizacion}'}
    </h2>
    <hr>
    
    <%-- MENSAJES DE ALERTA (Success, Error, Warning) --%>
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
   
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    
    <form 
        id="formCotizacion"
        action="<c:url value='/cotizaciones/guardar'/>"
        method="post"
        enctype="multipart/form-data">
        
        <input type="hidden" name="idCotizacion" value="${cotizacion.idCotizacion}"/>

    
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                Información General de la Cotización
            </div>
            <div class="card-body">
                
                <%-- Fila 1: Proveedor, Pedido Asociado, Fecha --%>
                <div class="row mb-3">
                    
                    <%-- Columna Proveedor --%>
                    <div class="col-md-4">
             
                        <label class="form-label">Proveedor:</label>
                        <select name="proveedor.idProveedor" id="selectProveedor" class="form-select" required>
                            <option value="">-- Seleccione proveedor --</option>
                            
                            <c:forEach var="p" items="${proveedores}">
                                <option value="${p.idProveedor}"
                                    <c:if test="${cotizacion.proveedor != null && cotizacion.proveedor.idProveedor == p.idProveedor}">selected</c:if>>
                      
                                    ${p.nombre} (${p.ruc})
                                </option>
                            </c:forEach>
                        </select>
 
                        <c:if test="${result != null && result.hasFieldErrors('proveedor.idProveedor')}">
                            <span class="text-danger">${result.getFieldError('proveedor.idProveedor').defaultMessage}</span>
                        </c:if>
                   
                    </div>

                    <%-- Columna Pedido Asociado (OBLIGATORIO) --%>
                    <div class="col-md-4">
                        <label class="form-label">Pedido asociado:</label>
                        <%-- NOTA: Eliminamos la iteración JSTL, será llenado por AJAX --%>
                        <select name="pedido.idPedidoCompra" id="selectPedido" class="form-select" required>
                            <option value="">-- Seleccione proveedor primero --</option>
                        </select>
        
                         
                        <%-- Mostrar error de validación del Pedido --%>
                        <c:if test="${result != null && result.hasFieldErrors('pedido')}">
                        
                            <span class="text-danger">${result.getFieldError('pedido').defaultMessage}</span>
                        </c:if>
                    </div>

                    <%-- Columna Fecha --%>
                    <div class="col-md-4">
       
                          <label class="form-label">Fecha de Cotización:</label>
                        <input type="date" name="fecha" class="form-control" value="${cotizacion.fecha}" required/>
                    </div>
                </div>

               
                  <%-- Fila 2: Archivo, Estado, Condiciones --%>
                <div class="row">
                    
                    <%-- Columna Archivo --%>
                    <div class="col-md-5 mb-3">
           
                          <label class="form-label">Archivo adjunto (PDF / Excel):</label>
                        <input type="file" name="archivoFile" class="form-control"/>
                        <c:if test="${not empty cotizacion.archivoAdjunto}">
                            
                            <small class="form-text text-muted">Archivo actual: <a href="<c:url value='/uploads/cotizaciones/${cotizacion.archivoAdjunto}'/>" target="_blank">${cotizacion.archivoAdjunto}</a></small>
                        </c:if>
                    </div>

                    <%-- Columna Estado --%>
                    <div class="col-md-3 mb-3">
    
                        <label class="form-label">Estado:</label>
                        <select name="estado" class="form-select">
                            <c:forEach var="estado" items="${estados}">
                       
                                 <option value="${estado}" 
                                    ${estado == cotizacion.estado ?
                                        'selected' : ''}>
                                    ${estado}
                                </option>
                            </c:forEach>
  
                        </select>
                    </div>

                    <%-- Columna Condiciones --%>
                    <div class="col-md-4 mb-3">
             
                        <label class="form-label">Condiciones (opcional):</label>
                        <input type="text" name="condiciones" class="form-control" value="${cotizacion.condiciones}" placeholder="Plazos, garantías, observaciones"/>
                    </div>
                </div>
            </div>
        
        </div>

        <%-- Sección de Detalle de Productos --%>
        <div class="card mb-4">
            <div class="card-header bg-success text-white">
                Detalles de Productos Cotizados
            </div>
            <div class="card-body p-0">
                
                <div class="table-responsive">
                    <table class="table table-hover table-sm table-detalle mb-0" id="tabla-detalles">
                        <thead class="table-light">
                            <tr>
                    
                                 <th style="width:50%;">Producto</th>
                                <th style="width:12%;">Cantidad</th>
                                <th style="width:18%;">Precio (S/)</th>
                    
                                 <th style="width:10%;">Subtotal</th>
                                <th style="width:10%;">Acción</th>
                            </tr>
                        </thead>
  
                        <tbody>
                            <%-- 
                                **CORRECCIÓN CRÍTICA:** Se elimina la carga de filas de detalles por JSTL (${cotizacion.detalles}) 
                                para evitar que se rendericen selectores vacíos si la lista de productos es incompleta.
                                Toda la carga de detalles se delega ahora a la función AJAX/JS: loadDetallesPedido().
                            --%>
                        </tbody>
                        <tfoot>
                             <tr>
                                <td colspan="3" class="text-end"><strong>Total Estimado:</strong></td>
          
                                 <td colspan="2"><strong id="total-cotizacion">S/ 0.00</strong></td>
                            </tr>
                        </tfoot>
                    </table>
   
                 </div>
            </div>
        </div>

        <div class="mt-2 mb-4">
            <button type="button" class="btn btn-outline-primary" onclick="agregarFila()">➕ Agregar producto</button>
        </div>

        <%-- Botones de Acción --%>
        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
       
             <a href="<c:url value='/compras'/>" class="btn btn-secondary">Cancelar</a>
            <button type="button" class="btn btn-success" onclick="enviarCotizacionSegura()">Guardar Cotización</button>
        </div>
        
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {

    // 1. REFERENCIAS
    const formCotizacion = document.getElementById('formCotizacion');
    const tablaBody = document.querySelector('#tabla-detalles tbody');
    const totalSpan = document.getElementById('total-cotizacion');
    const selectProveedor = document.getElementById('selectProveedor');
    const selectPedido = document.getElementById('selectPedido');
    const contextPath = "${pageContext.request.contextPath}";

    // 2. PARSEO DE DATOS
    let productosData = [];
    try {
        const rawJson = [
            <c:forEach var="p" items="${productos}" varStatus="status">
                { "id": ${p.idProducto}, "nombre": '<c:out value="${p.nombre}" escapeXml="true"/>', "precio": ${p.precioCompra != null ? p.precioCompra : 0} }${!status.last ? ',' : ''}
            </c:forEach>
        ];
        productosData = rawJson;
    } catch (e) { console.error("Error JSON", e); }

    let productosOptions = '<option value="">-- Seleccione --</option>';
    productosData.forEach(function(p) {
        productosOptions += '<option value="' + p.id + '" data-precio="' + p.precio + '">' + p.nombre + '</option>';
    });

    // =========================================================
    // 3. REINDEXAR (AQUÍ ESTABA EL ERROR)
    // =========================================================
    function reindexar() {
        const filas = tablaBody.querySelectorAll('tr');
        let total = 0;

        filas.forEach(function(tr, index) {
            
            // --- CORRECCIÓN: USAR CONCATENACIÓN '+' ---
            // NUNCA uses `detalles[${index}]` en un JSP.
            
            const inputProd = tr.querySelector('.producto-select');
            if (inputProd) {
                // Correcto:
                inputProd.name = 'detalles[' + index + '].producto.idProducto';
            }

            const inputCant = tr.querySelector('.cantidad-input');
            if (inputCant) {
                // Correcto:
                inputCant.name = 'detalles[' + index + '].cantidad';
            }

            const inputPrec = tr.querySelector('.precio-input');
            if (inputPrec) {
                // Correcto:
                inputPrec.name = 'detalles[' + index + '].precio';
            }

            // Cálculo de totales
            const subtotalText = tr.querySelector('.subtotal-text');
            if (subtotalText && subtotalText.textContent) {
                total += parseFloat(subtotalText.textContent.replace('S/', '').trim()) || 0;
            }
        });
        
        if (totalSpan) totalSpan.textContent = 'S/ ' + total.toFixed(2);
    }

       // 2. FUNCIÓN DE ENVÍO SEGURO (GLOBAL)
    window.enviarCotizacionSegura = function() {
        // A. Primero arreglamos los índices
        reindexar();

        // B. Validamos que haya productos
        const filas = document.querySelectorAll('#tabla-detalles tbody tr');
        if (filas.length === 0) {
            alert("Debe agregar al menos un producto a la cotización.");
            return;
        }

        // C. Enviamos usando el ID explícito
        const elFormulario = document.getElementById('formCotizacion');
        if (elFormulario) {
            console.log("Enviando cotización...");
            elFormulario.submit();
        } else {
            console.error("ERROR CRÍTICO: No se encontró el formulario con id='formCotizacion'");
            alert("Error interno: No se pudo enviar el formulario.");
        }
    };

    // 5. OBTENER NOMBRE
    function obtenerNombreProducto(id) {
        const idNumber = parseInt(id, 10);
        if (isNaN(idNumber)) return 'ID Inválido';
        const producto = productosData.find(function(p){ return p.id === idNumber });
        return producto ? producto.nombre : 'Producto ID:' + id;
    }

    // =========================================================
    // 6. AGREGAR FILA (CORREGIDO TAMBIÉN)
    // =========================================================
    window.agregarFila = function(prodId, cantidad, precio, nombreDirecto) {
        // Valores por defecto
        cantidad = (cantidad !== undefined && cantidad !== null && cantidad !== '') ? cantidad : 1;
        precio = (precio !== undefined && precio !== null && precio !== '') ? precio : 0;
        let precioVal = parseFloat(precio).toFixed(2);
        
        let productoHtml = '';

        if (prodId && prodId !== '') {
            let nombre = nombreDirecto;
            if (!nombre) {
                nombre = obtenerNombreProducto(prodId);
            }
            // Concatenación segura
            productoHtml = 
                '<div class="p-1">' +
                    '<input type="hidden" value="' + prodId + '" class="producto-select" />' +
                    '<b>' + nombre + '</b>' +
                '</div>';
        } else {
            productoHtml = 
                '<select class="form-select form-select-sm producto-select" required>' + 
                productosOptions + 
                '</select>';
        }

        const tr = document.createElement('tr');
        // Concatenación segura
        tr.innerHTML = 
            '<td>' + productoHtml + '</td>' +
            '<td><input type="number" min="1" class="form-control form-control-sm cantidad-input" value="' + cantidad + '" required/></td>' +
            '<td><input type="number" step="0.01" min="0" class="form-control form-control-sm precio-input" value="' + precioVal + '" required/></td>' +
            '<td class="subtotal-cell">S/ <span class="subtotal-text">0.00</span></td>' +
            '<td><button type="button" class="btn btn-danger btn-sm-custom" onclick="eliminarFila(this)">Eliminar</button></td>';

        tablaBody.appendChild(tr);

        // Listeners
        tr.querySelector('.cantidad-input').addEventListener('input', function() {
            actualizarSubtotalFila(this.closest('tr'));
            reindexar();
        });
        tr.querySelector('.precio-input').addEventListener('input', function() {
            actualizarSubtotalFila(this.closest('tr'));
            reindexar();
        });

        if (!prodId) {
            const selectProd = tr.querySelector('.producto-select');
            selectProd.addEventListener('change', function() {
                const opt = this.options[this.selectedIndex];
                const pr = opt.getAttribute('data-precio');
                if (pr) {
                    const row = this.closest('tr');
                    row.querySelector('.precio-input').value = parseFloat(pr).toFixed(2);
                    actualizarSubtotalFila(row);
                    reindexar();
                }
            });
        }

        reindexar();
        actualizarSubtotalFila(tr);
    };

    // Funciones auxiliares
    window.eliminarFila = function(btn) {
        const tr = btn.closest('tr');
        tr.remove();
        reindexar();
    };

    function actualizarSubtotalFila(tr) {
        const qty = parseFloat(tr.querySelector('.cantidad-input').value) || 0;
        const price = parseFloat(tr.querySelector('.precio-input').value) || 0;
        const subtotal = (qty * price);
        const span = tr.querySelector('.subtotal-text');
        if (span) span.textContent = subtotal.toFixed(2);
        
        // Recalcular total general
        let totalGeneral = 0;
        document.querySelectorAll('.subtotal-text').forEach(function(s) {
            totalGeneral += parseFloat(s.textContent) || 0;
        });
        if(totalSpan) totalSpan.textContent = totalGeneral.toFixed(2);
    }

    function clearDetails() {
        tablaBody.innerHTML = '';
        reindexar(); 
    }

    // --- AJAX ---
    window.loadPedidos = function(idProveedor) {
        selectPedido.innerHTML = '<option value="">Cargando...</option>';
        if(!idProveedor) { selectPedido.innerHTML = '<option value="">-- Seleccione proveedor primero --</option>'; selectPedido.disabled = true; return; }
        
        fetch(contextPath + '/api/v1/pedidos/proveedor/' + idProveedor)
            .then(r => r.json())
            .then(data => {
                let opts = '<option value="">-- Seleccione pedido --</option>';
                data.forEach(function(p) {
                    opts += '<option value="' + p.idPedidoCompra + '">' + (p.numeroPedido || 'ID ' + p.idPedidoCompra) + '</option>';
                });
                selectPedido.innerHTML = opts;
                selectPedido.disabled = false;
            })
            .catch(e => { console.error(e); selectPedido.innerHTML = '<option value="">Error</option>'; });
    };

    window.loadDetallesPedido = function(idPedido) {
        clearDetails();
        if(!idPedido) return;
        fetch(contextPath + '/api/v1/pedidos/' + idPedido + '/detalles')
            .then(r => r.json())
            .then(data => {
                data.forEach(function(d) {
                    const pid = (d.producto && d.producto.idProducto) ? d.producto.idProducto : d.idProducto;
                    const pnom = (d.producto && d.producto.nombre) ? d.producto.nombre : null;
                    agregarFila(pid, d.cantidad, d.precioCompra, pnom);
                });
                if(data.length === 0) agregarFila();
            });
    };

    // Listeners principales
    selectProveedor.addEventListener('change', function() { loadPedidos(this.value); });
    selectPedido.addEventListener('change', function() { loadDetallesPedido(this.value); });

    // Inicialización al cargar (si es edición)
    const initialProv = selectProveedor.value;
    // Si ya hay proveedor seleccionado (edición), cargar cosas si es necesario
    // ...
});
</script>

</body>
</html>