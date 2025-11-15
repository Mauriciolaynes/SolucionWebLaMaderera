<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Empleado</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
</head>
<body>
    <h2>Editar Empleado</h2>

    <form action="${pageContext.request.contextPath}/admin/empleados/actualizar" method="post">
        <input type="hidden" name="idUsuario" value="${empleado.idUsuario}">

        <label>Nombres y Apellidos:</label>
        <input type="text" name="nombresApellidos" value="${empleado.nombresApellidos}" required>

        <label>Tipo de Documento:</label>
        <select name="tipoDocumento" required>
            <option value="DNI" ${empleado.tipoDocumento=='DNI'?'selected':''}>DNI</option>
            <option value="Carné de extranjería" ${empleado.tipoDocumento=='Carné de extranjería'?'selected':''}>Carné de extranjería</option>
        </select>

        <label>Número de Documento:</label>
        <input type="text" name="numeroDocumento" value="${empleado.numeroDocumento}" required>

        <label>Dirección:</label>
        <input type="text" name="direccion" value="${empleado.direccion}" required>

        <label>Celular:</label>
        <input type="text" name="celular" value="${empleado.celular}" required>

        <label>Correo Electrónico:</label>
        <input type="email" name="correo" value="${empleado.correo}" required>

        <label>Contraseña:</label>
        <input type="password" name="contrasena" value="${empleado.contrasena}" required>

        <label>Rol:</label>
        <select name="idRol" required>
            <c:forEach var="rol" items="${roles}">
                <option value="${rol.idRol}" ${empleado.rol.idRol == rol.idRol ? 'selected' : ''}>${rol.nombre}</option>
            </c:forEach>
        </select>

        <button type="submit">Actualizar</button>
        <a href="${pageContext.request.contextPath}/admin/listar-empleados" class="btn-cancelar">Cancelar</a>
    </form>
</body>
</html>
