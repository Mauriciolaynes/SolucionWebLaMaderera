<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <title>Editar Pedido de Compra</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<div class="main-content">
    <h2>Editar Pedido de Compra</h2>

    <div class="form-container">
        <%-- Cambiamos la acción para que el controlador sepa que es una EDICIÓN.
             Esto es crucial para que no trate el pedido como nuevo y mantenga el ID. --%>
        <form:form id="formPedido" action="${pageContext.request.contextPath}/pedidos-compra/resumen/editar" method="post" modelAttribute="pedidoEnProceso">
            
            <form:hidden path="idPedidoCompra"/>

            <div class="form-group">
                <label for="proveedor">Proveedor:</label>
                <form:select path="proveedor.idProveedor" id="proveedor" required="true">
                    <form:option value="" label="-- Seleccione un Proveedor --"/>
                    <form:options items="${proveedores}" itemValue="idProveedor" itemLabel="nombre"/>
                </form:select>
            </div>

            <table id="tabla-detalles" border="1">
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Precio Compra</th>
                        <th>Subtotal</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${pedidoEnProceso.detalles}" var="detalle" varStatus="status">
                        <tr>
                            <input type="hidden" name="detalles[${status.index}].idPedidoDetalle" value="${detalle.idPedidoDetalle}" />

                            <td>
                                <select name="detalles[${status.index}].producto.idProducto" class="producto-select" required>
                                    <option value="${detalle.producto.idProducto}" selected>${detalle.producto.nombre}</option>
                                </select>
                            </td>
                            <td><input type="number" name="detalles[${status.index}].cantidad" value="${detalle.cantidad}" class="cantidad" min="1" required></td>
                            <td><input type="number" name="detalles[${status.index}].precioCompra" value="${detalle.precioCompra}" class="precio" step="0.01" min="0" required></td>
                            <td class="subtotal">S/ 0.00</td>
                            <td><button type="button" class="btn-eliminar-fila"><i class="fas fa-trash-alt"></i></button></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <button type="button" id="btn-agregar-fila" class="btn-agregar-fila">
                <i class="fas fa-plus"></i> Agregar Producto
            </button>

            <div class="form-actions">
                <button type="submit" class="btn-guardar">
                    <i class="fas fa-cogs"></i> Procesar y Ver Resumen
                </button>
                <a href="${pageContext.request.contextPath}/compras" class="btn-cancelar">
                    <i class="fas fa-times"></i> Cancelar
                </a>
            </div>
        </form:form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        
        // --- 1. CARGA SEGURA DE DATOS (Try-Catch para evitar que el JS muera) ---
        let productosData = [];
        try {
            // Decodificamos el JSON o usamos array vacío si falla
            const rawJson = '${productosJson}';
            productosData = rawJson ? JSON.parse(rawJson) : [];
        } catch (e) {
            console.error("Error al leer JSON de productos:", e);
            productosData = []; // Fallback seguro
        }

        const idProveedorSeleccionado = document.getElementById('proveedor').value;
        const tablaBody = document.querySelector('#tabla-detalles tbody');
        const formPedido = document.getElementById('formPedido'); // Referencia al form

        // --- FUNCIONES AUXILIARES ---

        function getProductosPorProveedor(idProveedor) {
            if (!idProveedor) return [];
            return productosData.filter(p => p.idProveedor == idProveedor);
        }

        function llenarSelectProducto(selectElement, idProveedor) {
            const productosFiltrados = getProductosPorProveedor(idProveedor);
            const valorSeleccionado = selectElement.getAttribute('data-selected') || selectElement.value;
            
            selectElement.innerHTML = '<option value="">-- Seleccione Producto --</option>';
            
            productosFiltrados.forEach(p => {
                const option = new Option(p.nombre, p.idProducto);
                option.setAttribute('data-precio', p.precioCompra);
                if (p.idProducto == valorSeleccionado) option.selected = true;
                selectElement.add(option);
            });
        }

        function actualizarFila(fila) {
            const cantidad = parseFloat(fila.querySelector('.cantidad').value) || 0;
            const precio = parseFloat(fila.querySelector('.precio').value) || 0;
            const subtotal = cantidad * precio;
            const celdaSubtotal = fila.querySelector('.subtotal');
            if(celdaSubtotal) celdaSubtotal.textContent = 'S/ ' + subtotal.toFixed(2);
        }

        // --- LA FUNCIÓN NUCLEAR DE REINDEXADO ---
        // Busca en TODO el formulario, no solo en la tabla, para eliminar fantasmas
        function reindexarTodo() {
            // Obtenemos solo las filas VISIBLES de la tabla
            const filas = tablaBody.querySelectorAll('tr');
            
            filas.forEach((fila, index) => {
                // Buscamos inputs dentro de esta fila y les asignamos el índice [0], [1], etc.
                fila.querySelectorAll('input, select, textarea').forEach(input => {
                    if (input.name && input.name.includes('detalles')) {
                        // Reemplaza cualquier corchete [x] o [] por el índice correcto [index]
                        input.name = input.name.replace(/\[.*?\]/, `[${index}]`);
                    }
                });
            });

            // LIMPIEZA DE SEGURIDAD:
            // Buscamos cualquier input "suelto" que tenga [] vacíos y lo desactivamos
            // para que no viaje al servidor y cause el error.
            const inputsRotos = formPedido.querySelectorAll('input[name*="[]"], select[name*="[]"]');
            inputsRotos.forEach(input => {
                console.warn("Se encontró un input roto (sin índice), desactivándolo:", input);
                input.disabled = true; // Al desactivarlo, el navegador no lo envía
            });
        }

        // --- INICIALIZACIÓN ---

        // 1. Cargar filas existentes
        tablaBody.querySelectorAll('tr').forEach(fila => {
            const select = fila.querySelector('.producto-select');
            if(select) {
                select.setAttribute('data-selected', select.value);
                llenarSelectProducto(select, idProveedorSeleccionado);
            }
            actualizarFila(fila);
        });

        // 2. Botón Agregar
        const btnAgregar = document.getElementById('btn-agregar-fila');
        if(btnAgregar) {
            btnAgregar.addEventListener('click', function() {
                const idProv = document.getElementById('proveedor').value;
                if (!idProv) {
                    alert('Por favor, seleccione un proveedor primero.');
                    return;
                }

                // Usamos un índice temporal seguro
                const tempIndex = tablaBody.querySelectorAll('tr').length;

                const newRow = `
                    <tr>
                        <td>
                            <select name="detalles[${tempIndex}].producto.idProducto" class="producto-select form-control" required>
                                <option value="">-- Seleccione --</option>
                            </select>
                        </td>
                        <td><input type="number" name="detalles[${tempIndex}].cantidad" value="1" class="cantidad" min="1" required></td>
                        <td><input type="number" name="detalles[${tempIndex}].precioCompra" value="0.00" class="precio" step="0.01" min="0" required></td>
                        <td class="subtotal">S/ 0.00</td>
                        <td><button type="button" class="btn-eliminar-fila"><i class="fas fa-trash-alt"></i></button></td>
                    </tr>`;
                
                tablaBody.insertAdjacentHTML('beforeend', newRow);
                
                const nuevaFila = tablaBody.lastElementChild;
                llenarSelectProducto(nuevaFila.querySelector('.producto-select'), idProv);
            });
        }

        // 3. Eventos delegados (Eliminar y Cálculos)
        tablaBody.addEventListener('click', function(e) {
            if (e.target.closest('.btn-eliminar-fila')) {
                const fila = e.target.closest('tr');
                const idDetalleInput = fila.querySelector('input[name*=".idPedidoDetalle"]');
                
                // Si la fila no tiene un ID de detalle, es una fila nueva que aún no se ha guardado.
                // En ese caso, simplemente la eliminamos de la vista.
                if (!idDetalleInput || !idDetalleInput.value) {
                    fila.remove();
                    return;
                }

                // --- CORRECCIÓN CRÍTICA ---
                // El valor del ID del detalle se obtiene del input oculto que está en la fila.
                // Si no se encuentra, no se puede continuar.
                const idDetalle = idDetalleInput ? idDetalleInput.value : null;
                
                if (!confirm('¿Estás seguro de que quieres eliminar este producto del pedido de forma permanente?')) {
                    return;
                }

                // Hacemos la llamada AJAX al controlador para eliminar el detalle de la BD.
                // --- CORRECCIÓN CRÍTICA ---
                // Usamos comillas invertidas (`) para que la variable ${idDetalle} se interprete correctamente.
                fetch(`${pageContext.request.contextPath}/pedidos-compra/detalle/eliminar/${idDetalle}`, {
                    method: 'DELETE',
                    headers: {
                        // Si usas Spring Security con CSRF, necesitarás añadir el token aquí.
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message); // Mensaje de éxito
                        fila.remove(); // Solo si se borró en el servidor, lo borramos de la vista.
                    } else {
                        alert('Error: ' + data.message); // Mensaje de error
                    }
                })
                .catch(error => console.error('Error en la petición de borrado:', error));
            }
        });

        tablaBody.addEventListener('input', function(e) {
            if (e.target.classList.contains('cantidad') || e.target.classList.contains('precio')) {
                actualizarFila(e.target.closest('tr'));
            }
        });

        tablaBody.addEventListener('change', function(e) {
            if (e.target.classList.contains('producto-select')) {
                const option = e.target.options[e.target.selectedIndex];
                const precio = option.getAttribute('data-precio');
                const fila = e.target.closest('tr');
                if (precio) {
                    fila.querySelector('.precio').value = parseFloat(precio).toFixed(2);
                    actualizarFila(fila);
                }
            }
        });

        // 4. INTERCEPTAR EL ENVÍO (CRÍTICO)
        if (formPedido) {
            formPedido.addEventListener('submit', function(e) {
                // Detenemos el envío un momento
                e.preventDefault(); 
                
                try {
                    // Reordenamos todos los índices (0, 1, 2...)
                    reindexarTodo();
                    
                    // Si todo sale bien, enviamos el formulario manualmente
                    // IMPORTANTE: Usamos formPedido.submit() en lugar de this.submit()
                    // para evitar un bucle infinito, ya que this.submit() vuelve a
                    // disparar este mismo listener de evento.
                    formPedido.submit();
                } catch (err) {
                    console.error("Error al reindexar:", err);
                    alert("Error interno al procesar la tabla. Revise la consola.");
                }
            });
        } else {
            console.error("No se encontró el formulario con id='formPedido'");
        }
    });
</script>

</body>
</html>