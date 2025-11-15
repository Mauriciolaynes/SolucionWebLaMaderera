<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Listado de Empleados</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
</head>
<body>
    <h2>Gestión de Empleados</h2>

    <c:if test="${not empty error}">
        <div style="color:red">${error}</div>
    </c:if>
    <c:if test="${not empty exito}">
        <div style="color:green">${exito}</div>
    </c:if>

    <a href="${pageContext.request.contextPath}/admin/form-empleado" class="btn-agregar">+ Registrar Empleado</a>
    <a href="${pageContext.request.contextPath}/admin/admin-dashboard" class="btn-agregar">Regresar</a>
	
	 <!-- FORMULARIO DE BÚSQUEDA -->
	<form action="${pageContext.request.contextPath}/admin/listar-empleados" method="get" style="margin-top: 20px;">
	    <label>Nombre:</label>
	    <input type="text" name="nombre" value="${param.nombre}" placeholder="Buscar por nombre">
	
	    <label>Rol:</label>
	    <select name="rolId">
	        <option value="">-- Todos --</option>
	        <c:forEach var="rol" items="${roles}">
	            <option value="${rol.idRol}" <c:if test="${param.rolId != null && param.rolId == rol.idRol.toString()}">selected</c:if>>
	                ${rol.nombre}
	            </option>
	        </c:forEach>
	    </select>
	
	    <button type="submit">Buscar</button>
	</form>
    </form>
	
    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>DNI</th>
                <th>Nombre y Apellido</th>
                <th>Correo</th>
                <th>Rol</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="emp" items="${empleados}">
                <tr>
                    <td>${emp.idUsuario}</td>
                    <td>${emp.numeroDocumento}</td>
                    <td>${emp.nombresApellidos}</td>
                    <td>${emp.correo}</td>
                    <td>${emp.rol.nombre}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/empleados/editar/${emp.idUsuario}" class="btn-editar">Editar</a>&nbsp&nbsp
                        <a href="${pageContext.request.contextPath}/admin/empleados/eliminar/${emp.idUsuario}" class="btn-eliminar" 
                        onclick="return confirm('¿Seguro que desea eliminar?');">Eliminar</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
