<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Listado de Usuarios</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    
    <h2>Gestión de Usuarios</h2>

    <c:if test="${not empty error}">
        <div style="color:red; background-color: #fbecec; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
    </c:if>
    <c:if test="${not empty exito}">
        <div style="color:green; background-color: #e6f7e8; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            <i class="fas fa-check-circle"></i> ${exito}
        </div>
    </c:if>

    <div class="acciones-superiores">
        <a href="${pageContext.request.contextPath}/admin/form-empleado" class="btn-agregar">
            <i class="fas fa-plus"></i> Registrar Usuario
        </a>
        <a href="${pageContext.request.contextPath}/admin/admin-dashboard" class="btn-agregar" style="background-color: #7f8c8d;">
            <i class="fas fa-arrow-left"></i> Regresar
        </a>
    </div>
	
	 <form action="${pageContext.request.contextPath}/admin/listar-empleados" method="get">
	    <div class="form-group">
	        <label for="nombre">Nombre:</label>
	        <input type="text" id="nombre" name="nombre" value="${param.nombre}" placeholder="Buscar por nombre">
	    </div>
	
	    <div class="form-group">
	        <label for="rolId">Rol:</label>
	        <select id="rolId" name="rolId">
	            <option value="">-- Todos --</option>
	            <c:forEach var="rol" items="${roles}">
	                <option value="${rol.idRol}" <c:if test="${param.rolId != null && param.rolId == rol.idRol.toString()}">selected</c:if>>
	                    ${rol.nombre}
	                </option>
	            </c:forEach>
	        </select>
	    </div>
	
	    <button type="submit">
	        <i class="fas fa-search"></i> Buscar
	    </button>
	</form>
	
    <table>
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
                        <a href="${pageContext.request.contextPath}/admin/empleados/editar/${emp.idUsuario}" class="btn-editar">Editar</a>
                        <a href="${pageContext.request.contextPath}/admin/empleados/eliminar/${emp.idUsuario}" class="btn-eliminar" 
                        onclick="return confirm('¿Seguro que desea eliminar a ${emp.nombresApellidos}?');">Eliminar</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty empleados}">
                <tr>
                    <td colspan="6" style="text-align: center; color: #7f8c8d; padding: 30px;">
                        No se encontraron empleados.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>