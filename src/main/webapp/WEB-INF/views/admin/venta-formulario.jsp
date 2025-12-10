<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registrar Venta</title>
    <link rel="stylesheet" href="<c:url value='/Styles/dashboard.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .form-group { margin-bottom: 1rem; }
        .form-control { width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ccc; }
        .total-section { text-align: right; font-size: 1.5em; font-weight: bold; margin-top: 20px; }
        #productos-agregados td { vertical-align: middle; }
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
            <h1>Registrar Nueva Venta</h1>
            <a href="${pageContext.request.contextPath}/ventas/listar" class="btn"><i class="fas fa-arrow-left"></i> Volver al Listado</a>
        </header>

        <section>
            <div class="form-group">
                <label for="usuario">Cliente:</label>
                <select id="usuario" class="form-control">
                    <option value="">-- Seleccione un cliente --</option>
                    <c:forEach var="user" items="${usuarios}">
                        <option value="${user.idUsuario}">${user.nombresApellidos} - ${user.numeroDocumento}</option>
                    </c:forEach>
                </select>
            </div>

            <hr>
            <h3>Agregar Productos</h3>
            <div style="display: flex; gap: 10px; align-items: flex-end;">
                <div class="form-group" style="flex-grow: 1;">
                    <label for="producto-selector">Producto:</label>
                    <select id="producto-selector" class="form-control">
                        <option value="">-- Seleccione un producto --</option>
                        <c:forEach var="prod" items="${productos}">
                            <option value="${prod.idProducto}" data-precio="${prod.precioVenta}">${prod.nombre} (S/ ${prod.precioVenta})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="cantidad">Cantidad:</label>
                    <input type="number" id="cantidad" class="form-control" value="1" min="1">
                </div>
                <button id="btn-agregar-producto" class="btn btn-secondary" style="height: 38px;">Agregar</button>
            </div>

            <h3>Productos en la Venta</h3>
            <table>
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Precio Unit.</th>
                        <th>Subtotal</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody id="productos-agregados">
                    <!-- Los productos se agregarán aquí dinámicamente -->
                </tbody>
            </table>

            <div class="total-section">
                Total: S/ <span id="total-venta">0.00</span>
            </div>

            <div style="text-align: right; margin-top: 20px;">
                <button id="btn-registrar-venta" class="btn btn-primary" style="font-size: 1.2em; padding: 10px 20px;">Registrar Venta</button>
            </div>
        </section>
    </div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const productosAgregados = [];

    document.getElementById('btn-agregar-producto').addEventListener('click', function() {
        const selector = document.getElementById('producto-selector');
        const productoId = selector.value;
        if (!productoId) return;

        const selectedOption = selector.options[selector.selectedIndex];
        const productoNombre = selectedOption.text.split(' (S/')[0];
        const precioUnitario = parseFloat(selectedOption.getAttribute('data-precio'));
        const cantidad = parseInt(document.getElementById('cantidad').value);

        const productoExistente = productosAgregados.find(p => p.producto.idProducto == productoId);
        if (productoExistente) {
            productoExistente.cantidad += cantidad;
        } else {
            productosAgregados.push({
                producto: { idProducto: productoId, nombre: productoNombre },
                cantidad: cantidad,
                precioUnitario: precioUnitario
            });
        }
        actualizarTablaYTotal();
    });

    function actualizarTablaYTotal() {
        const tbody = document.getElementById('productos-agregados');
        tbody.innerHTML = '';
        let totalGeneral = 0;

        productosAgregados.forEach((item, index) => {
            const subtotal = item.cantidad * item.precioUnitario;
            totalGeneral += subtotal;

            const row = `<tr>
                <td>${item.producto.nombre}</td>
                <td>${item.cantidad}</td>
                <td>S/ ${item.precioUnitario.toFixed(2)}</td>
                <td>S/ ${subtotal.toFixed(2)}</td>
                <td><button class="btn-action delete" data-index="${index}"><i class="fas fa-trash"></i></button></td>
            </tr>`;
            tbody.innerHTML += row;
        });

        document.getElementById('total-venta').textContent = totalGeneral.toFixed(2);

        // Añadir listeners a los botones de eliminar
        document.querySelectorAll('.btn-action.delete').forEach(btn => {
            btn.addEventListener('click', function() {
                const index = this.getAttribute('data-index');
                productosAgregados.splice(index, 1);
                actualizarTablaYTotal();
            });
        });
    }

    document.getElementById('btn-registrar-venta').addEventListener('click', async function() {
        const idUsuario = document.getElementById('usuario').value;
        if (!idUsuario) {
            alert('Por favor, seleccione un cliente.');
            return;
        }
        if (productosAgregados.length === 0) {
            alert('Por favor, agregue al menos un producto a la venta.');
            return;
        }

        const ventaData = {
            usuario: { idUsuario: parseInt(idUsuario) },
            detalles: productosAgregados.map(item => ({
                producto: { idProducto: parseInt(item.producto.idProducto) },
                cantidad: item.cantidad,
                precioUnitario: item.precioUnitario
            }))
        };

        try {
            const response = await fetch('${pageContext.request.contextPath}/ventas/guardar', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(ventaData)
            });

            if (response.ok) {
                const nuevaVenta = await response.json();
                alert('Venta registrada con éxito con ID: ' + nuevaVenta.id);
                window.location.href = '${pageContext.request.contextPath}/ventas/ver/' + nuevaVenta.id;
            } else {
                const errorMsg = await response.text();
                alert('Error al registrar la venta: ' + errorMsg);
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Ocurrió un error de conexión.');
        }
    });
});
</script>

</body>
</html>