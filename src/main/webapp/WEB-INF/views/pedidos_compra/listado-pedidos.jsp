<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Listado de Pedidos de Compra</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1>Listado de Pedidos de Compra</h1>
        <a href="${pageContext.request.contextPath}/pedidos-compra/nuevo" class="btn btn-primary">Nuevo Pedido</a>
    </div>

    <table class="table table-striped table-hover">
        <thead class="table-dark">
            <tr>
                <th>N° Pedido</th>
                <th>Fecha</th>
                <th>Proveedor</th>
                <th>Estado</th>
                <th class="text-end">Total</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${listaPedidos}" var="pedido">
                <tr>
                    <td>${pedido.numeroPedido}</td>
                    <td><fmt:formatDate value="${pedido.fechaPedido}" pattern="dd/MM/yyyy" /></td>
                    <td>${pedido.proveedor.nombre}</td>
                    <td><span class="badge bg-info text-dark">${pedido.estado}</span></td>
                    <td class="text-end">S/ <fmt:formatNumber value="${pedido.total}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>