<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Usuario</title>
    <link rel="stylesheet" href="<c:url value='/Styles/registrar.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    
    <div class="form-wrapper">
        
        <h2>Editar Usuario</h2>
        
        <c:if test="${not empty error}">
            <div class="mensaje-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        <c:if test="${not empty exito}">
            <div class="mensaje-exito">
                <i class="fas fa-check-circle"></i> ${exito}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/empleados/actualizar" method="post">
            <input type="hidden" name="idUsuario" value="${empleado.idUsuario}">

            <div class="form-grid-2">
                
                <div>
                    <label for="nombresApellidos">Nombres y Apellidos:</label>
                    <input type="text" id="nombresApellidos" name="nombresApellidos" value="${empleado.nombresApellidos}" required>
                </div>
                <div>
                    <label for="tipoDocumento">Tipo de Documento:</label>
                    <select id="tipoDocumento" name="tipoDocumento" required>
                        <option value="DNI" ${empleado.tipoDocumento=='DNI'?'selected':''}>DNI</option>
                        <option value="Carné de extranjería" ${empleado.tipoDocumento=='Carné de extranjería'?'selected':''}>Carné de extranjería</option>
                    </select>
                </div>
                <div>
                    <label for="numeroDocumento">Número de Documento:</label>
                    <input type="text" id="numeroDocumento" name="numeroDocumento" value="${empleado.numeroDocumento}" required>
                </div>
                <div>
                    <label for="direccion">Dirección:</label>
                    <input type="text" id="direccion" name="direccion" value="${empleado.direccion}" required>
                </div>
                
                <div>
                    <label for="celular">Celular:</label>
                    <input type="text" id="celular" name="celular" value="${empleado.celular}" required>
                </div>
                <div>
                    <label for="correo">Correo Electrónico:</label>
                    <input type="email" id="correo" name="correo" value="${empleado.correo}" required>
                </div>
                <div>
                    <label for="contrasena">Contraseña:</label>
                    <input type="password" id="contrasena" name="contrasena" value="${empleado.contrasena}" required>
                </div>
                <div>
                    <label for="idRol">Rol:</label>
                    <select id="idRol" name="idRol" required>
                        <c:forEach var="rol" items="${roles}">
                            <option value="${rol.idRol}" ${empleado.rol.idRol == rol.idRol ? 'selected' : ''}>${rol.nombre}</option>
                        </c:forEach>
                    </select>
                </div>

            </div> <div class="button-group">
                <a href="${pageContext.request.contextPath}/admin/listar-empleados" class="btn-cancelar">
                    <i class="fas fa-times-circle"></i> Cancelar
                </a>
                <button type="submit">
                    <i class="fas fa-save"></i> Actualizar
                </button>
            </div>
        </form>
    </div> </body>
</html>