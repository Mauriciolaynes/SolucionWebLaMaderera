<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Venta</title>
    <link rel="stylesheet" href="<c:url value='/Styles/ventas.css'/>"/>
    <script>
        // Función para calcular el total de la venta
        function calcularTotal() {
            let total = 0;
            const cantidadInputs = document.querySelectorAll('.cantidad-producto');
            cantidadInputs.forEach(function(input) {
                const precio = parseFloat(input.dataset.precio);
                const cantidad = parseInt(input.value) || 0;
                total += precio * cantidad;
            });
            document.getElementById('totalVenta').innerText = total.toFixed(2);
            document.getElementById('montoTotal').value = total.toFixed(2);
        }

        // Validar stock
        function validarStock(input) {
            const stock = parseInt(input.dataset.stock);
            const cantidad = parseInt(input.value) || 0;
            if (cantidad > stock) {
                alert("No hay suficiente stock para este producto");
                input.value = stock;
                calcularTotal();
            } else {
                calcularTotal();
            }
        }
    </script>
</head>
<body>
    <h1>Registrar Venta</h1>
    
    <form action="<c:url value=''/>" method="post">
        <label for="cliente">Cliente:</label>
        <select name="idCliente" id="cliente" required>
            <option value="">--Seleccione un cliente--</option>
            <c:forEach var="cliente" items="${clientes}">
                <option value="${cliente.id}">${cliente.nombre}</option>
            </c:forEach>
        </select>
        <br><br>

        <label>Productos:</label>
        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Precio</th>
                    <th>Stock disponible</th>
                    <th>Cantidad</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="producto" items="${productos}">
                    <tr>
                        <td>${producto.nombre}</td>
                        <td>${producto.precio}</td>
                        <td>${producto.stock}</td>
                        <td>
                            <input type="number" name="cantidades[${producto.id}]" class="cantidad-producto"
                                   data-precio="${producto.precio}" data-stock="${producto.stock}" 
                                   min="0" max="${producto.stock}" value="0"
                                   onchange="validarStock(this)"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <br>

        <label>Total de la venta: S/ <span id="totalVenta">0.00</span></label>
        <input type="hidden" name="montoTotal" id="montoTotal" value="0.00">
        <br><br>

        <button type="submit">Registrar Venta</button>
    </form>
</body>
</html>
