<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html;charset=UTF-8" %>

        <html>

        <head>
            <title>Inventario</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        </head>

        <body class="bg-light">

            <div class="container mt-5">

                <h3 class="mb-4 text-center">Inventario de Productos</h3>

                <!-- Filtro por categoría -->
                <form method="get" action="/admin/inventario" class="mb-3 row g-2">
                    <div class="col-auto">
                        <select name="categoria" class="form-select">
                            <option value="">-- Todas las categorías --</option>
                            <c:forEach var="cat" items="${categorias}">
                                <option value="${cat.idCategoria}" <c:if
                                    test="${cat.idCategoria == categoriaSeleccionada}">selected</c:if>>
                                    ${cat.nombre}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/admin/admin-dashboard" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Regresar
                        </a>
                        <button type="submit" class="btn btn-primary">Filtrar</button>
                    </div>
                </form>

                <!-- Tabla de inventario -->
                <table class="table table-bordered table-hover bg-white">
                    <thead class="table-dark">
                        <tr>
                            <th>Producto</th>
                            <th>Categoría</th>
                            <th>Stock Actual</th>
                            <th>Stock Mínimo</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${productos}">
                            <tr>
                                <td>${p.producto.nombre}</td>
                                <td>${p.producto.categoria.nombre}</td>
                                <td>${p.stockActual}</td>
                                <td>${p.stockMinimo}</td>
                                <td>
                                    <a href="/admin/inventario/editar/${p.id.idAlmacen}/${p.id.idProducto}"
                                        class="btn btn-sm btn-warning">
                                        Editar
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

            </div>
        </body>

        </html>