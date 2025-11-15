<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Listado de Productos</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
</head>
<body>

<h2>Lista de Productos</h2>

<a href="${pageContext.request.contextPath}/productos/nuevo"><button>Registrar Producto</button>
    <a href="${pageContext.request.contextPath}/admin/admin-dashboard" class="btn-agregar">Regresar</a>

</a>

<table border="1" cellpadding="8" cellspacing="0">
    <thead>
        <tr>
            <th>ID</th>
            <th>Código</th>
            <th>Nombre</th>
            <th>Categoría</th>
            <th>Proveedor</th>
            <th>Precio Compra</th>
            <th>Precio Venta</th>
            <th>Acciones</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="p" items="${productos}">
            <tr>
                <td>${p.id_producto}</td>
                <td>${p.codigo}</td>
                <td>${p.nombre}</td>
                <td>${p.categoria.nombre}</td>
                <td>${p.proveedor.nombre}</td>
                <td>${p.precio_compra}</td>
                <td>${p.precio_venta}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/productos/editar/${p.id_producto}">Editar</a> |
                    <a href="${pageContext.request.contextPath}/productos/eliminar/${p.id_producto}"
                       onclick="return confirm('¿Desea eliminar este producto?');">Eliminar</a>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>
</html>
