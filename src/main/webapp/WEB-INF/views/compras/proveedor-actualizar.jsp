<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <title>Actualizar Proveedor</title>
    <link rel="stylesheet" href="<c:url value='/Styles/registrar.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

    <div class="form-wrapper">

        <h2>Actualizar Proveedor</h2>

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

        <form:form method="post" modelAttribute="proveedor" action="${pageContext.request.contextPath}/proveedores/guardar">
            <form:hidden path="idProveedor"/>
            
            <div class="form-grid-2">
                
                <div>
                    <label for="nombre">Nombre:</label>
                    <form:input path="nombre" id="nombre"/>
                    <form:errors path="nombre" cssClass="mensaje-error"/>
                </div>
                <div>
                    <label for="ruc">RUC:</label>
                    <form:input path="ruc" id="ruc"/>
                    <form:errors path="ruc" cssClass="mensaje-error"/>
                </div>
                <div>
                    <label for="telefono">Teléfono:</label>
                    <form:input path="telefono" id="telefono"/>
                    <form:errors path="telefono" cssClass="mensaje-error"/>
                </div>
                
                <div>
                    <label for="correo">Correo:</label>
                    <form:input path="correo" id="correo"/>
                    <form:errors path="correo" cssClass="mensaje-error"/>
                </div>
                <div>
                    <label for="direccion">Dirección:</label>
                    <form:input path="direccion" id="direccion"/>
                    <form:errors path="direccion" cssClass="mensaje-error"/>
                </div>
                <div></div>

            </div> <div class="button-group">
                <a href="${pageContext.request.contextPath}/proveedores/listar" class="btn-cancelar">
                    <i class="fas fa-times-circle"></i> Cancelar
                </a>
                <button type="submit">
                    <i class="fas fa-save"></i> Actualizar
                </button>
            </div>
        </form:form>
    </div> </body>
</html>