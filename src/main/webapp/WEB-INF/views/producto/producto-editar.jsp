<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Producto</title>
    <link rel="stylesheet" href="<c:url value='/Styles/registrar.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

    <div class="form-wrapper">

        <h2>Editar Producto</h2>

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

        <form:form method="post" modelAttribute="producto"
                   action="${pageContext.request.contextPath}/productos/guardar">

            <%-- ¡ESTA ES LA CORRECCIÓN! --%>
            <%-- Se añade un campo oculto para enviar el ID del producto. --%>
            <%-- El 'path' debe ser 'idProducto' (camelCase), no 'id_producto'. --%>
            <form:hidden path="idProducto" />

            <div class="form-grid-2">

                <div>
                    <label for="nombre">Nombre:</label>
                    <form:input path="nombre" required="true"/>
                </div>
                <div>
                    <label for="precioCompra">Precio Compra:</label>
                    <form:input path="precioCompra" type="number" step="0.01" required="true"/>
                </div>
                <div>
                    <label for="precioVenta">Precio Venta:</label>
                    <form:input path="precioVenta" type="number" step="0.01" required="true"/>
                </div>
                <div>
                    <label for="categoria.idCategoria">Categoría:</label>
                    <form:select path="categoria.idCategoria" required="true">
                        <option value="">Seleccionar Categoría</option>
                        <form:options items="${categorias}" itemValue="idCategoria" itemLabel="nombre" />
                    </form:select>
                </div>
                <div>
                    <label for="descripcion">Descripción:</label>
                    <form:textarea path="descripcion" rows="5"/>
                </div>
                <div>
                    <label for="proveedor.idProveedor">Proveedor:</label>
                    <form:select path="proveedor.idProveedor" required="true">
                        <option value="">Seleccionar Proveedor</option>
                        <form:options items="${proveedores}" itemValue="idProveedor" itemLabel="nombre" />
                    </form:select>
                </div>
            </div>
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/productos/listar" class="btn-cancelar">
                    <i class="fas fa-times-circle"></i> Cancelar
                </a>
                <button type="submit">
                    <i class="fas fa-save"></i> Guardar Cambios
                </button>
            </div>
        </form:form>
    </div>
</body>
</html>