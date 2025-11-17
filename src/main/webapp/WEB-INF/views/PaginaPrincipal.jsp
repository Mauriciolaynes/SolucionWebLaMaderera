<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- La URI correcta para JSTL con Jakarta EE --%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Carpintería - Multiservicios</title>
    <!-- CSS de Bootstrap y estilos personalizados -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="<c:url value='/Styles/PaginPrincipal.css'/>">
</head>
<body data-bs-spy="scroll" data-bs-target="#main-nav">

    <header>
        <nav id="main-nav" class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <div class="container">
                <a class="navbar-brand" href="<c:url value='/'/>">
                    <img src="<c:url value='/imagenes/Logo/Logo.png'/>" alt="Logo Maderera">
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link" href="#puertas">🚪 Puertas</a></li>
                        <li class="nav-item"><a class="nav-link" href="#melamina">🗄️ Melamina</a></li>
                        <li class="nav-item"><a class="nav-link" href="#mesas">🍽️ Mesas</a></li>
                        <li class="nav-item"><a class="nav-link" href="#sillas">🪑 Sillas</a></li>
                    </ul>
                    <div class="d-flex align-items-center">
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuarioLogueado}">
                                <span class="navbar-text text-white me-3">
                                    👋 Hola, ${sessionScope.usuarioLogueado.nombresApellidos}
                                </span>
                                <a href="<c:url value='/logout'/>" class="btn btn-outline-light me-2">Cerrar sesión</a>
                            </c:when>
                            <c:otherwise>
                                <a href="<c:url value='/login'/>" class="btn btn-primary me-2">Iniciar Sesión</a>
                            </c:otherwise>
                        </c:choose>
                        <a href="#" class="link-carrito">
                            <img src="<c:url value='/imagenes/Carrito/carrito-de-compras.png'/>" alt="Carrito de Compras" style="width: 32px;">
                        </a>
                    </div>
                </div>
            </div>
        </nav>
    </header>

    <main class="container" style="margin-top: 80px;">

        <section id="puertas" class="py-5">
            <h2>Puertas Contrachapadas y de Madera</h2>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mt-3">

                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-img-container">
                            <img src="<c:url value='imagenes/puertas/puerta 1.png'/>" class="card-img-top" alt="Puerta Contrachapada Barniz Rústico">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">Barniz: Diseño Rústico</h5>
                            <p class="card-text">Puerta contra placada de interior, madera tornillo, color nogal, acabado barniz, medidas personalizadas. Incluye instalación.</p>
                            <p class="precio">S/.450</p>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-img-container">
                            <img src="<c:url value='imagenes/puertas/puerta 2.png'/>" class="card-img-top" alt="Puerta Contrachapada Barniz Moderno">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">Barniz: Diseño Moderno</h5>
                            <p class="card-text">Puerta contra placada de interior, madera tornillo, color caoba, acabado barniz, medidas personalizadas. Incluye instalación.</p>
                            <p class="precio">S/.450</p>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-img-container">
                            <img src="<c:url value='imagenes/puertas/puerta 3.png'/>" class="card-img-top" alt="Puerta Contrachapada Carátula Clásico">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">Carátula: Modelo Clásico</h5>
                            <p class="card-text">Puerta contra placada de interior, carátula, color caoba, acabado en duco, medias personalizadas. Incluye instalación.</p>
                            <p class="precio">S/.480</p>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-img-container">
                            <img src="<c:url value='imagenes/puertas/puerta 4.png'/>" class="card-img-top" alt="Puerta de Madera Exterior Cedro Elegante">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">Exterior: Madera Cedro (Elegante)</h5>
                            <p class="card-text">Puerta de madera de exterior cedro, color caoba, acabado barniz, diseño elegante, medias personalizadas. Incluye instalación.</p>
                            <p class="precio">S/.3800</p>
                        </div>
                    </div>
                </div>

            </div>
        </section>

        <hr>

        <section id="melamina" class="py-5">
            <h2>Proyectos de Melamina (Diseño a la medida)</h2>
            <div class="row row-cols-1 row-cols-md-2 g-4 mt-3">
                
                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-img-container">
                            <img src="<c:url value='/imagenes/melamina/Melamina 1.png'/>" class="card-img-top" alt="Muebles de Cocina Melamina">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">Muebles de Cocina</h5>
                            <p class="card-text">Proyectos de melamina, diseño y color a elegir, medidas personalizadas. Incluye instalación del mueble.</p>
                            <p class="precio">Precio varía (Ref:S/.4000)</p>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-img-container">
                            <img src="<c:url value='/imagenes/melamina/Melamina 2.png'/>" class="card-img-top" alt="Muebles de Dormitorio Melamina">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">Muebles de Dormitorio</h5>
                            <p class="card-text">Proyectos de melamina para dormitorios, diseño y color a elegir, medidas personalizadas. Incluye instalación del mueble.</p>
                            <p class="precio">Precio varía (Ref: S/.4000)</p>
                        </div>
                    </div>
                </div>
                
            </div>
        </section>

        <hr>

        <section id="mesas" class="py-5">
            <h2>Mesas</h2>
            <div class="row row-cols-1 row-cols-md-2 g-4 mt-3">
                
                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-img-container">
                            <img src="<c:url value='/imagenes/mesas/Mesa 1.png'/>" class="card-img-top" alt="Mesa Rústica Redonda">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">Mesa Rústica</h5>
                            <p class="card-text">Mesa rústica, diseño rústico, color natural, modelo rústico.</p>
                            <p class="precio">Precio varía (Ref: S/.100)</p>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-img-container">
                            <img src="<c:url value='/imagenes/mesas/Mesa 2.png'/>" class="card-img-top" alt="Mesa para Campo o Sala">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">Mesa para Campo</h5>
                            <p class="card-text">Mesa para campo, diseño clásico, color natural, modelo clásico.</p>
                            <p class="precio">Precio varía (Ref: S/.400)</p>
                        </div>
                    </div>
                </div>

            </div>
        </section>

        <hr>

        <section id="sillas" class="py-5">
            <h2>Sillas</h2>
            <div class="row row-cols-1 row-cols-md-2 g-4 mt-3">
                
                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-img-container">
                            <img src="<c:url value='/imagenes/sillas/Silla 1.png'/>" class="card-img-top" alt="Silla Clásica de Madera">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">Silla Clásica</h5>
                            <p class="card-text">Sillas clásicas, modelo clásico, color natural.</p>
                            <p class="precio">Precio varía (Ref: S/.60)</p>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-img-container">
                            <img src="<c:url value='/imagenes/sillas/Silla 2.png'/>" class="card-img-top" alt="Silla Elegante Tapizada">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">Silla Elegante Tapizada</h5>
                            <p class="card-text">Sillas elegantes, modelo clásico, tapizados, color caoba.</p>
                            <p class="precio">Precio varía (Ref: S/.90)</p>
                        </div>
                    </div>
                </div>
                
            </div>
        </section>

    </main>

    <footer class="footer-bg pt-5 pb-4">
        <div class="container text-center text-md-start">
            <div class="row text-center text-md-start">

                <div class="col-md-3 col-lg-3 col-xl-3 mx-auto mt-3">
                    <h5 class="text-uppercase mb-4 fw-bold text-primary">Contacto</h5>
                    <ul class="list-unstyled">
                        <li><a href="#">Teléfono Lima (01)500-5540</a></li>
                        <li class="mt-2">
                            <a href="<c:url value='/libro-reclamaciones'/>">Libro de Reclamaciones</a>
                            <%-- Aquí se añade la imagen del libro de reclamaciones --%>
                            <a href="<c:url value='/libro-reclamaciones'/>"><img src="<c:url value='/imagenes/Iconos/libro-de-reclamaciones.png'/>" alt="Libro de Reclamaciones" style="max-width: 120px; margin-top: 8px; display: block;"></a>
                        </li>
                    </ul>
                </div>

                <div class="col-md-3 col-lg-3 col-xl-3 mx-auto mt-3">
                    <h5 class="text-uppercase mb-4 fw-bold text-primary">Sobre Nosotros</h5>
                    <ul class="list-unstyled">
                        <li><a href="#">Nuestra historia</a></li>
                        <li><a href="#">Horarios y locales</a></li>
                        <li><a href="#">Trabaja con nosotros</a></li>
                        <li><a href="#">Ventas corporativas</a></li>
                    </ul>
                </div>

                <div class="col-md-3 col-lg-3 col-xl-3 mx-auto mt-3">
                    <h5 class="text-uppercase mb-4 fw-bold text-primary">Políticas & Términos</h5>
                    <ul class="list-unstyled">
                        <li><a href="#">Términos y condiciones</a></li>
                        <li><a href="#">Políticas de privacidad</a></li>
                        <li><a href="#">Políticas de delivery</a></li>
                        <li><a href="#">Pólitica de cookies</a></li>
                    </ul>
                </div>

            </div>
            <hr class="my-4">
            
            <!-- Métodos de pago -->
            <div class="text-center p-3 border rounded">
                <h6 class="text-uppercase fw-bold mb-3">Métodos de pago seguros</h6>
                <%-- Asegúrate de que los nombres de archivo coincidan con los que tienes en la carpeta /imagenes/iconos/ --%>
                <a href="https://www.izipay.pe/" target="_blank" rel="noopener noreferrer">
                    <img src="<c:url value='/imagenes/iconos/icono_IziPay.png'/>" alt="IziPay" class="me-2" style="height: 35px;">
                </a>
                <a href="https://www.mercadopago.com.pe/" target="_blank" rel="noopener noreferrer">
                    <img src="<c:url value='/imagenes/iconos/Icono_MercadoP.png'/>" alt="MercadoPago" class="me-2" style="height: 35px;">
                </a>
                <a href="https://www.paypal.com/pe/home" target="_blank" rel="noopener noreferrer">
                    <img src="<c:url value='/imagenes/iconos/Icono_PayPal.png'/>" alt="PayPal" class="me-2" style="height: 35px;">
                </a>
                <a href="https://www.plin.pe/" target="_blank" rel="noopener noreferrer">
                    <img src="<c:url value='/imagenes/iconos/Icono_Plin.png'/>" alt="Plin" class="me-2" style="height: 35px;">
                </a>
                <a href="https://www.yape.com.pe/" target="_blank" rel="noopener noreferrer">
                    <img src="<c:url value='/imagenes/iconos/Icono_Yape.png'/>" alt="Yape" class="me-2" style="height: 35px;">
                </a>
            </div>

            <div class="text-center mb-2">
                <img src="<c:url value='/imagenes/Carrito/footer.png'/>" alt="Logo Maderera Multiservicios" style="max-height: 50px;">
            </div>
            <div class="text-center">
                <p>&copy; 2024 Maderera Multiservicios. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>
</body>
</html>