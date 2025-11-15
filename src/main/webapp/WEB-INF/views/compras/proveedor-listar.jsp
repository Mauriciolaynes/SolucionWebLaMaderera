<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<html>
<head>
    <title>Lista de Proveedores</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
</head>
<body>

<h2>Listado de Proveedores</h2>

<button onclick="window.location.href='${pageContext.request.contextPath}/proveedores/nuevo'">Nuevo Proveedor</button>
<button onclick="window.location.href='${pageContext.request.contextPath}/admin/admin-dashboard'">Volver</button>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Nombre</th>
        <th>RUC</th>
        <th>Teléfono</th>
        <th>Correo</th>
        <th>Dirección</th>
        <th>Acciones</th>
    </tr>

    <c:forEach var="prov" items="${proveedores}">
        <tr>
            <td>${prov.idProveedor}</td>
            <td>${prov.nombre}</td>
            <td>${prov.ruc}</td>
            <td>${prov.telefono}</td>
            <td>${prov.correo}</td>
            <td>${prov.direccion}</td>
            <td>
                <a href="${pageContext.request.contextPath}/proveedores/editar/${prov.idProveedor}">Editar</a>&nbsp&nbsp
                <a href="${pageContext.request.contextPath}/proveedores/eliminar/${prov.idProveedor}" 
                   onclick="return confirm('¿Deseas eliminar este proveedor?')">Eliminar</a>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>
