<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Gestión de Ventas</title>
                <link rel="stylesheet" href="<c:url value='/Styles/dashboard.css'/>">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
            </head>

            <body>

                <div class="sidebar">
                    <div class="logo">
                        <h2>LA MADERERA</h2>
                    </div>
                    <nav>
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/dashboard"><i class="fas fa-home"></i>
                                    Inicio</a></li>
                            <li><a href="${pageContext.request.contextPath}/productos/listar"><i
                                        class="fas fa-boxes"></i> Productos</a></li>
                            <li><a href="${pageContext.request.contextPath}/proveedores/listar"><i
                                        class="fas fa-truck"></i> Proveedores</a></li>
                            <li><a href="${pageContext.request.contextPath}/compras"><i class="fas fa-boxes"></i>
                                    Compras</a></li>
                            <li class="active"><a href="${pageContext.request.contextPath}/ventas/listar"><i
                                        class="fas fa-cash-register"></i> Ventas</a></li>
                            <li><a href="${pageContext.request.contextPath}/inventario/listar"><i
                                        class="fas fa-warehouse"></i> Inventario</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/listar-empleados"><i
                                        class="fas fa-users"></i> Usuarios</a></li>
                        </ul>
                    </nav>
                    <div class="logout-button"><a href="${pageContext.request.contextPath}/logout"><i
                                class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></div>
                </div>

                <div class="main-content">
                    <header class="main-header">
                        <h1>Listado de Ventas</h1>
                        <a href="${pageContext.request.contextPath}/ventas/nueva" class="btn btn-primary"><i
                                class="fas fa-plus"></i> Registrar Nueva Venta</a>
                    </header>

                    <section>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID Venta</th>
                                    <th>Fecha</th>
                                    <th>Cliente</th>
                                    <th style="text-align: right;">Total</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="venta" items="${ventas}">
                                    <tr>
                                        <td>#
                                            <c:out value="${venta.id}" />
                                        </td>
                                        <td>
                                            <c:out value="${venta.fecha}" />
                                        </td>
                                        <td>
                                            <c:out value="${venta.usuario.nombresApellidos}" />
                                        </td>
                                        <td style="text-align: right;">S/
                                            <fmt:formatNumber value="${venta.total}" type="number" minFractionDigits="2"
                                                maxFractionDigits="2" />
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/ventas/ver/${venta.id}"
                                                class="btn-action view"><i class="fas fa-eye"></i> Ver</a>
                                            <a href="${pageContext.request.contextPath}/guias/salida/${venta.id}"
                                                target="_blank" class="btn-action"
                                                style="background: #2563eb; margin-left: 5px;" title="Imprimir Guía">
                                                <i class="fas fa-file-alt"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </section>
                </div>

            </body>

            </html>