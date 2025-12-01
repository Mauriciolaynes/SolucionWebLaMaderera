<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirmar Eliminación de Cotización</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body>
    <div class="container mt-5">
        <div class="card border-danger shadow-sm">
            <div class="card-header bg-danger text-white">
                <h3 class="mb-0"><i class="bi bi-exclamation-triangle-fill"></i> Confirmación de Eliminación</h3>
            </div>
            <div class="card-body">
                <h5 class="card-title">¿Está seguro de que desea eliminar permanentemente la siguiente Cotización?</h5>
                <p class="text-muted">Esta acción no se puede deshacer.</p>

                <div class="alert alert-secondary">
                    <h6 class="alert-heading">Resumen de la Cotización:</h6>
                    <hr>
                    <dl class="row">
                        <dt class="col-sm-3">ID Cotización:</dt>
                        <dd class="col-sm-9"><strong>#${cotizacion.idCotizacion}</strong></dd>

                        <dt class="col-sm-3">Proveedor:</dt>
                        <dd class="col-sm-9">${cotizacion.proveedor.nombre}</dd>

                        <dt class="col-sm-3">Fecha:</dt>
                        <dd class="col-sm-9">
                            <fmt:formatDate value="${cotizacion.fecha}" pattern="dd/MM/yyyy" />
                        </dd>

                        <dt class="col-sm-3">Estado:</dt>
                        <dd class="col-sm-9"><span class="badge bg-info text-dark">${cotizacion.estado}</span></dd>

                    </dl>
                </div>

                <%-- Formulario que envía la confirmación al controlador --%>
                <form action="${pageContext.request.contextPath}/cotizaciones/eliminar-confirmado" method="post" class="mt-4">
                    <%-- Campo oculto con el ID de la cotización a eliminar --%>
                    <input type="hidden" name="idCotizacion" value="${cotizacion.idCotizacion}">

                    <button type="submit" class="btn btn-danger"><i class="bi bi-trash-fill"></i> Sí, eliminar cotización</button>
                    <a href="${pageContext.request.contextPath}/compras" class="btn btn-secondary">Cancelar</a>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>