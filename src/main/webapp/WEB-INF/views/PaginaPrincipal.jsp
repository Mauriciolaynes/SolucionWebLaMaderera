<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Carpintería - Multiservicios</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<c:url value='/Styles/PaginPrincipal.css'/>">

    <style>
        /* Estilos rápidos para asegurar que las tarjetas se vean bien */
        .card-img-container {
            height: 220px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            border-bottom: 1px solid #eee;
        }
        .card-img-top {
            max-height: 100%;
            width: auto;
            max-width: 100%;
            transition: transform 0.3s ease;
        }
        .card:hover .card-img-top {
            transform: scale(1.05);
        }
        /* Ocultar flechas del input number */
        input[type=number]::-webkit-inner-spin-button, 
        input[type=number]::-webkit-outer-spin-button { 
            -webkit-appearance: none; margin: 0; 
        }
    </style>
</head>
<body data-bs-spy="scroll" data-bs-target="#main-nav">

    <header>
        <nav id="main-nav" class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top shadow">
            <div class="container">
                <a class="navbar-brand" href="<c:url value='/'/>">
                    <img src="<c:url value='/imagenes/Logo/Logo.png'/>" alt="Logo Maderera" style="height: 40px;">
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link" href="#puertas">🚪 Puertas</a></li>
                        <li class="nav-item"><a class="nav-link" href="#melamina">🗄️ Melamina</a></li>
                        <li class="nav-item"><a class="nav-link" href="#mesas">🍽️ Mesas</a></li>
                        <li class="nav-item"><a class="nav-link" href="#sillas">🪑 Sillas</a></li>
                    </ul>
                    <div class="d-flex align-items-center gap-3">
                        
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuarioLogueado}">
                                <div class="text-white d-none d-lg-block">
                                    <small>Hola,</small><br>
                                    <strong>${sessionScope.usuarioLogueado.nombresApellidos}</strong>
                                </div>
                                <a href="<c:url value='/logout'/>" class="btn btn-outline-danger btn-sm">Salir</a>
                            </c:when>
                            <c:otherwise>
                                <a href="<c:url value='/login'/>" class="btn btn-primary btn-sm">Iniciar Sesión</a>
                            </c:otherwise>
                        </c:choose>

                        <a href="<c:url value='/carrito'/>" class="position-relative btn btn-outline-light border-0">
                            <i class="bi bi-cart3 fs-4"></i>
                            <c:if test="${not empty sessionScope.carrito}">
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-light">
                                    ${sessionScope.carrito.size()}
                                </span>
                            </c:if>
                        </a>
                    </div>
                </div>
            </div>
        </nav>
    </header>

    <main class="container" style="margin-top: 100px;">

        <section id="puertas" class="py-5">
            <h2 class="mb-4 border-bottom pb-2">Puertas Contrachapadas y de Madera</h2>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                <c:forEach items="${listaProductos}" var="p">
                    <c:if test="${p.categoria.idCategoria == 1}">
                        <div class="col">
                            <div class="card shadow-sm h-100 border-0">
                                <div class="card-img-container">
                                    <img src="<c:url value='/${p.imagen}'/>" class="card-img-top" alt="${p.nombre}">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title text-truncate">${p.nombre}</h5>
                                    <p class="card-text small text-muted flex-grow-1 text-truncate">${p.descripcion}</p>
                                    <p class="precio fs-5 fw-bold text-primary mb-3">S/. ${p.precioVenta}</p>
                                    
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                                            <form action="<c:url value='/carrito/agregar'/>" method="post" class="mt-auto">
                                                <input type="hidden" name="idProducto" value="${p.idProducto}">
                                                
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="input-group input-group-sm" style="width: 110px;">
                                                        <button type="button" class="btn btn-outline-secondary" onclick="ajustarCantidad(this, -1)">-</button>
                                                        <input type="number" name="cantidad" value="1" min="1" class="form-control text-center p-0" readonly style="background: white;">
                                                        <button type="button" class="btn btn-outline-secondary" onclick="ajustarCantidad(this, 1)">+</button>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary btn-sm flex-fill">
                                                        <i class="bi bi-cart-plus"></i>
                                                    </button>
                                                </div>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="<c:url value='/login'/>" class="btn btn-outline-secondary btn-sm w-100 mt-auto">Login para comprar</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </section>

        <section id="melamina" class="py-5">
            <h2 class="mb-4 border-bottom pb-2">Proyectos de Melamina</h2>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                <c:forEach items="${listaProductos}" var="p">
                    <c:if test="${p.categoria.idCategoria == 2}">
                        <div class="col">
                            <div class="card shadow-sm h-100 border-0">
                                <div class="card-img-container">
                                    <img src="<c:url value='/${p.imagen}'/>" class="card-img-top" alt="${p.nombre}">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title text-truncate">${p.nombre}</h5>
                                    <p class="card-text small text-muted flex-grow-1 text-truncate">${p.descripcion}</p>
                                    <p class="precio fs-5 fw-bold text-primary mb-3">Ref: S/. ${p.precioVenta}</p>
                                    
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                                            <form action="<c:url value='/carrito/agregar'/>" method="post" class="mt-auto">
                                                <input type="hidden" name="idProducto" value="${p.idProducto}">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="input-group input-group-sm" style="width: 110px;">
                                                        <button type="button" class="btn btn-outline-secondary" onclick="ajustarCantidad(this, -1)">-</button>
                                                        <input type="number" name="cantidad" value="1" min="1" class="form-control text-center p-0" readonly style="background: white;">
                                                        <button type="button" class="btn btn-outline-secondary" onclick="ajustarCantidad(this, 1)">+</button>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary btn-sm flex-fill"><i class="bi bi-cart-plus"></i></button>
                                                </div>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="<c:url value='/login'/>" class="btn btn-outline-secondary btn-sm w-100 mt-auto">Login</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </section>

        <section id="mesas" class="py-5">
            <h2 class="mb-4 border-bottom pb-2">Mesas</h2>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                <c:forEach items="${listaProductos}" var="p">
                    <c:if test="${p.categoria.idCategoria == 3}">
                        <div class="col">
                            <div class="card shadow-sm h-100 border-0">
                                <div class="card-img-container">
                                    <img src="<c:url value='/${p.imagen}'/>" class="card-img-top" alt="${p.nombre}">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title text-truncate">${p.nombre}</h5>
                                    <p class="card-text small text-muted flex-grow-1 text-truncate">${p.descripcion}</p>
                                    <p class="precio fs-5 fw-bold text-primary mb-3">S/. ${p.precioVenta}</p>
                                    
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                                            <form action="<c:url value='/carrito/agregar'/>" method="post" class="mt-auto">
                                                <input type="hidden" name="idProducto" value="${p.idProducto}">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="input-group input-group-sm" style="width: 110px;">
                                                        <button type="button" class="btn btn-outline-secondary" onclick="ajustarCantidad(this, -1)">-</button>
                                                        <input type="number" name="cantidad" value="1" min="1" class="form-control text-center p-0" readonly style="background: white;">
                                                        <button type="button" class="btn btn-outline-secondary" onclick="ajustarCantidad(this, 1)">+</button>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary btn-sm flex-fill"><i class="bi bi-cart-plus"></i></button>
                                                </div>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="<c:url value='/login'/>" class="btn btn-outline-secondary btn-sm w-100 mt-auto">Login</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </section>

        <section id="sillas" class="py-5">
            <h2 class="mb-4 border-bottom pb-2">Sillas</h2>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                <c:forEach items="${listaProductos}" var="p">
                    <c:if test="${p.categoria.idCategoria == 4}">
                        <div class="col">
                            <div class="card shadow-sm h-100 border-0">
                                <div class="card-img-container">
                                    <img src="<c:url value='/${p.imagen}'/>" class="card-img-top" alt="${p.nombre}">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title text-truncate">${p.nombre}</h5>
                                    <p class="card-text small text-muted flex-grow-1 text-truncate">${p.descripcion}</p>
                                    <p class="precio fs-5 fw-bold text-primary mb-3">S/. ${p.precioVenta}</p>
                                    
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                                            <form action="<c:url value='/carrito/agregar'/>" method="post" class="mt-auto">
                                                <input type="hidden" name="idProducto" value="${p.idProducto}">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="input-group input-group-sm" style="width: 110px;">
                                                        <button type="button" class="btn btn-outline-secondary" onclick="ajustarCantidad(this, -1)">-</button>
                                                        <input type="number" name="cantidad" value="1" min="1" class="form-control text-center p-0" readonly style="background: white;">
                                                        <button type="button" class="btn btn-outline-secondary" onclick="ajustarCantidad(this, 1)">+</button>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary btn-sm flex-fill"><i class="bi bi-cart-plus"></i></button>
                                                </div>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="<c:url value='/login'/>" class="btn btn-outline-secondary btn-sm w-100 mt-auto">Login</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </section>

    </main>

    <footer class="footer-bg pt-5 pb-4 mt-5 bg-dark text-white">
        <div class="container text-center text-md-start">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h6 class="text-uppercase fw-bold text-warning">Maderera Multiservicios</h6>
                    <p class="small text-white-50">Calidad y garantía en trabajos de madera y melamina.</p>
                </div>
                <div class="col-md-4 mb-3">
                    <h6 class="text-uppercase fw-bold text-warning">Contacto</h6>
                    <ul class="list-unstyled small text-white-50">
                        <li>Lima (01)500-5540</li>
                        <li><a href="<c:url value='/libro-reclamaciones'/>" class="text-white-50 text-decoration-none">Libro de Reclamaciones</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-3">
                    <h6 class="text-uppercase fw-bold text-warning">Pagos Seguros</h6>
                    <div class="bg-white p-2 rounded d-inline-block">
                        <img src="<c:url value='/imagenes/iconos/Icono_Yape.png'/>" alt="Yape" height="25" class="me-2">
                        <img src="<c:url value='/imagenes/iconos/Icono_Plin.png'/>" alt="Plin" height="25" class="me-2">
                        <img src="<c:url value='/imagenes/iconos/Icono_PayPal.png'/>" alt="Paypal" height="25">
                    </div>
                </div>
            </div>
            <div class="text-center mt-3 pt-3 border-top border-secondary small text-white-50">
                &copy; 2025 Maderera Multiservicios. Todos los derechos reservados.
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function ajustarCantidad(btn, cambio) {
            // Buscamos el input vecino dentro del mismo grupo
            var input = btn.parentNode.querySelector('input[name="cantidad"]');
            var valorActual = parseInt(input.value);
            var nuevoValor = valorActual + cambio;

            // Validamos que no baje de 1
            if (nuevoValor >= 1) {
                input.value = nuevoValor;
            }
        }
    </script>

</body>
</html>