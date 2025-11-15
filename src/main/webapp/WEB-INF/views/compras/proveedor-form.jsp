<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>
<head>
    <title>Registro de Proveedor</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
</head>
<body>

<h2>Registro de Proveedor</h2>

<c:if test="${not empty error}">
    <div class="error">${error}</div>
</c:if>
<c:if test="${not empty exito}">
    <div class="exito">${exito}</div>
</c:if>

<form:form method="post" modelAttribute="proveedor" action="${pageContext.request.contextPath}/proveedores/guardar">
    <form:hidden path="idProveedor"/>
    
    <label>Nombre:</label>
    <form:input path="nombre"/><form:errors path="nombre" cssClass="error"/><br>

    <label>RUC:</label>
    <form:input path="ruc"/><form:errors path="ruc" cssClass="error"/><br>

    <label>Teléfono:</label>
    <form:input path="telefono"/><form:errors path="telefono" cssClass="error"/><br>

    <label>Correo:</label>
    <form:input path="correo"/><form:errors path="correo" cssClass="error"/><br>

    <label>Dirección:</label>
    <form:input path="direccion"/><form:errors path="direccion" cssClass="error"/><br>

    <button type="submit">Guardar</button>
    <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/proveedores/listar'">Retornar</button>
</form:form>

</body>
</html>

