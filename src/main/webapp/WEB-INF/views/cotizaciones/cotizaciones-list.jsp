<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Listado de Cotizaciones</title>
    <link rel="stylesheet" href="<c:url value='/Styles/forms.css'/>">
</head>
<body>

<div class="container">
    <h2>Listado de Cotizaciones</h2>

    <div style="margin-bottom:16px;">
        <a href="<c:url value='/cotizaciones/nueva'/>" class="btn btn-primary">➕ Nueva Cotización</a>
        <a href="<c:url value='/compras'/>" class="btn btn-secondary">Volver al módulo Compras</a>
    </div>

    <table class="tabla" border="1" width="100%" cellpadding="6">
        <thead>
            <tr>
                <th>ID</th>
                <th>Número</th>
                <th>Proveedor</th>
                <th>Fecha</th>
                <th>Estado</th>
                <th>Archivo</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty cotizaciones}">
                    <c:forEach var="c" items="${cotizaciones}">
                        <tr>
                            <td>${c.idCotizacion}</td>
                            <td>${c.numeroCotizacion}</td>
                            <td>${c.proveedor != null ? c.proveedor.nombre : '-'}</td>
                            <td>${c.fecha}</td>
                            <td>${c.estado}</td>
                            <td>
                                <c:if test="${not empty c.archivoAdjunto}">
                                    <a href="<c:url value='/uploads/cotizaciones/${c.archivoAdjunto}'/>" target="_blank">Ver</a>
                                </c:if>
                            </td>
                            <td>
                                <a href="<c:url value='/cotizaciones/ver/${c.idCotizacion}'/>">Ver</a> |
                                <a href="<c:url value='/cotizaciones/editar/${c.idCotizacion}'/>">Editar</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="7" style="text-align:center;color:#7f8c8d;padding:20px;">
                            No se encontraron cotizaciones registradas.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

</body>
</html>
