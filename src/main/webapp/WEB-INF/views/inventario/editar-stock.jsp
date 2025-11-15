<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Editar Stock</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-5 col-md-6">
    <h3 class="mb-4 text-center">Editar Stock del Producto</h3>

    <form method="post" action="/admin/inventario/actualizar">
        <input type="hidden" name="id.idAlmacen" value="${almacenProducto.id.idAlmacen}" />
        <input type="hidden" name="id.idProducto" value="${almacenProducto.id.idProducto}" />

        <div class="mb-3">
            <label class="form-label">Producto</label>
            <input type="text" class="form-control" value="${almacenProducto.producto.nombre}" readonly>
        </div>

        <div class="mb-3">
            <label class="form-label">Stock Actual</label>
            <input type="number" name="stockActual" class="form-control" value="${almacenProducto.stockActual}" min="0" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Stock Mínimo</label>
            <input type="number" name="stockMinimo" class="form-control" value="${almacenProducto.stockMinimo}" min="0" required>
        </div>

        <button type="submit" class="btn btn-success w-100">Guardar cambios</button>
        <a href="/admin/inventario" class="btn btn-secondary w-100 mt-2">Cancelar</a>
    </form>
</div>

</body>
</html>
