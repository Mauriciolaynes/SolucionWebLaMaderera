<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Orden de Compra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    
    <h2 class="mb-4 text-primary">
        <i class="fas fa-shopping-cart me-2"></i>Gestión de Órdenes de Compra
    </h2>

    <form action="<c:url value='/ordenes-compra/guardar'/>" method="post">

        <input type="hidden" name="idOrden" value="${orden.idOrden}"/>

        <div class="card shadow-sm">
            <div class="card-header py-3">
                <h5 class="m-0">
                    ${orden.idOrden == null ? 'Registrar Nueva Orden' : 'Editar Orden existente'}
                </h5>
            </div>

            <div class="card-body">

                <div class="mb-3">
                    <label class="form-label fw-bold">Proveedor:</label>
                    <select name="idProveedor" class="form-select" required>
                        <option value="">Seleccione un proveedor...</option>
                        <c:forEach var="p" items="${proveedores}">
                            <option value="${p.idProveedor}"
                                ${orden.proveedor != null && orden.proveedor.idProveedor == p.idProveedor ? 'selected' : ''}>
                                ${p.nombre}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="row">
                    
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Número de Orden:</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-hashtag"></i></span>
                            <input type="text" name="numeroOrden" class="form-control bg-light" 
                                   value="${orden.numeroOrden}" 
                                   placeholder="Autogenerado" 
                                   readonly required/> 
                        </div>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Fecha de Emisión:</label>
                        <input type="date" name="fecha" class="form-control" 
                               value="${orden.fecha}" required/>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Estado:</label>
                        <select name="estado" class="form-select" required>
                            <option value="GENERADA" ${orden.estado == 'GENERADA' ? 'selected' : ''}>Generada</option>
                            <option value="ENVIADA" ${orden.estado == 'ENVIADA' ? 'selected' : ''}>Enviada</option>
                            <option value="RECIBIDA" ${orden.estado == 'RECIBIDA' ? 'selected' : ''}>Recibida</option>
                            <option value="ANULADA" ${orden.estado == 'ANULADA' ? 'selected' : ''}>Anulada</option>
                        </select>
                    </div>
                </div>

            </div> 
            
            <div class="card-footer text-end py-3">
                <a href="${pageContext.request.contextPath}/ordenes-compra/listado" class="btn btn-secondary me-2">
                    <i class="fas fa-times me-1"></i> Cancelar
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-1"></i> Guardar Orden
                </button>
            </div>

        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>