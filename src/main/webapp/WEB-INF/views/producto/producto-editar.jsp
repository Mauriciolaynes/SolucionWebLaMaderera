<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html>
<head>
    <title>Editar Producto</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
</head>
<body>

<h2>Editar Producto</h2>

	<c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty exito}">
        <div class="alert alert-success">${exito}</div>
    </c:if>

<form:form method="post" modelAttribute="producto"
           action="${pageContext.request.contextPath}/productos/guardar">

    <!-- Campo oculto para ID -->
    <form:hidden path="id_producto" />
    <form:hidden path="codigo" />

    <label>Nombre:</label>
    <form:input path="nombre" required="true"/><br>

    <label>Descripción:</label>
    <form:textarea path="descripcion"/><br>

    <label>Precio Compra:</label>
    <form:input path="precio_compra" type="number" step="0.01" required="true"/><br>

    <label>Precio Venta:</label>
    <form:input path="precio_venta" type="number" step="0.01" required="true"/><br>

    <label>Categoría:</label>
    <form:select path="categoria.idCategoria" cssClass="form-select" required="true">
        <form:options items="${categorias}" itemValue="idCategoria" itemLabel="nombre" />
    </form:select><br>

    <label>Proveedor:</label>
    <form:select path="proveedor" cssClass="form-select" required="true">
        <form:options items="${proveedores}" itemValue="idProveedor" itemLabel="nombre" />
    </form:select><br>

    <button type="submit">Actualizar</button>
    <button type="button"
            onclick="window.location.href='${pageContext.request.contextPath}/productos/listar'">
        Cancelar
    </button>

</form:form>

</body>
</html>
