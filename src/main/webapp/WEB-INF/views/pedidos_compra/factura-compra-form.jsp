<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Factura de Compra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        .container { max-width: 800px; }
        .card-header { background-color: #f8f9fa; font-weight: 600; }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5">
    
    <h2 class="mb-4 text-primary">
        <i class="fas fa-file-invoice-dollar me-2"></i>Gestión de Facturas
    </h2>

    <form action="<c:url value='/facturas-compra/guardar'/>" method="post">
        
        <input type="hidden" name="idFactura" value="${factura.idFactura}"/>

        <div class="card shadow-sm">
            <div class="card-header py-3">
                <h5 class="m-0">
                    ${factura.idFactura == null ? 'Registrar Nueva Factura' : 'Editar Factura existente'}
                </h5>
            </div>
            
            <div class="card-body">
                
                <div class="mb-3">
                    <label class="form-label fw-bold">Proveedor:</label>
                    <select name="idProveedor" class="form-select" required>
                        <option value="">Seleccione un proveedor...</option>
                        <c:forEach var="p" items="${proveedores}">
                            <option value="${p.idProveedor}"
                                    ${factura.proveedor != null && factura.proveedor.idProveedor == p.idProveedor ? 'selected' : ''}>
                                ${p.nombre}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">N° de Factura:</label>
                        <input type="text" name="numeroFactura" class="form-control bg-light" 
                               value="${factura.numeroFactura}" 
                               placeholder="Autogenerado" required readonly/>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Fecha de Emisión:</label>
                        <input type="date" name="fecha" class="form-control" 
                               value="${factura.fecha}" required/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Monto Total:</label>
                        <div class="input-group">
                            <span class="input-group-text">S/</span>
                            <input type="number" step="0.01" min="0" name="monto" class="form-control" 
                                   value="${factura.monto}" placeholder="0.00" required/>
                        </div>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Estado de Pago:</label>
                        <select name="estadoPago" class="form-select" required>
                            <option value="PENDIENTE" ${factura.estadoPago == 'PENDIENTE' ? 'selected' : ''}>Pendiente</option>
                            <option value="PAGADO" ${factura.estadoPago == 'PAGADO' ? 'selected' : ''}>Pagado</option>
                            <option value="VENCIDO" ${factura.estadoPago == 'VENCIDO' ? 'selected' : ''}>Vencido</option>
                        </select>
                    </div>
                </div>

            </div> 
            
            <div class="card-footer text-end py-3">
                <a href="${pageContext.request.contextPath}/compras" class="btn btn-secondary me-2">
                    <i class="fas fa-times me-1"></i> Cancelar
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-1"></i> Guardar Factura
                </button>
            </div>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>