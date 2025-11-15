<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Panel de Administración - Maderera</title>
    <link rel="stylesheet" href="<c:url value='/Styles/dashboard.css'/>">
</head>
<body>
    <header class="navbar">
        <h1>Maderera - Panel de Administración</h1>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/productos/listar">Productos</a></li>
                <li><a href="${pageContext.request.contextPath}/proveedores/listar">Proveedores</a></li>
                <li><a href="${pageContext.request.contextPath}/inventario/listar">Inventario</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/listar-empleados">Empleados</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">Cerrar Sesión</a></li>
            </ul>
        </nav>
    </header>

    <main class="content">
        <section>
            <h2>Bienvenido, Administrador</h2>
            <p>Desde este panel puedes gestionar todos los módulos del sistema.</p>
        </section>
    </main>

    <footer class="footer">
        <p>© 2025 Maderera | Sistema de Gestión Interna</p>
    </footer>
</body>
</html>
