<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Finalizar Compra - Maderera Multiservicios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body { background-color: #f4f4f4; }
        .payment-option { cursor: pointer; border: 1px solid #ddd; border-radius: 8px; transition: all 0.3s; }
        .payment-option:hover { border-color: #0d6efd; background-color: #f8fbff; }
        .payment-option.active { border-color: #0d6efd; background-color: #edf5ff; ring: 2px solid #0d6efd; }
        .img-icono { height: 30px; object-fit: contain; }
        .card-resumen { border: none; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

    <nav class="navbar navbar-light bg-white border-bottom mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold text-dark" href="<c:url value='/carrito'/>">
                <i class="bi bi-chevron-left small"></i> Volver al Carrito
            </a>
            <span class="navbar-text fw-bold text-primary">Maderera Multiservicios <i class="bi bi-shield-check"></i></span>
        </div>
    </nav>

    <main class="container mb-5">
        <div class="row g-4">
            
            <div class="col-lg-8">
                <h4 class="mb-4 fw-bold">Elige tu medio de pago</h4>
                
                <form action="<c:url value='/venta/finalizar'/>" method="post" id="formPago">
                    
                    <div class="card p-3 mb-3 payment-option" onclick="seleccionarPago('yape')">
                        <div class="d-flex align-items-center">
                            <input class="form-check-input me-3" type="radio" name="metodoPago" id="radioYape" value="yape" checked>
                            <div class="flex-grow-1">
                                <h6 class="mb-0 fw-bold">Pago con QR (Yape / Plin)</h6>
                                <small class="text-muted">Escanea y paga al instante desde tu celular.</small>
                            </div>
                            <div class="d-flex gap-2">
                                <img src="<c:url value='/imagenes/Iconos/Icono_Yape.png'/>" class="img-icono" alt="Yape">
                                <img src="<c:url value='/imagenes/Iconos/Icono_Plin.png'/>" class="img-icono" alt="Plin">
                            </div>
                        </div>
                        <div id="info-yape" class="mt-3 ps-4 border-top pt-3">
                            <div class="alert alert-info mb-0 small">
                                <i class="bi bi-qr-code"></i> Al finalizar el pedido, se generará un código QR para que puedas escanearlo.
                            </div>
                        </div>
                    </div>

                    <div class="card p-3 mb-3 payment-option" onclick="seleccionarPago('tarjeta')">
                        <div class="d-flex align-items-center">
                            <input class="form-check-input me-3" type="radio" name="metodoPago" id="radioTarjeta" value="tarjeta">
                            <div class="flex-grow-1">
                                <h6 class="mb-0 fw-bold">Tarjeta de Débito o Crédito</h6>
                                <small class="text-muted">Visa, Mastercard, American Express.</small>
                            </div>
                            <div class="d-flex gap-2">
                                <img src="<c:url value='/imagenes/Iconos/Icono_Visa.png'/>" class="img-icono" alt="Visa" onerror="this.style.display='none'">
                                <i class="bi bi-credit-card-2-front fs-4 text-secondary"></i>
                            </div>
                        </div>
                        
                        <div id="info-tarjeta" class="mt-3 ps-4 border-top pt-3 d-none">
                            <div class="row g-2">
                                <div class="col-12">
                                    <label class="form-label small fw-bold">Número de Tarjeta</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="0000 0000 0000 0000">
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-bold">Vencimiento</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="MM/AA">
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-bold">CVV</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="123">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card p-3 mb-3 payment-option" onclick="seleccionarPago('efectivo')">
                        <div class="d-flex align-items-center">
                            <input class="form-check-input me-3" type="radio" name="metodoPago" id="radioEfectivo" value="efectivo">
                            <div class="flex-grow-1">
                                <h6 class="mb-0 fw-bold">Pago Contra Entrega</h6>
                                <small class="text-muted">Paga en efectivo al recibir tu producto.</small>
                            </div>
                            <i class="bi bi-cash-coin fs-4 text-success"></i>
                        </div>
                    </div>

                </form>
            </div>

            <div class="col-lg-4">
                <div class="card card-resumen bg-white p-4">
                    <h5 class="fw-bold mb-4">Resumen de tu orden</h5>
                    
                    <div class="d-flex justify-content-between mb-2 small text-muted">
                        <span>Productos (${sessionScope.carrito.size()})</span>
                        <span>S/ ${total}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-3 small text-muted">
                        <span>Envío</span>
                        <span class="text-success fw-bold">Gratis</span>
                    </div>
                    
                    <hr>
                    
                    <div class="d-flex justify-content-between mb-4 align-items-center">
                        <span class="fw-bold fs-5">Total a pagar</span>
                        <span class="fw-bold fs-3 text-primary">S/ ${total}</span>
                    </div>

                    <button type="submit" form="#" class="btn btn-success w-100 py-3 fw-bold rounded-pill shadow-sm">
                        CONFIRMAR PAGO <i class="bi bi-arrow-right"></i>
                    </button>
                    
                    <div class="mt-4 text-center">
                        <small class="text-muted d-block mb-2">Aceptamos</small>
                        <div class="d-flex justify-content-center gap-2 grayscale opacity-75">
                            <img src="<c:url value='/imagenes/Iconos/Icono_Yape.png'/>" height="20" alt="Yape">
                            <img src="<c:url value='/imagenes/Iconos/Icono_Plin.png'/>" height="20" alt="Plin">
                            <img src="<c:url value='/imagenes/Iconos/Icono_Visa.png'/>" height="20" alt="Visa" onerror="this.style.display='none'">
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <script>
        function seleccionarPago(metodo) {
            // 1. Marcar el radio button
            document.getElementById('radio' + metodo.charAt(0).toUpperCase() + metodo.slice(1)).checked = true;
            
            // 2. Mostrar/Ocultar detalles visuales
            // Ocultar todos los detalles extra
            document.getElementById('info-yape').classList.add('d-none');
            document.getElementById('info-tarjeta').classList.add('d-none');
            
            // Mostrar el seleccionado
            if(metodo === 'yape') document.getElementById('info-yape').classList.remove('d-none');
            if(metodo === 'tarjeta') document.getElementById('info-tarjeta').classList.remove('d-none');
        }
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>