<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalle de Cotización</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <style>
        .container { max-width: 900px; }
        .card-header { background-color: #2980b9; color: white; } /* Azul para Cotizaciones */
    </style>
</head>
<body class="bg-light">

    <div class="container mt-5">
        <div class="card shadow">
            
            <div class="card-header d-flex justify-content-between align-items-center">
                <h4 class="mb-0">
                    <i class="fas fa-calculator me-2"></i>
                    Cotización: <strong>${cotizacion.numeroCotizacion}</strong>
                </h4>
                
                <c:choose>
                    <c:when test="${cotizacion.estado.toString() == 'APROBADA'}">
                        <span class="badge bg-success fs-6">APROBADA</span>
                    </c:when>
                    <c:when test="${cotizacion.estado.toString() == 'RECHAZADA'}">
                        <span class="badge bg-danger fs-6">RECHAZADA</span>
                    </c:when>
                    <c:when test="${cotizacion.estado.toString() == 'ORDEN_GENERADA'}">
                        <span class="badge bg-info text-dark fs-6">ORDEN GENERADA</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-warning text-dark fs-6">${cotizacion.estado}</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card-body">
                
                <div class="row mb-4 p-3 bg-white rounded border">
                    <div class="col-md-6">
                        <h6 class="text-muted text-uppercase fw-bold">Proveedor</h6>
                        <p class="fs-5 mb-0 text-primary">
                            <i class="fas fa-building me-2"></i>
                            ${cotizacion.proveedor != null ? cotizacion.proveedor.nombre : 'Sin Proveedor'}
                        </p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <h6 class="text-muted text-uppercase fw-bold">Fecha de Emisión</h6>
                        <p class="fs-5 mb-0">
                            <i class="far fa-calendar-alt me-2"></i>
                            ${cotizacion.fecha}
                        </p>
                    </div>
                </div>

                <h5 class="mb-3 text-secondary border-bottom pb-2">Productos Cotizados</h5>
                
                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-hover align-middle">
                        <thead class="table-secondary text-center">
                            <tr>
                                <th>#</th>
                                <th class="text-start">Producto</th>
                                <th>Cantidad</th>
                                <th class="text-end">Precio Unit.</th>
                                <th class="text-end">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="granTotal" value="0" />
                            
                            <c:forEach var="det" items="${cotizacion.detalles}" varStatus="status">
                                <c:set var="subtotal" value="${det.cantidad * det.precioUnitario}" />
                                <c:set var="granTotal" value="${granTotal + subtotal}" />
                                
                                <tr>
                                    <td class="text-center">${status.count}</td>
                                    <td><strong>${det.producto.nombre}</strong></td>
                                    <td class="text-center">${det.cantidad}</td>
                                    <td class="text-end">
                                        S/ <fmt:formatNumber value="${det.precioUnitario}" minFractionDigits="2" maxFractionDigits="2"/>
                                    </td>
                                    <td class="text-end fw-bold">
                                        S/ <fmt:formatNumber value="${subtotal}" minFractionDigits="2" maxFractionDigits="2"/>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty cotizacion.detalles}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-3">
                                        No hay productos registrados en esta cotización.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                        <tfoot class="table-dark">
                            <tr>
                                <td colspan="4" class="text-end fw-bold fs-5">TOTAL ESTIMADO:</td>
                                <td class="text-end fw-bold fs-5">
                                    S/ <fmt:formatNumber value="${granTotal}" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

            </div>

            <div class="card-footer bg-white d-flex justify-content-between py-3">
                
                <a href="${pageContext.request.contextPath}/compras" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i> Volver
                </a>
                
                <div class="btn-group">
                    
                    <c:if test="${cotizacion.estado.toString() == 'POR_EVALUAR' || cotizacion.estado.toString() == 'EN_EVALUACION'}">
                        <a href="${pageContext.request.contextPath}/cotizaciones/editar/${cotizacion.idCotizacion}" class="btn btn-primary me-2">
                            <i class="fas fa-edit me-1"></i> Editar
                        </a>
                    </c:if>

                    <c:if test="${cotizacion.estado.toString() == 'APROBADA'}">
                        <form action="${pageContext.request.contextPath}/compras/cotizaciones/${cotizacion.idCotizacion}/generar-orden" method="post" style="display:inline;">
                            <button type="submit" class="btn btn-success" onclick="return confirm('¿Estás seguro de generar la Orden de Compra?');">
                                <i class="fas fa-file-contract me-1"></i> Generar Orden
                            </button>
                        </form>
                    </c:if>

                    <button class="btn btn-danger ms-2" onclick="window.print()">
                        <i class="fas fa-print"></i>
                    </button>
                </div>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>