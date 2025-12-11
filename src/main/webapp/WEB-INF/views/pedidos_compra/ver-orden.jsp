<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Detalle de Orden de Compra</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

                <style>
                    .container {
                        max-width: 900px;
                    }

                    .card-header {
                        background-color: #343a40;
                        color: white;
                    }
                </style>
            </head>

            <body class="bg-light">

                <div class="container mt-5">
                    <div class="card shadow">

                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h4 class="mb-0">
                                <i class="fas fa-file-invoice me-2"></i>
                                Orden de Compra: <strong>${orden.numeroOrden}</strong>
                            </h4>
                            <span class="badge bg-warning text-dark fs-6">${orden.estado}</span>
                        </div>

                        <div class="card-body">

                            <div class="row mb-4 p-3 bg-white rounded border">
                                <div class="col-md-6">
                                    <h6 class="text-muted text-uppercase fw-bold">Proveedor</h6>
                                    <p class="fs-5 mb-0 text-primary">
                                        <i class="fas fa-building me-2"></i>
                                        ${orden.proveedor != null ? orden.proveedor.nombre : 'Proveedor No Asignado'}
                                    </p>
                                </div>
                                <div class="col-md-6 text-md-end">
                                    <h6 class="text-muted text-uppercase fw-bold">Fecha de Emisión</h6>
                                    <p class="fs-5 mb-0">
                                        <i class="far fa-calendar-alt me-2"></i>
                                        ${orden.fecha}
                                    </p>
                                </div>
                            </div>

                            <h5 class="mb-3 text-secondary border-bottom pb-2">Detalle de Productos</h5>

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

                                        <c:forEach var="det" items="${orden.detalles}" varStatus="status">
                                            <c:set var="subtotal" value="${det.cantidad * det.precioUnitario}" />
                                            <c:set var="granTotal" value="${granTotal + subtotal}" />

                                            <tr>
                                                <td class="text-center">${status.count}</td>
                                                <td>
                                                    <strong>${det.producto.nombre}</strong>
                                                </td>
                                                <td class="text-center">${det.cantidad}</td>
                                                <td class="text-end">
                                                    S/
                                                    <fmt:formatNumber value="${det.precioUnitario}"
                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                </td>
                                                <td class="text-end fw-bold">
                                                    S/
                                                    <fmt:formatNumber value="${subtotal}" minFractionDigits="2"
                                                        maxFractionDigits="2" />
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty orden.detalles}">
                                            <tr>
                                                <td colspan="5" class="text-center text-muted py-3">
                                                    No hay productos registrados en esta orden.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>

                                    <tfoot class="table-dark">
                                        <tr>
                                            <td colspan="4" class="text-end fw-bold fs-5">TOTAL GENERAL:</td>
                                            <td class="text-end fw-bold fs-5">
                                                S/
                                                <fmt:formatNumber value="${granTotal}" minFractionDigits="2"
                                                    maxFractionDigits="2" />
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>

                        </div>

                        <div class="card-footer bg-white d-flex justify-content-between py-3">
                            <a href="${pageContext.request.contextPath}/ordenes-compra/listado"
                                class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i> Volver al Listado
                            </a>

                            <div>
                                <a href="${pageContext.request.contextPath}/guias/entrada/orden/${orden.idOrden}"
                                    target="_blank" class="btn btn-success me-2">
                                    <i class="fas fa-file-alt me-1"></i> Guía de Entrada
                                </a>
                                <a href="${pageContext.request.contextPath}/ordenes-compra/editar/${orden.idOrden}"
                                    class="btn btn-primary me-2">
                                    <i class="fas fa-edit me-1"></i> Editar
                                </a>
                                <button class="btn btn-danger" onclick="window.print()">
                                    <i class="fas fa-print me-1"></i> Imprimir / PDF
                                </button>
                            </div>
                        </div>

                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>