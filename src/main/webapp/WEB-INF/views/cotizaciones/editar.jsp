<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Cotización</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>

<div class="container mt-4">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0">
                <i class="fas fa-edit me-2"></i>
                Editar Cotización #${cotizacion.idCotizacion}
            </h3>
        </div>
        <div class="card-body">
            <form:form modelAttribute="cotizacion" action="${pageContext.request.contextPath}/cotizaciones/guardar" method="post" enctype="multipart/form-data">
                
                <%-- Campos ocultos para mantener el ID y otros datos --%>
                <form:hidden path="idCotizacion"/>
                <form:hidden path="numeroCotizacion"/>
                <form:hidden path="fecha"/>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="pedido" class="form-label"><strong>Pedido de Compra Asociado:</strong></label>
                        <form:select path="pedido.idPedidoCompra" id="pedido" class="form-select" required="true">
                            <form:option value="" label="-- Seleccione un Pedido --"/>
                            <c:forEach var="p" items="${pedidos}">
                                <form:option value="${p.idPedidoCompra}" label="#${p.numeroPedido} - ${p.proveedor.nombre}"/>
                            </c:forEach>
                        </form:select>
                    </div>

                    <div class="col-md-6">
                        <label for="proveedor" class="form-label"><strong>Proveedor:</strong></label>
                        <form:select path="proveedor.idProveedor" id="proveedor" class="form-select" required="true">
                            <form:option value="" label="-- Seleccione un Proveedor --"/>
                            <c:forEach var="prov" items="${proveedores}">
                                <form:option value="${prov.idProveedor}" label="${prov.nombre}"/>
                            </c:forEach>
                        </form:select>
                    </div>

                    <div class="col-md-6">
                        <label for="estado" class="form-label"><strong>Estado:</strong></label>
                        <form:select path="estado" id="estado" class="form-select">
                            <c:forEach var="est" items="${estados}">
                                <form:option value="${est}" label="${est.toString().replace('_', ' ')}"/>
                            </c:forEach>
                        </form:select>
                    </div>

                    <div class="col-md-6">
                        <label for="archivoFile" class="form-label"><strong>Adjuntar Archivo (PDF):</strong></label>
                        <input type="file" name="archivoFile" id="archivoFile" class="form-control" accept=".pdf">
                        <c:if test="${not empty cotizacion.archivoAdjunto}">
                            <small class="form-text text-muted">Archivo actual: ${cotizacion.archivoAdjunto}</small>
                        </c:if>
                    </div>

                    <div class="col-12">
                        <label for="condiciones" class="form-label"><strong>Condiciones y Comentarios:</strong></label>
                        <form:textarea path="condiciones" id="condiciones" class="form-control" rows="3"/>
                    </div>
                </div>

                <hr class="my-4">

                <h5 class="mt-4">Detalles de Productos</h5>
                <table class="table table-bordered" id="tablaDetalles">
                    <thead class="table-light">
                        <tr>
                            <th>Producto</th>
                            <th style="width: 15%;">Cantidad</th>
                            <th style="width: 20%;">Precio Unitario</th>
                            <th style="width: 5%;"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="detalle" items="${cotizacion.detalles}" varStatus="status">
                            <tr>
                                <td>
                                    <form:hidden path="detalles[${status.index}].idCotizacionDetalle"/>
                                    <form:select path="detalles[${status.index}].producto.idProducto" class="form-select">
                                        <c:forEach var="prod" items="${productos}">
                                            <form:option value="${prod.idProducto}" label="${prod.nombre}"/>
                                        </c:forEach>
                                    </form:select>
                                </td>
                                <td>
                                    <form:input type="number" path="detalles[${status.index}].cantidad" class="form-control" min="1"/>
                                </td>
                                <td>
                                    <form:input type="number" step="0.01" path="detalles[${status.index}].precioUnitario" class="form-control"/>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-danger btn-sm" onclick="this.closest('tr').remove()">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <button type="button" class="btn btn-info btn-sm mt-2" id="btnAgregarFila">
                    <i class="fas fa-plus"></i> Agregar Producto
                </button>

                <div class="mt-4 d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/cotizaciones/ver/${cotizacion.idCotizacion}" class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i>Cancelar
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Guardar Cambios
                    </button>
                </div>

            </form:form>
        </div>
    </div>
</div>

<script>
    document.getElementById('btnAgregarFila').addEventListener('click', function() {
        const tabla = document.getElementById('tablaDetalles').getElementsByTagName('tbody')[0];
        const nuevaFila = tabla.insertRow();
        const index = tabla.rows.length - 1;

        nuevaFila.innerHTML = `
            <td>
                <select name="detalles[\${index}].producto.idProducto" class="form-select">
                    <c:forEach var="prod" items="${productos}">
                        <option value="${prod.idProducto}">${prod.nombre}</option>
                    </c:forEach>
                </select>
            </td>
            <td>
                <input type="number" name="detalles[\${index}].cantidad" class="form-control" min="1" value="1" />
            </td>
            <td>
                <input type="number" step="0.01" name="detalles[\${index}].precioUnitario" class="form-control" value="0.0" />
            </td>
            <td>
                <button type="button" class="btn btn-danger btn-sm" onclick="this.closest('tr').remove()">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        `;
    });
</script>

</body>
</html>