<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Resumen del Pedido de Compra</title>
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
    <h2 class="mb-4">Resumen del Pedido</h2>

    <div class="card">
        <div class="card-header">
            <h4>Datos del Proveedor</h4>
        </div>
        <div class="card-body">
            <p><strong>Proveedor:</strong> ${pedidoEnProceso.proveedor.nombre}</p>
            <p><strong>RUC:</strong> ${pedidoEnProceso.proveedor.ruc}</p>
        </div>
    </div>

    <div class="card mt-4">
        <div class="card-header">
            <h4>Detalle de Productos</h4>
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Precio Unitario (S/)</th>
                        <th>Subtotal (S/)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="total" value="0" />
                    <c:forEach items="${pedidoEnProceso.detalles}" var="item">
                        <tr>
                            <td>${item.producto.nombre}</td>
                            <td>${item.cantidad}</td>
                            <td><fmt:formatNumber value="${item.precioCompra}" type="currency" currencySymbol="S/ " /></td>
                            <td><fmt:formatNumber value="${item.cantidad * item.precioCompra}" type="currency" currencySymbol="S/ " /></td>
                        </tr>
                        <c:set var="total" value="${total + (item.cantidad * item.precioCompra)}" />
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" class="text-end"><strong>Total del Pedido:</strong></td>
                        <td><strong><fmt:formatNumber value="${total}" type="currency" currencySymbol="S/ " /></strong></td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/pedidos-compra/guardar" method="post" class="mt-4 text-end">
        <%-- 
            Lógica condicional para el botón de "Volver" o "Editar".
            - Si el pedido tiene un ID, es una EDICIÓN. El botón debe llevar de vuelta al formulario de edición.
            - Si el pedido NO tiene ID, es uno NUEVO. El botón debe llevar al formulario de nuevo pedido.
        --%>
        <c:choose>
            <c:when test="${not empty pedidoEnProceso.idPedidoCompra}">
                <%-- Es una edición, volvemos a la página de editar con el ID --%>
                <a href="${pageContext.request.contextPath}/pedidos-compra/editar/${pedidoEnProceso.idPedidoCompra}" class="btn btn-secondary">Volver y Editar</a>
            </c:when>
            <c:otherwise>
                <%-- Es un pedido nuevo, volvemos a la página de nuevo --%>
                <a href="${pageContext.request.contextPath}/pedidos-compra/nuevo" class="btn btn-secondary">Cancelar y Volver</a>
            </c:otherwise>
        </c:choose>
        <button type="submit" class="btn btn-success">Confirmar y Guardar Pedido</button>
    </form>
</div>

</body>
</html>