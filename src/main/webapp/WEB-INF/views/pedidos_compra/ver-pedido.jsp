<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Detalle de Pedido de Compra</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
            </head>

            <body class="bg-light">

                <%-- <jsp:include page="../common/navbar.jsp" /> --%>

                <div class="container mt-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <h3 class="mb-0">
                                <i class="fas fa-shopping-cart me-2"></i>
                                Detalle de Pedido: ${pedido.numeroPedido}
                            </h3>
                        </div>
                        <div class="card-body">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <h5><strong>Proveedor:</strong></h5>
                                    <p>${pedido.proveedor.nombre}</p>
                                </div>
                                <div class="col-md-3">
                                    <h5><strong>Fecha:</strong></h5>
                                    <p>${pedido.fechaPedido}</p>
                                </div>
                                <div class="col-md-3">
                                    <h5><strong>Estado:</strong></h5>
                                    <c:choose>
                                        <c:when test="${pedido.estado == 'Aprobada'}">
                                            <span class="badge bg-success fs-6">${pedido.estado}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning text-dark fs-6">${pedido.estado}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <h5 class="mt-4">Productos Solicitados</h5>
                            <hr>
                            <table class="table table-bordered table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Producto</th>
                                        <th class="text-end">Cantidad</th>
                                        <th class="text-end">Precio de Compra (Ref.)</th>
                                        <th class="text-end">Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="detalle" items="${pedido.detalles}">
                                        <tr>
                                            <td>${detalle.producto.nombre}</td>
                                            <td class="text-end">${detalle.cantidad}</td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${detalle.precioCompra}" type="currency"
                                                    currencySymbol="S/ " />
                                            </td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${detalle.cantidad * detalle.precioCompra}"
                                                    type="currency" currencySymbol="S/ " />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr class="fw-bold">
                                        <td colspan="3" class="text-end">Total General:</td>
                                        <td class="text-end fs-5">
                                            <fmt:formatNumber value="${pedido.total}" type="currency"
                                                currencySymbol="S/ " />
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>

                            <div class="mt-4 text-center">
                                <a href="${pageContext.request.contextPath}/guias/entrada/pedido/${pedido.idPedidoCompra}"
                                    target="_blank" class="btn btn-success me-2">
                                    <i class="fas fa-file-alt me-2"></i>Imprimir Guía de Entrada
                                </a>
                                <a href="${pageContext.request.contextPath}/compras" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Volver al Listado
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

            </body>

            </html>