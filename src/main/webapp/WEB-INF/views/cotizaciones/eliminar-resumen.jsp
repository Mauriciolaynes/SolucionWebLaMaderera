<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirmar Eliminación de Cotización</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="bg-light">

    <%-- <jsp:include page="../common/navbar.jsp" /> --%>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card border-danger shadow">
                    <div class="card-header bg-danger text-white">
                        <h3 class="mb-0">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Confirmar Eliminación
                        </h3>
                    </div>
                    <div class="card-body">
                        <p class="fs-5 text-center">¿Está seguro de que desea eliminar permanentemente esta cotización?</p>
                        
                        <div class="alert alert-warning text-center">
                            <strong>Esta acción no se puede deshacer.</strong>
                        </div>

                        <ul class="list-group mb-4">
                            <li class="list-group-item">
                                <strong>ID Cotización:</strong> ${cotizacion.idCotizacion}
                            </li>
                            
                            <li class="list-group-item">
                                <strong>Proveedor:</strong> ${cotizacion.proveedor.nombre}
                            </li>
                            
                            <li class="list-group-item">
                                <strong>Fecha:</strong> ${cotizacion.fecha}
                            </li>
                            
                            <li class="list-group-item">
                                <strong>Pedido Asociado:</strong> 
                                <c:choose>
                                    <c:when test="${cotizacion.pedido != null}">
                                        #${cotizacion.pedido.numeroPedido}
                                    </c:when>
                                    <c:otherwise>Sin pedido</c:otherwise>
                                </c:choose>
                            </li>
                        </ul>

                        <form action="${pageContext.request.contextPath}/cotizaciones/eliminar-confirmado" method="post" class="d-flex justify-content-center gap-3 mt-4">
                            <input type="hidden" name="idCotizacion" value="${cotizacion.idCotizacion}" />
                            
                            <a href="${pageContext.request.contextPath}/compras" class="btn btn-secondary btn-lg">
                                <i class="fas fa-times me-2"></i> Cancelar
                            </a>
                            
                            <button type="submit" class="btn btn-danger btn-lg">
                                <i class="fas fa-trash-alt me-2"></i> Sí, Eliminar
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>