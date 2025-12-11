<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Panel de Administración - Maderera</title>
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
                            <li class="active"><a href="${pageContext.request.contextPath}/dashboard"><i
                                        class="fas fa-home"></i> Inicio</a></li>
                            <li><a href="${pageContext.request.contextPath}/productos/listar"><i
                                        class="fas fa-boxes"></i> Productos</a></li>
                            <li><a href="${pageContext.request.contextPath}/proveedores/listar"><i
                                        class="fas fa-truck"></i> Proveedores</a></li>
                            <li><a href="${pageContext.request.contextPath}/compras"><i class="fas fa-boxes"></i>
                                    Compras</a></li>
                            <li><a href="${pageContext.request.contextPath}/ventas/listar"><i
                                        class="fas fa-cash-register"></i> Ventas</a></li>
                            <li><a href="${pageContext.request.contextPath}/inventario/listar"><i
                                        class="fas fa-warehouse"></i> Inventario</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/listar-empleados"><i
                                        class="fas fa-users"></i> Usuarios</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/backup"><i
                                        class="fas fa-database"></i> Backups</a></li>
                        </ul>
                    </nav>
                    <div class="logout-button">
                        <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Cerrar
                            Sesión</a>
                    </div>
                </div>

                <div class="main-content">
                    <header class="main-header">
                        <h1>Panel de Control General</h1>
                        <div class="user-info">Bienvenido, Administrador</div>
                    </header>

                    <div class="info-cards-grid">

                        <div class="info-card">
                            <i class="fas fa-boxes card-icon"></i>
                            <div class="card-title">Total Productos</div>
                            <div class="card-value">
                                <c:out value="${totalProductos}" />
                            </div>
                        </div>

                        <div class="info-card green">
                            <i class="fas fa-truck card-icon"></i>
                            <div class="card-title">Total Proveedores</div>
                            <div class="card-value">
                                <c:out value="${totalProveedores}" />
                            </div>
                        </div>

                        <div class="info-card red">
                            <i class="fas fa-exclamation-triangle card-icon"></i>
                            <div class="card-title">Alertas de Stock</div>
                            <div class="card-value">
                                <c:out value="${alertasStock}" />
                            </div>
                        </div>

                        <div class="info-card yellow">
                            <i class="fas fa-users card-icon"></i>
                            <div class="card-title">Usuarios Activos</div>
                            <div class="card-value">
                                <c:out value="${usuariosActivos}" />
                            </div>
                        </div>

                    </div>

                    <section>
                        <h3>Resumen del Sistema</h3>
                        <p>Desde este panel puedes gestionar todos los módulos del sistema. Utiliza el menú lateral para
                            acceder a secciones específicas como Inventario o Empleados. Las tarjetas de arriba muestran
                            los indicadores clave de rendimiento (KPIs).</p>
                        <br>
                        <button class="btn">Generar Reporte Mensual</button>
                    </section>

                    <section>
                        <h3>Productos Recientes / Alertas</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>Código</th>
                                    <th>Nombre</th>
                                    <th>Stock Actual</th>
                                    <th>Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="producto" items="${productosBajoStock}">
                                    <tr>
                                        <td>
                                            <c:out value="${producto.producto.codigo}" />
                                        </td>
                                        <td>
                                            <c:out value="${producto.producto.nombre}" />
                                        </td>
                                        <td>
                                            <c:out value="${producto.stockActual}" />
                                        </td>
                                        <td><a href="${pageContext.request.contextPath}/inventario/reabastecer?id=<c:out value="
                                                ${producto.producto.idProducto}" />" class="btn-action">Reabastecer</a>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <tr>
                                    <td>MDR001</td>
                                    <td>Pino Insigne 2x4</td>
                                    <td>12</td>
                                    <td style="color: #e74c3c; font-weight: 600;">Stock Bajo</td>
                                </tr>
                                <tr>
                                    <td>MDR005</td>
                                    <td>Aglomerado 18mm</td>
                                    <td>25</td>
                                    <td><button class="btn-small">Ver</button></td>
                                </tr>
                            </tbody>
                        </table>
                    </section>

                    <%-- SECCIÓN AÑADIDA: ÚLTIMOS PEDIDOS DE COMPRA --%>
                        <section>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <h3>Últimos Pedidos de Compra</h3>
                                <a href="${pageContext.request.contextPath}/admin/pedidos-compra" class="btn-small">Ver
                                    Todos</a>
                            </div>
                            <table>
                                <thead>
                                    <tr>
                                        <th>N° Pedido</th>
                                        <th>Proveedor</th>
                                        <th>Fecha</th>
                                        <th>Estado</th>
                                        <th style="text-align: right;">Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${pedidosRecientes}" var="pedido">
                                        <tr>
                                            <td>
                                                <c:out value="${pedido.numeroPedido}" />
                                            </td>
                                            <td>
                                                <c:out value="${pedido.proveedor.nombre}" />
                                            </td>
                                            <td>
                                                <c:out value="${pedido.fechaPedido}" />
                                            </td>
                                            <td><span class="badge"
                                                    style="background-color: #3498db; color: white; padding: 5px 10px; border-radius: 12px;">
                                                    <c:out value="${pedido.estado}" />
                                                </span></td>
                                            <td style="text-align: right;">S/
                                                <fmt:formatNumber value="${pedido.total}" type="number"
                                                    minFractionDigits="2" maxFractionDigits="2" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty pedidosRecientes}">
                                        <tr>
                                            <td colspan="5" style="text-align: center;">No hay pedidos de compra
                                                recientes.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </section>
                </div>

            </body>

            </html>