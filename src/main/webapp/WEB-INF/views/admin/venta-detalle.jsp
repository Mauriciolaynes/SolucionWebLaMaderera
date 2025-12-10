<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Detalle de Venta #${venta.id}</title>
    <link rel="stylesheet" href="<c:url value='/Styles/dashboard.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .detalle-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
        .detalle-info p { margin: 5px 0; }
        .total-section { text-align: right; font-size: 1.5em; font-weight: bold; margin-top: 20px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="logo"><h2>LA MADERERA</h2></div>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/dashboard"><i class="fas fa-home"></i> Inicio</a></li>
                <li><a href="${pageContext.request.contextPath}/productos/listar"><i class="fas fa-boxes"></i> Productos</a></li>
                <li><a href="${pageContext.request.contextPath}/proveedores/listar"><i class="fas fa-truck"></i> Proveedores</a></li>
                <li><a href="${pageContext.request.contextPath}/compras"><i class="fas fa-boxes"></i> Compras</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/ventas/listar"><i class="fas fa-cash-register"></i> Ventas</a></li>
                <li><a href="${pageContext.request.contextPath}/inventario/listar"><i class="fas fa-warehouse"></i> Inventario</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/listar-empleados"><i class="fas fa-users"></i> Usuarios</a></li>
            </ul>
        </nav>
        <div class="logout-button"><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></div>
    </div>

    <div class="main-content">
        <header class="main-header">
            <h1>Detalle de Venta #${venta.id}</h1>
            <a href="${pageContext.request.contextPath}/ventas/listar" class="btn"><i class="fas fa-arrow-left"></i> Volver al Listado</a>
        </header>

        <section>
            <div class="detalle-grid">
                <div class="detalle-info">
                    <h3>Información del Cliente</h3>
                    <p><strong>Nombre:</strong> <c:out value="${venta.usuario.nombresApellidos}"/></p>
                    <p><strong>Documento:</strong> <c:out value="${venta.usuario.tipoDocumento}"/> - <c:out value="${venta.usuario.numeroDocumento}"/></p>
                    <p><strong>Correo:</strong> <c:out value="${venta.usuario.correo}"/></p>
                </div>
                <div class="detalle-info" style="text-align: right;">
                    <h3>Información de la Venta</h3>
                    <p><strong>Fecha:</strong> <fmt:formatDate value="${venta.fecha}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                </div>
            </div>

            <h3>Productos Vendidos</h3>
            <table>
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th style="text-align: right;">Precio Unit.</th>
                        <th style="text-align: right;">Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="detalle" items="${venta.detalles}">
                        <tr>
                            <td><c:out value="${detalle.producto.nombre}"/></td>
                            <td><c:out value="${detalle.cantidad}"/></td>
                            <td style="text-align: right;">S/ <fmt:formatNumber value="${detalle.precioUnitario}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td style="text-align: right;">S/ <fmt:formatNumber value="${detalle.precioUnitario * detalle.cantidad}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="total-section">
                Total Venta: S/ <fmt:formatNumber value="${venta.total}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
            </div>
        </section>
    </div>

</body>
</html>