<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalle de Cotización</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="bg-light">

    <div class="container mt-5 mb-5">
        <div class="card shadow-sm">
            <div class="card-header bg-info text-dark">
                <h3 class="mb-0">
                    <i class="fas fa-calculator me-2"></i>
                    Detalle de Cotización #${cotizacion.idCotizacion}
                </h3>
            </div>
            <div class="card-body">
                
                <div class="row mb-4">
                    <div class="col-md-4">
                        <h5><strong>Proveedor:</strong></h5>
                        <p>${cotizacion.proveedor.nombre}</p>
                    </div>
                    <div class="col-md-4">
                        <h5><strong>Fecha:</strong></h5>
                        <p>${cotizacion.fecha}</p>
                    </div>
                    <div class="col-md-4">
                        <h5><strong>Estado:</strong></h5>
                        <span class="badge bg-primary fs-6">${cotizacion.estado}</span>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <h5><strong>Pedido de Compra Asociado:</strong></h5>
                        <p>
                            <c:choose>
                                <c:when test="${cotizacion.pedido != null}">
                                    <a href="${pageContext.request.contextPath}/pedidos-compra/ver/${cotizacion.pedido.idPedidoCompra}" class="text-decoration-none">
                                        <i class="fas fa-link"></i> Ver Pedido #${cotizacion.pedido.numeroPedido}
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Sin pedido asociado</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    
                    <c:if test="${not empty cotizacion.archivoAdjunto}">
                        <div class="col-md-6">
                            <h5><strong>Archivo Adjunto:</strong></h5>
                            <p>
                                <a href="<c:url value='/uploads/cotizaciones/${cotizacion.archivoAdjunto}'/>" target="_blank" class="btn btn-sm btn-outline-secondary">
                                    <i class="fas fa-file-pdf me-1"></i> ${cotizacion.archivoAdjunto}
                                </a>
                            </p>
                        </div>
                    </c:if>
                </div>

                <h5 class="mt-4 border-bottom pb-2">Productos Cotizados</h5>
                
                <table class="table table-bordered table-hover mt-3">
                    <thead class="table-light">
                        <tr>
                            <th>Producto</th>
                            <th class="text-end">Cantidad</th>
                            <th class="text-end">Precio Unitario</th>
                            <th class="text-end">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="totalCotizacion" value="0" />
                    <c:forEach var="detalle" items="${cotizacion.detalles}">
                        <tr>
                            <td>${detalle.producto.nombre}</td>
                            <td class="text-end">${detalle.cantidad}</td>
                            <td class="text-end">
                                <fmt:formatNumber value="${detalle.precioUnitario}" type="currency" currencySymbol="S/ " />
                            </td>
                            <td class="text-end">
                                <fmt:formatNumber value="${detalle.cantidad * detalle.precioUnitario}" type="currency" currencySymbol="S/ " />
                            </td>
                        </tr>
                        <c:set var="totalCotizacion" value="${totalCotizacion + (detalle.cantidad * detalle.precioUnitario)}" />
                    </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr class="fw-bold table-active">
                            <td colspan="3" class="text-end">Total General:</td>
                            <td class="text-end fs-5">
                                <fmt:formatNumber value="${totalCotizacion}" type="currency" currencySymbol="S/ " />
                            </td>
                        </tr>
                    </tfoot>
                </table>

                <div class="mt-4 d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/compras" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Volver al Listado
                    </a>

                    <%-- Botones de acción condicionales --%>
                    <div class="btn-group" role="group">
                        <c:if test="${cotizacion.estado == 'POR_EVALUAR' || cotizacion.estado == 'EN_EVALUACION'}">
                            
                            <a href="${pageContext.request.contextPath}/cotizaciones/editar/${cotizacion.idCotizacion}" class="btn btn-primary">
                                <i class="fas fa-edit"></i> Editar
                            </a>

                            <form action="${pageContext.request.contextPath}/cotizaciones/aprobar" method="post" class="d-inline">
                                <input type="hidden" name="idCotizacion" value="${cotizacion.idCotizacion}">
                                <button type="submit" class="btn btn-success" style="border-radius: 0;">
                                    <i class="fas fa-check"></i> Aprobar
                                </button>
                            </form>

                            <form action="${pageContext.request.contextPath}/cotizaciones/rechazar" method="post" class="d-inline">
                                <input type="hidden" name="idCotizacion" value="${cotizacion.idCotizacion}">
                                <button type="submit" class="btn btn-danger" style="border-radius: 0;">
                                    <i class="fas fa-times"></i> Rechazar
                                </button>
                            </form>

                            <form action="${pageContext.request.contextPath}/cotizaciones/anular" method="post" class="d-inline">
                                <input type="hidden" name="idCotizacion" value="${cotizacion.idCotizacion}">
                                <button type="submit" class="btn btn-warning" style="border-top-left-radius: 0; border-bottom-left-radius: 0;">
                                    <i class="fas fa-ban"></i> Anular
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>