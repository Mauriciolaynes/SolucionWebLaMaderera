<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Boleta de Venta - Maderera Multiservicios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body { background: #555; display: flex; justify-content: center; padding-top: 30px; }
        .ticket-container {
            background: white;
            width: 400px;
            padding: 20px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
            border-top: 5px solid #0d6efd; /* Color azul de tu marca */
        }
        .dashed-line { border-top: 2px dashed #ccc; margin: 15px 0; }
        .logo-ticket { max-width: 150px; margin-bottom: 10px; }
        
        /* Ocultar botones al imprimir */
        @media print {
            body { background: white; padding: 0; display: block; }
            .ticket-container { width: 100%; box-shadow: none; border: none; }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body>

    <div class="ticket-container">
        
        <div class="text-center">
            <img src="<c:url value='/imagenes/Logo/Logo.png'/>" alt="Logo" class="logo-ticket">
            <h5 class="fw-bold text-uppercase mt-2">Maderera Multiservicios</h5>
            <p class="small mb-1">RUC: 20123456789</p>
            <p class="small mb-1">Av. La Molina 123, Lima - Perú</p>
            <p class="small">Telf: (01) 500-5540</p>
        </div>

        <div class="dashed-line"></div>

        <div class="row small">
            <div class="col-6"><strong>Nro Pedido:</strong> <br> ${nroPedido}</div>
            <div class="col-6 text-end"><strong>Fecha:</strong> <br> ${fecha} ${hora}</div>
        </div>

        <div class="dashed-line"></div>

        <table class="table table-borderless table-sm small">
            <thead>
                <tr class="border-bottom">
                    <th>Cant.</th>
                    <th>Producto</th>
                    <th class="text-end">Importe</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${items}">
                    <tr>
                        <td>${item.cantidad}</td>
                        <td>${item.producto.nombre}</td>
                        <td class="text-end">S/. ${item.subtotal}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="dashed-line"></div>

        <div class="d-flex justify-content-between fw-bold fs-5">
            <span>TOTAL A PAGAR:</span>
            <span>S/. ${total}</span>
        </div>
        <div class="text-center small text-muted mt-2">
            (Incluye IGV)
        </div>

        <div class="dashed-line"></div>

        <div class="text-center mt-4 mb-3">
            <p class="small fw-bold">¡Gracias por su compra!</p>
            <img src="<c:url value='/imagenes/Iconos/libro-de-reclamaciones.png'/>" width="80" style="opacity: 0.5;">
            <p class="small text-muted mt-2">Conserve este ticket como comprobante.</p>
        </div>

        <div class="d-grid gap-2 mt-4 no-print">
            <button onclick="window.print()" class="btn btn-dark">
                <i class="bi bi-printer"></i> Imprimir Ticket
            </button>
            <a href="<c:url value='/'/>" class="btn btn-outline-primary">
                Volver al Inicio
            </a>
        </div>

    </div>

</body>
</html>