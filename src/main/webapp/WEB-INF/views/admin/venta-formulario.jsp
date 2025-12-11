<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Registrar Venta</title>
            <link rel="stylesheet" href="<c:url value='/Styles/dashboard.css'/>">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet"
                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
            <style>
                .form-group {
                    margin-bottom: 1rem;
                }

                .form-control {
                    width: 100%;
                    padding: 8px;
                    border-radius: 4px;
                    border: 1px solid #ccc;
                }

                .total-section {
                    text-align: right;
                    font-size: 1.5em;
                    font-weight: bold;
                    margin-top: 20px;
                }

                #productos-agregados td {
                    vertical-align: middle;
                }
            </style>
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
                        <li><a href="${pageContext.request.contextPath}/productos/listar"><i class="fas fa-boxes"></i>
                                Productos</a></li>
                        <li><a href="${pageContext.request.contextPath}/proveedores/listar"><i class="fas fa-truck"></i>
                                Proveedores</a></li>
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
                    <h1>Registrar Nueva Venta</h1>
                    <a href="${pageContext.request.contextPath}/ventas/listar" class="btn"><i
                            class="fas fa-arrow-left"></i> Volver al Listado</a>
                </header>

                <section>
                    <div class="form-group">
                        <label for="usuario">Cliente:</label>
                        <select id="usuario" class="form-control">
                            <option value="">-- Seleccione un cliente --</option>
                            <c:forEach var="user" items="${usuarios}">
                                <option value="${user.idUsuario}">${user.nombresApellidos} - ${user.numeroDocumento}
                                </option>
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
                                    <option value="${prod.idProducto}" data-precio="${prod.precioVenta}">${prod.nombre}
                                        (S/ ${prod.precioVenta})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="cantidad">Cantidad:</label>
                            <input type="number" id="cantidad" class="form-control" value="1" min="1">
                        </div>
                        <button id="btn-agregar-producto" class="btn btn-secondary"
                            style="height: 38px;">Agregar</button>
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
                        <button id="btn-registrar-venta" class="btn btn-primary"
                            style="font-size: 1.2em; padding: 10px 20px;">Registrar Venta</button>
                    </div>
                </section>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const productosAgregados = [];

                    // ========================================
                    // FUNCIÓN PARA MOSTRAR TOAST MODERNO
                    // ========================================
                    function showToast(title, message, type = 'success', duration = 4000) {
                        // Crear elemento toast
                        const toast = document.createElement('div');
                        toast.className = `toast-notification ${type}`;

                        // Icono según el tipo
                        const icon = type === 'success' ? '✓' : '✕';

                        toast.innerHTML = `
                            <div class="toast-icon">${icon}</div>
                            <div class="toast-content">
                                <div class="toast-title">${title}</div>
                                <div class="toast-message">${message}</div>
                            </div>
                            <button class="toast-close" onclick="this.parentElement.remove()">×</button>
                        `;

                        document.body.appendChild(toast);

                        // Mostrar con animación
                        setTimeout(() => toast.classList.add('show'), 10);

                        // Auto-cerrar
                        setTimeout(() => {
                            toast.classList.remove('show');
                            setTimeout(() => toast.remove(), 400);
                        }, duration);
                    }

                    document.getElementById('btn-agregar-producto').addEventListener('click', function () {
                        const selector = document.getElementById('producto-selector');
                        const productoId = selector.value;

                        console.log('=== AGREGAR PRODUCTO ===');
                        console.log('Producto ID:', productoId);

                        if (!productoId) {
                            alert('Por favor seleccione un producto');
                            return;
                        }

                        const selectedOption = selector.options[selector.selectedIndex];
                        const textoCompleto = selectedOption.text;
                        console.log('Texto completo opción:', textoCompleto);

                        // Extraer nombre del producto (antes del paréntesis)
                        const productoNombre = textoCompleto.split(' (S/')[0].trim();
                        console.log('Nombre extraído:', productoNombre);

                        const precioUnitario = parseFloat(selectedOption.getAttribute('data-precio'));
                        console.log('Precio:', precioUnitario);

                        const cantidad = parseInt(document.getElementById('cantidad').value);
                        console.log('Cantidad:', cantidad);

                        // Validaciones
                        if (!productoNombre || productoNombre === '') {
                            alert('Error: No se pudo obtener el nombre del producto');
                            return;
                        }
                        if (isNaN(precioUnitario) || precioUnitario <= 0) {
                            alert('Error: Precio inválido');
                            return;
                        }
                        if (isNaN(cantidad) || cantidad <= 0) {
                            alert('Error: Cantidad inválida');
                            return;
                        }

                        const productoExistente = productosAgregados.find(p => p.producto.idProducto == productoId);
                        if (productoExistente) {
                            productoExistente.cantidad += cantidad;
                            console.log('Producto ya existía, nueva cantidad:', productoExistente.cantidad);
                        } else {
                            const nuevoProducto = {
                                producto: {
                                    idProducto: productoId,
                                    nombre: productoNombre
                                },
                                cantidad: cantidad,
                                precioUnitario: precioUnitario
                            };
                            productosAgregados.push(nuevoProducto);
                            console.log('Producto agregado:', nuevoProducto);
                        }

                        console.log('Total productos en array:', productosAgregados.length);
                        console.log('Array completo:', productosAgregados);

                        actualizarTablaYTotal();

                        // Resetear selector
                        selector.selectedIndex = 0;
                        document.getElementById('cantidad').value = 1;
                    });

                    function actualizarTablaYTotal() {
                        const tbody = document.getElementById('productos-agregados');
                        tbody.innerHTML = ''; // Limpiar tabla
                        let totalGeneral = 0;

                        productosAgregados.forEach((item, index) => {
                            const subtotal = item.cantidad * item.precioUnitario;
                            totalGeneral += subtotal;

                            // Crear fila usando DOM (más seguro que innerHTML)
                            const row = document.createElement('tr');

                            // Columna Producto
                            const tdProducto = document.createElement('td');
                            tdProducto.textContent = item.producto.nombre;
                            row.appendChild(tdProducto);

                            // Columna Cantidad
                            const tdCantidad = document.createElement('td');
                            tdCantidad.textContent = item.cantidad;
                            row.appendChild(tdCantidad);

                            // Columna Precio
                            const tdPrecio = document.createElement('td');
                            tdPrecio.textContent = 'S/ ' + item.precioUnitario.toFixed(2);
                            row.appendChild(tdPrecio);

                            // Columna Subtotal
                            const tdSubtotal = document.createElement('td');
                            tdSubtotal.textContent = 'S/ ' + subtotal.toFixed(2);
                            row.appendChild(tdSubtotal);

                            // Columna Acción (botón eliminar)
                            const tdAccion = document.createElement('td');
                            const btnEliminar = document.createElement('button');
                            btnEliminar.className = 'btn-action delete';
                            btnEliminar.setAttribute('data-index', index);
                            btnEliminar.innerHTML = '<i class="fas fa-trash"></i>';
                            btnEliminar.addEventListener('click', function () {
                                productosAgregados.splice(index, 1);
                                actualizarTablaYTotal();
                            });
                            tdAccion.appendChild(btnEliminar);
                            row.appendChild(tdAccion);

                            tbody.appendChild(row);
                        });

                        document.getElementById('total-venta').textContent = totalGeneral.toFixed(2);
                    }

                    document.getElementById('btn-registrar-venta').addEventListener('click', async function () {
                        const idUsuario = document.getElementById('usuario').value;
                        if (!idUsuario) {
                            showToast('⚠️ Atención', 'Por favor, seleccione un cliente.', 'error');
                            return;
                        }
                        if (productosAgregados.length === 0) {
                            showToast('⚠️ Atención', 'Por favor, agregue al menos un producto a la venta.', 'error');
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

                        console.log('=== ENVIANDO VENTA ===');
                        console.log('Datos a enviar:', ventaData);

                        const jsonString = JSON.stringify(ventaData);
                        console.log('JSON String:', jsonString);
                        console.log('JSON String length:', jsonString.length);

                        try {
                            const response = await fetch('${pageContext.request.contextPath}/ventas/guardar', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json',
                                },
                                body: jsonString
                            });

                            console.log('Response status:', response.status);
                            console.log('Response ok:', response.ok);

                            const contentType = response.headers.get('content-type');
                            console.log('Content-Type:', contentType);

                            if (response.ok) {
                                // Verificar si la respuesta es JSON o texto
                                if (contentType && contentType.includes('application/json')) {
                                    const nuevaVenta = await response.json();

                                    // GUARDAR MENSAJE EN SESSION STORAGE PARA MOSTRARLO EN LA SIGUIENTE PÁGINA
                                    sessionStorage.setItem('toastMessage', JSON.stringify({
                                        title: '✅ ¡Venta Registrada!',
                                        message: `Venta #${nuevaVenta.id} registrada exitosamente. Total: S/ ${nuevaVenta.total.toFixed(2)}`,
                                        type: 'success'
                                    }));

                                    // Redirigir inmediatamente
                                    window.location.href = '${pageContext.request.contextPath}/ventas/ver/' + nuevaVenta.id;
                                } else {
                                    const textoRespuesta = await response.text();
                                    console.log('Respuesta (texto):', textoRespuesta);

                                    sessionStorage.setItem('toastMessage', JSON.stringify({
                                        title: '✅ Venta Registrada',
                                        message: 'Venta registrada correctamente',
                                        type: 'success'
                                    }));

                                    window.location.href = '${pageContext.request.contextPath}/ventas/listar';
                                }
                            } else {
                                const errorMsg = await response.text();
                                console.error('Error del servidor:', errorMsg);
                                showToast('❌ Error', errorMsg, 'error', 5000);
                            }
                        } catch (error) {
                            console.error('Error completo:', error);
                            console.error('Error.name:', error.name);
                            console.error('Error.message:', error.message);
                            showToast('❌ Error de Conexión', error.message, 'error', 5000);
                        }
                    });
                });
            </script>

        </body>

        </html>