<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Tu Carrito - Maderera Multiservicios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body { background-color: #f8f9fa; }
        .img-carrito { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; border: 1px solid #dee2e6; }
        .carrito-container { margin-top: 40px; margin-bottom: 50px; }
        .btn-qty { width: 30px; padding: 0; display: flex; align-items: center; justify-content: center; height: 30px; }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand fs-6" href="<c:url value='/'/>">
                <i class="bi bi-arrow-left"></i> Seguir Comprando
            </a>
            <span class="navbar-text text-white">Carrito de Compras</span>
        </div>
    </nav>

    <main class="container carrito-container">
        
        <div class="row">
            <div class="col-lg-8">
                <h4 class="mb-3">Artículos seleccionados</h4>
                
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        
                        <c:if test="${empty carrito}">
                            <div class="text-center py-5">
                                <i class="bi bi-cart-x display-1 text-muted opacity-25"></i>
                                <p class="mt-3 lead text-muted">Tu carrito está vacío.</p>
                                <a href="<c:url value='/'/>" class="btn btn-primary mt-2">Ir al catálogo</a>
                            </div>
                        </c:if>

                        <c:forEach var="item" items="${carrito}">
                            <div class="row mb-4 border-bottom pb-4 align-items-center">
                                
                                <div class="col-3 col-md-2">
                                    <img src="<c:url value='/${item.producto.imagen}'/>" class="img-carrito" alt="${item.producto.nombre}">
                                </div>
                                
                                <div class="col-9 col-md-5">
                                    <h6 class="fw-bold mb-1 text-dark">${item.producto.nombre}</h6>
                                    <small class="text-muted d-block text-truncate">${item.producto.descripcion}</small>
                                    <span class="badge bg-light text-dark border mt-2">S/. ${item.producto.precioVenta} c/u</span>
                                </div>

                                <div class="col-6 col-md-3 mt-3 mt-md-0 d-flex justify-content-md-center">
                                    <div class="input-group input-group-sm" style="width: 110px;">
                                        <a href="<c:url value='/carrito/restar/${item.producto.idProducto}'/>" 
                                           class="btn btn-outline-secondary btn-qty fw-bold"> - </a>
                                        
                                        <input type="text" class="form-control text-center bg-white" 
                                               value="${item.cantidad}" readonly style="font-weight: 600;">
                                        
                                        <a href="<c:url value='/carrito/sumar/${item.producto.idProducto}'/>" 
                                           class="btn btn-outline-secondary btn-qty fw-bold"> + </a>
                                    </div>
                                </div>

                                <div class="col-6 col-md-2 text-end mt-3 mt-md-0">
                                    <div class="fw-bold fs-6">S/. ${item.subtotal}</div>
                                    <a href="<c:url value='/carrito/eliminar/${item.producto.idProducto}'/>" 
                                       class="text-danger small text-decoration-none mt-1 d-inline-block">
                                        <i class="bi bi-trash"></i> Quitar
                                    </a>
                                </div>
                            </div>
                        </c:forEach>

                    </div>
                </div>
            </div>

            <div class="col-lg-4 mt-4 mt-lg-0">
                <h4 class="mb-3">Resumen</h4>
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between mb-2 text-muted">
                            <span>Subtotal</span>
                            <span>S/. ${total}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3 text-success small">
                            <span>Descuentos</span>
                            <span>- S/. 0.00</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4 align-items-center">
                            <span class="fw-bold fs-5">Total a Pagar</span>
                            <span class="fw-bold fs-4 text-primary">S/. ${total}</span>
                        </div>

                        <a href="<c:url value='/carrito/procesar'/>" class="btn btn-dark w-100 py-3 fw-bold rounded-3 shadow-sm">
						    <i class="bi bi-credit-card-2-front me-2"></i> PROCESAR PAGO
						</a>
                        
                        <div class="text-center mt-3">
                            <small class="text-muted"><i class="bi bi-shield-lock"></i> Pago 100% Seguro</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>