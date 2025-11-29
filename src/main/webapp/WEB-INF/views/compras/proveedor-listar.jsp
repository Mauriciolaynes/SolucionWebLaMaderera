<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Lista de Proveedores</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<div class="main-content-list">

    <h2>Listado de Proveedores</h2>

    <div class="acciones-superiores">
        
        <a href="${pageContext.request.contextPath}/proveedores/nuevo" class="btn-agregar">
            <i class="fas fa-plus"></i> Nuevo Proveedor
        </a>
        
        <!-- ===== BOTÓN AÑADIDO ===== -->
        <a href="${pageContext.request.contextPath}/pedidos-compra/nuevo" class="btn-agregar" style="background-color: #27ae60;">
            <i class="fas fa-shopping-cart"></i> Nuevo Pedido de Compra
        </a>

        <a href="${pageContext.request.contextPath}/admin/admin-dashboard" class="btn-agregar" style="background-color: #7f8c8d;">
            <i class="fas fa-arrow-left"></i> Volver
        </a>
    </div>

    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>RUC</th>
                <th>Teléfono</th>
                <th>Correo</th>
                <th>Dirección</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="prov" items="${proveedores}">
                <tr>
                    <td>${prov.idProveedor}</td>
                    <td>${prov.nombre}</td>
                    <td>${prov.ruc}</td>
                    <td>${prov.telefono}</td>
                    <td>${prov.correo}</td>
                    <td>${prov.direccion}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/proveedores/editar/${prov.idProveedor}" class="btn-editar">Editar</a>
                        <a href="${pageContext.request.contextPath}/proveedores/eliminar/${prov.idProveedor}" 
                           class="btn-eliminar"
                           onclick="return confirm('¿Deseas eliminar el proveedor ${prov.nombre}?')">Eliminar</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty proveedores}">
                <tr>
                    <td colspan="7" style="text-align: center; color: #7f8c8d; padding: 30px;">
                        No se encontraron proveedores registrados.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

</body>
</html>