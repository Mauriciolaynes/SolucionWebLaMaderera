<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Gestión de Compras</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<div class="main-content-list">

    <h2>Módulo de Compras</h2>

    <!-- ACCIONES SUPERIORES -->
    <div class="acciones-superiores">

        <a href="${pageContext.request.contextPath}/pedidos-compra/nuevo" class="btn-agregar">
            <i class="fas fa-file-alt"></i> Nuevo Pedido de Compra
        </a>

        <a href="${pageContext.request.contextPath}/cotizaciones/nueva" class="btn-agregar" style="background-color:#2980b9;">
            <i class="fas fa-calculator"></i> Registrar Cotización
        </a>

        <a href="${pageContext.request.contextPath}/ordenes-compra/nuevo" class="btn-agregar" style="background-color:#8e44ad;">
            <i class="fas fa-clipboard-check"></i> Generar Orden de Compra
        </a>

        <a href="${pageContext.request.contextPath}/facturas-compra/nuevo" class="btn-agregar" style="background-color:#27ae60;">
            <i class="fas fa-file-invoice-dollar"></i> Registrar Factura
        </a>

        <a href="${pageContext.request.contextPath}/admin/admin-dashboard"
           class="btn-agregar"
           style="background-color: #7f8c8d;">
           <i class="fas fa-arrow-left"></i> Volver
        </a>
    </div>


    <!-- ===================== LISTADO DE PEDIDOS ===================== -->
    <h3>Pedidos de Compra</h3>
    <table border="1">
        <thead>
        <tr>
            <th>ID</th>
            <th>N° Pedido</th>
            <th>Proveedor</th>
            <th>Fecha</th>
            <th>Estado</th>
            <th>Total</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>

        <c:forEach var="ped" items="${pedidos}">
            <tr>
                <td>${ped.idPedidoCompra}</td>
                <td>${ped.numeroPedido}</td>
                <td>${ped.proveedor.nombre}</td>
                <td>${ped.fechaPedido}</td>
                <td>${ped.estado}</td>
                <td>S/ ${ped.total}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/pedidos-compra/ver/${ped.idPedidoCompra}" class="btn-editar">Ver</a>
                    <a href="${pageContext.request.contextPath}/pedidos-compra/editar/${ped.idPedidoCompra}" class="btn-editar">Editar</a>
                    <a href="${pageContext.request.contextPath}/pedidos-compra/eliminar/${ped.idPedidoCompra}" class="btn-editar" style="background-color:#c0392b;">Eliminar</a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty pedidos}">
            <tr>
                <td colspan="7" style="text-align:center;color:#7f8c8d;padding:30px;">
                    No se encontraron pedidos registrados.
                </td>
            </tr>
        </c:if>

        </tbody>
    </table>


    <!-- ===================== LISTADO DE COTIZACIONES ===================== -->
    <h3>Cotizaciones de Proveedores</h3>
    <table border="1">
        <thead>
        <tr>
            <th>ID</th>
            <th>Proveedor</th>
            <th>Fecha</th>
            <th>Pedido Asociado</th>
            <th>Estado</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>

        <c:forEach var="cot" items="${cotizaciones}">
            <tr>
                <td>${cot.idCotizacion}</td>
                <td>${cot.proveedor.nombre}</td>
                <td>${cot.fecha}</td>
                <td>${cot.pedido.idPedidoCompra}</td>
                <td>${cot.estado}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/cotizaciones/ver/${cot.idCotizacion}" class="btn-editar">Ver</a>
                    <a href="${pageContext.request.contextPath}/cotizaciones/editar/${cot.idCotizacion}" class="btn-editar">Editar</a>
                    <a href="${pageContext.request.contextPath}/cotizaciones/eliminar/${cot.idCotizacion}" class="btn-editar" style="background-color:#c0392b;">Eliminar</a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty cotizaciones}">
            <tr>
                <td colspan="6" style="text-align:center;color:#7f8c8d;padding:30px;">
                    No se encontraron cotizaciones registradas.
                </td>
            </tr>
        </c:if>

        </tbody>
    </table>


    <!-- ===================== LISTADO DE ÓRDENES DE COMPRA ===================== -->
    <h3>Órdenes de Compra</h3>
    <table border="1">
        <thead>
        <tr>
            <th>ID</th>
            <th>Proveedor</th>
            <th>Fecha</th>
            <th>Número</th>
            <th>Estado</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>

        <c:forEach var="oc" items="${ordenes}">
            <tr>
                <td>${oc.idOrdenCompra}</td>
                <td>${oc.proveedor.nombre}</td>
                <td>${oc.fecha}</td>
                <td>${oc.numeroOrden}</td>
                <td>${oc.estado}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/ordenes-compra/ver/${oc.idOrdenCompra}" class="btn-editar">Ver</a>
                    <a href="${pageContext.request.contextPath}/ordenes-compra/editar/${oc.idOrdenCompra}" class="btn-editar">Editar</a>
                    <a href="${page-context.request.contextPath}/ordenes-compra/eliminar/${oc.idOrdenCompra}" class="btn-editar" style="background-color:#c0392b;">Eliminar</a>
                    <a href="${pageContext.request.contextPath}/ordenes-compra/pdf/${oc.idOrdenCompra}" class="btn-editar" style="background-color: #f39c12;">PDF</a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty ordenes}">
            <tr>
                <td colspan="6" style="text-align:center;color:#7f8c8d;padding:30px;">
                    No se encontraron órdenes registradas.
                </td>
            </tr>
        </c:if>

        </tbody>
    </table>


    <!-- ===================== LISTADO DE FACTURAS ===================== -->
    <h3>Facturas de Compra</h3>
    <table border="1">
        <thead>
        <tr>
            <th>ID</th>
            <th>Número</th>
            <th>Proveedor</th>
            <th>Fecha</th>
            <th>Monto</th>
            <th>Estado Pago</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>

        <c:forEach var="fac" items="${facturas}">
            <tr>
                <td>${fac.idFacturaCompra}</td>
                <td>${fac.numeroFactura}</td>
                <td>${fac.proveedor.nombre}</td>
                <td>${fac.fecha}</td>
                <td>S/ ${fac.monto}</td>
                <td>${fac.estadoPago}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/facturas-compra/ver/${fac.idFacturaCompra}" class="btn-editar">Ver</a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty facturas}">
            <tr>
                <td colspan="7" style="text-align:center;color:#7f8c8d;padding:30px;">
                    No se encontraron facturas registradas.
                </td>
            </tr>
        </c:if>

        </tbody>
    </table>

</div>

</body>
</html>
