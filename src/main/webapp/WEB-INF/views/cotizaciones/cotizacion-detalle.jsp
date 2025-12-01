<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalle de Cotización</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
</head>
<body>
<div class="container">
    <h2>Detalle - Cotización #${cotizacion.idCotizacion}</h2>

    <p><strong>Número:</strong> ${cotizacion.numeroCotizacion}</p>
    <p><strong>Proveedor:</strong> ${cotizacion.proveedor != null ? cotizacion.proveedor.nombre : ''} (${cotizacion.proveedor != null ? cotizacion.proveedor.ruc : ''})</p>
    <p><strong>Fecha:</strong> ${cotizacion.fecha}</p>
    <p><strong>Estado:</strong> ${cotizacion.estado}</p>

    <c:if test="${not empty cotizacion.archivoAdjunto}">
        <p><strong>Archivo:</strong> <a href="<c:url value='/uploads/cotizaciones/${cotizacion.archivoAdjunto}'/>" target="_blank">Ver</a></p>
    </c:if>

    <hr/>

    <h4>Productos cotizados</h4>
    <table class="tabla" border="1" width="100%" cellpadding="6">
        <thead>
            <tr>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Precio (S/)</th>
                <th>Subtotal</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="d" items="${cotizacion.detalles}">
                <tr>
                    <td>${d.producto != null ? d.producto.nombre : 'Producto #' + d.producto}</td>
                    <td>${d.cantidad}</td>
                    <td>${d.precio}</td>
                    <td>S/ ${d.cantidad * d.precio}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div style="margin-top:12px;">
        <a href="<c:url value='/cotizaciones'/>" class="btn btn-secondary">Volver</a>
        <a href="<c:url value='/cotizaciones/editar/${cotizacion.idCotizacion}'/>" class="btn btn-primary">Editar</a>
    </div>
</div>
</body>
</html>
