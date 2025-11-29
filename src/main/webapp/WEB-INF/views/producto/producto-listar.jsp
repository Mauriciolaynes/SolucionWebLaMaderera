<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Listado de Productos</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<div class="main-content-list">

    <h2>Lista de Productos</h2>

    <div class="acciones-superiores">
        <a href="${pageContext.request.contextPath}/productos/nuevo" class="btn-agregar">
            <i class="fas fa-plus"></i> Registrar Producto
        </a>
        <a href="${pageContext.request.contextPath}/admin/admin-dashboard" class="btn-agregar" style="background-color: #7f8c8d;">
            <i class="fas fa-arrow-left"></i> Regresar
        </a>
    </div>

    <table border="1" cellpadding="8" cellspacing="0">
        <thead>
            <tr>
                <th>ID</th>
                <th>Código</th>
                <th>Nombre</th>
                <th>Categoría</th>
                <th>Proveedor</th>
                <th>Precio Compra</th>
                <th>Precio Venta</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${productos}" var="producto">
                <tr>
                    <td><c:out value="${producto.idProducto}"/></td>
                    <td><c:out value="${producto.codigo}"/></td>
                    <td><c:out value="${producto.nombre}"/></td>
                    <td><c:out value="${producto.categoria.nombre}"/></td>
                    <td><c:out value="${producto.proveedor.nombre}"/></td>
                    <td><c:out value="${producto.precioCompra}"/></td>
                    <td><c:out value="${producto.precioVenta}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/productos/editar/${producto.idProducto}" class="btn-editar">Editar</a>
                        <a href="${pageContext.request.contextPath}/productos/eliminar/${producto.idProducto}"
                           class="btn-eliminar"
                           onclick="return confirm('¿Desea eliminar el producto: ${producto.nombre}?');">Eliminar</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty productos}">
                <tr>
                    <td colspan="8" style="text-align: center; color: #7f8c8d; padding: 30px;">
                        No se encontraron productos registrados.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

</body>
</html>