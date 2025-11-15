<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registrar Empleado</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
</head>
<body>
    <h2>Registrar Empleado</h2>

    <c:if test="${not empty error}">
        <div style="color:red">${error}</div>
    </c:if>
    <c:if test="${not empty exito}">
        <div style="color:green">${exito}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/guardarEmpleado" method="post">
        <label>Nombres y Apellidos:</label>
        <input type="text" name="nombresApellidos" required>

        <label>Tipo de Documento:</label>
        <select name="tipoDocumento" required>
        	<option value="#">Seleccionar</option>
            <option value="DNI">DNI</option>
            <option value="Carné de extranjería">Carné de extranjería</option>
        </select>

        <label>Número de Documento:</label>
        <input type="text" name="numeroDocumento" required>

        <label>Dirección:</label>
        <input type="text" name="direccion" required>

        <label>Celular:</label>
        <input type="text" name="celular" required>

        <label>Correo Electrónico:</label>
        <input type="email" name="correo" required>

        <label>Contraseña:</label>
        <input type="password" name="contrasena" required>

        <label>Rol:</label>
        <select name="idRol" required>
            <c:forEach var="rol" items="${roles}">
                <option value="${rol.idRol}">${rol.nombre}</option>
            </c:forEach>
        </select>

        <button type="submit">Guardar</button>
        <a href="${pageContext.request.contextPath}/admin/listar-empleados" class="btn-cancelar">Cancelar</a>
    </form>
</body>
</html>
