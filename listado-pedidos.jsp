<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Listado de Pedidos de Compra</title>
    <%-- Opcional: Añade CSS para mejorar la apariencia (ej. Bootstrap) --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<div class="container mt-4">
    <h1>Dashboard de Administrador</h1>
    <h2>Listado de Pedidos de Compra</h2>

    <table class="table table-striped table-hover">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Fecha de Pedido</th>
                <th>Proveedor</th>
                <th>Total</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${pedidos}" var="pedido">
                <tr>
                    <td>${pedido.id}</td>
                    <td>${pedido.fechaPedido}</td>
                    <td>${pedido.proveedor}</td>
                    <td>${pedido.total}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>