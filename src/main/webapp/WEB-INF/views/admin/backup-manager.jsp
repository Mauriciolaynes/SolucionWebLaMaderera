<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Gestión de Backups - LA MADERERA</title>
            <link rel="stylesheet" href="<c:url value='/Styles/dashboard.css'/>">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <style>
                .alert {
                    padding: 15px;
                    margin-bottom: 20px;
                    border-radius: 8px;
                    font-weight: 500;
                }

                .alert-success {
                    background: #d4edda;
                    color: #155724;
                    border-left: 4px solid #28a745;
                }

                .alert-danger {
                    background: #f8d7da;
                    color: #721c24;
                    border-left: 4px solid #dc3545;
                }

                .backup-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 30px;
                }

                .btn {
                    padding: 12px 24px;
                    border-radius: 8px;
                    border: none;
                    cursor: pointer;
                    font-size: 16px;
                    font-weight: 600;
                    transition: all 0.3s;
                    text-decoration: none;
                    display: inline-block;
                }

                .btn-primary {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                }

                .btn-primary:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
                }

                .btn-action {
                    padding: 8px 16px;
                    border-radius: 6px;
                    font-size: 14px;
                    margin: 0 5px;
                    text-decoration: none;
                    display: inline-block;
                    border: none;
                    cursor: pointer;
                    transition: all 0.2s;
                }

                .btn-action.download {
                    background: #3498db;
                    color: white;
                }

                .btn-action.restore {
                    background: #16a34a;
                    color: white;
                }

                .btn-action.delete {
                    background: #e74c3c;
                    color: white;
                }

                .btn-action:hover {
                    transform: scale(1.05);
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    background: white;
                    border-radius: 12px;
                    overflow: hidden;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }

                thead {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                }

                th {
                    padding: 16px;
                    text-align: left;
                    font-weight: 600;
                    text-transform: uppercase;
                    font-size: 14px;
                }

                td {
                    padding: 16px;
                    border-bottom: 1px solid #e2e8f0;
                }

                tbody tr:hover {
                    background: #f8fafc;
                }

                .empty-state {
                    text-align: center;
                    padding: 60px 20px;
                    color: #94a3b8;
                }

                .empty-state i {
                    font-size: 64px;
                    margin-bottom: 20px;
                    display: block;
                }

                .info-box {
                    background: #e0f2fe;
                    border-left: 4px solid #0ea5e9;
                    padding: 16px;
                    border-radius: 8px;
                    margin-bottom: 24px;
                }

                .info-box h4 {
                    margin: 0 0 8px 0;
                    color: #0c4a6e;
                }

                .info-box p {
                    margin: 0;
                    color: #075985;
                }
            </style>
        </head>

        <body>
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="logo">
                    <h2>LA MADERERA</h2>
                </div>
                <nav>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/admin/admin-dashboard"><i class="fas fa-home"></i>
                                Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/productos/listar"><i class="fas fa-box"></i>
                                Productos</a></li>
                        <li><a href="${pageContext.request.contextPath}/ventas/listar"><i
                                    class="fas fa-shopping-cart"></i> Ventas</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/backup" class="active"><i
                                    class="fas fa-database"></i> Backups</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/listar-empleados"><i
                                    class="fas fa-users"></i> Usuarios</a></li>
                    </ul>
                </nav>
                <div class="logout-button">
                    <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Cerrar
                        Sesión</a>
                </div>
            </div>

            <!-- Contenido Principal -->
            <div class="main-content">
                <div class="backup-header">
                    <h1><i class="fas fa-database"></i> Gestión de Backups</h1>
                    <form action="${pageContext.request.contextPath}/admin/backup/generar" method="post">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-plus-circle"></i> Generar Nuevo Backup
                        </button>
                    </form>
                </div>

                <!-- Mensajes Flash -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${success}
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <!-- Información -->
                <div class="info-box">
                    <h4><i class="fas fa-info-circle"></i> Información Importante</h4>
                    <p>
                        • Los backups se almacenan en: <strong>C:/backups_maderera/</strong><br>
                        • Al restaurar un backup, se perderán TODOS los datos actuales<br>
                        • Los backups incluyen estructura y datos de todas las tablas
                    </p>
                </div>

                <!-- Tabla de Backups -->
                <section>
                    <h3>Backups Disponibles</h3>

                    <c:choose>
                        <c:when test="${empty backups}">
                            <div class="empty-state">
                                <i class="fas fa-folder-open"></i>
                                <h3>No hay backups disponibles</h3>
                                <p>Genera tu primer backup usando el botón superior</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table>
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-file-alt"></i> Archivo</th>
                                        <th><i class="fas fa-weight"></i> Tamaño</th>
                                        <th><i class="fas fa-calendar"></i> Fecha de Creación</th>
                                        <th><i class="fas fa-cogs"></i> Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="backup" items="${backups}">
                                        <tr>
                                            <td>
                                                <i class="fas fa-file-code"></i>
                                                <strong>${backup.nombre}</strong>
                                            </td>
                                            <td>${backup.tamanoFormatado}</td>
                                            <td>${backup.fechaFormateada}</td>
                                            <td>
                                                <!-- Descargar -->
                                                <a href="${pageContext.request.contextPath}/admin/backup/descargar/${backup.nombre}"
                                                    class="btn-action download" title="Descargar backup">
                                                    <i class="fas fa-download"></i> Descargar
                                                </a>

                                                <!-- Restaurar -->
                                                <form action="${pageContext.request.contextPath}/admin/backup/restaurar"
                                                    method="post" style="display: inline;"
                                                    onsubmit="return confirm('⚠️ ADVERTENCIA: Al restaurar este backup se perderán TODOS los datos actuales de la base de datos.\\n\\n¿Estás seguro de que deseas continuar?');">
                                                    <input type="hidden" name="nombre" value="${backup.nombre}">
                                                    <button type="submit" class="btn-action restore"
                                                        title="Restaurar backup">
                                                        <i class="fas fa-undo"></i> Restaurar
                                                    </button>
                                                </form>

                                                <!-- Eliminar -->
                                                <form action="${pageContext.request.contextPath}/admin/backup/eliminar"
                                                    method="post" style="display: inline;"
                                                    onsubmit="return confirm('¿Eliminar el backup: ${backup.nombre}?');">
                                                    <input type="hidden" name="nombre" value="${backup.nombre}">
                                                    <button type="submit" class="btn-action delete"
                                                        title="Eliminar backup">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </section>
            </div>
        </body>

        </html>