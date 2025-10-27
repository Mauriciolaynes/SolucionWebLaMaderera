<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- La URI correcta para JSTL con Jakarta EE --%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Carpintería - Multiservicios</title>
    <link rel="stylesheet" href="<c:url value='/Styles/PaginPrincipal.css'/>">
</head>
<body>

    <header class="header-carpinteria">
        <div class="contenedor-header">
            <nav class="barra-navegacion-carpinteria">
                <ul class="menu-principal-simple">
                    <li><a href="#puertas" class="activo">🚪 Puertas</a></li>
                    <li><a href="#melamina">🗄️ Melamina</a></li>
                    <li><a href="#mesas">🍽️ Mesas</a></li>
                    <li><a href="#sillas">🪑 Sillas</a></li>
                </ul>
            </nav>
            <div class="acciones-header">
                <a href="<c:url value='/login'/>" class="btn-login">Iniciar Sesión</a>
                <a href="#" class="link-carrito">
                    <img src="<c:url value='/imagenes/Carrito/carrito-de-compras.png'/>" alt="Carrito de Compras" class="icono-carrito">
                </a>
            </div>
        </div>
    </header>

    <main class="contenedor-principal">

        <section id="puertas" class="seccion-catalogo">
            <h2>Puertas Contrachapadas y de Madera</h2>
            <div class="galeria-productos">

                <article class="tarjeta-producto">
                    <img src="<c:url value='/imagenes/puertas/puerta_contraplacada_barnizado_id_1.jpg'/>" alt="Puerta Contrachapada Barniz Rústico">
                    <h3>Barniz: Diseño Rústico</h3>
                    <p>Puerta contra placada de interior, madera tornillo, color nogal, acabado barniz, medidas personalizadas.</p>
                    <p>Incluye instalación.</p>
                    <p class="precio">S/.450 </p>
                </article>

                <article class="tarjeta-producto">
                    <img src="<c:url value='/imagenes/puertas/puerta_contraplacada_barnizado_id_2.jpg'/>" alt="Puerta Contrachapada Barniz Moderno">
                    <h3>Barniz: Diseño Moderno</h3>
                    <p>Puerta contra placada de interior, madera tornillo, color caoba, acabado barniz, medidas personalizadas.</p>
                    <p>Incluye instalación.</p>
                    <p class="precio">S/.450 </p>
                </article>

                <article class="tarjeta-producto">
                    <img src="<c:url value='/imagenes/puertas/puerta_contraplacada_caratula_id_1.jpg'/>" alt="Puerta Contrachapada Carátula Clásico">
                    <h3>Carátula: Modelo Clásico</h3>
                    <p>Puerta contra placada de interior, carátula, color caoba, acabado en duco, medias personalizadas.</p>
                    <p>Incluye instalación.</p>
                    <p class="precio">S/.480 </p>
                </article>

                <article class="tarjeta-producto">
                    <img src="<c:url value='/imagenes/puertas/puerta_contraplacada_cedro_id_1.jpg'/>" alt="Puerta de Madera Exterior Cedro Elegante">
                    <h3>Exterior: Madera Cedro (Elegante)</h3>
                    <p>Puerta de madera de exterior cedro, color caoba, acabado barniz, diseño elegante, medias personalizadas.</p>
                    <p>Incluye instalación.</p>
                    <p class="precio">S/.3800 </p>
                </article>

                </div>
        </section>

        <hr>

        <section id="melamina" class="seccion-catalogo">
            <h2>Proyectos de Melamina (Diseño a la medida)</h2>
            <div class="galeria-productos">
                
                <article class="tarjeta-producto">
                    <img src="<c:url value='/imagenes/melamina/melamina_id_1.jpg'/>" alt="Muebles de Cocina Melamina">
                    <h3>Muebles de Cocina</h3>
                    <p>Proyectos de melamina, diseño y color a elegir, medidas personalizadas.</p>
                    <p>Incluye instalación del mueble.</p>
                    <p class="precio">Precio varía (Ref:S/.4000) </p>
                </article>

                <article class="tarjeta-producto">
                    <img src="<c:url value='/imagenes/melamina/melamina_id_2.jpg'/>" alt="Muebles de Dormitorio Melamina">
                    <h3>Muebles de Dormitorio</h3>
                    <p>Proyectos de melamina para dormitorios, diseño y color a elegir, medidas personalizadas.</p>
                    <p>Incluye instalación del mueble.</p>
                    <p class="precio">Precio varía (Ref: S/.4000) </p>
                </article>
                
                </div>
        </section>

        <hr>

        <section id="mesas" class="seccion-catalogo">
            <h2>Mesas</h2>
            <div class="galeria-productos">
                
                <article class="tarjeta-producto">
                    <img src="<c:url value='/imagenes/mesas/mesa_id_1.jpg'/>" alt="Mesa Rústica Redonda">
                    <h3>Mesa Rústica</h3>
                    <p>Mesa rústica, diseño rústico, color natural, modelo rústico.</p>
                    <p class="precio">Precio varía (Ref: S/.100) </p>
                </article>

                <article class="tarjeta-producto">
                    <img src="<c:url value='/imagenes/mesas/mesa_id_2.jpg'/>" alt="Mesa para Campo o Sala">
                    <h3>Mesa para Campo</h3>
                    <p>Mesa para campo, diseño clásico, color natural, modelo clásico.</p>
                    <p class="precio">Precio varía (Ref: S/.400) </p>
                </article>

            </div>
        </section>

        <hr>

        <section id="sillas" class="seccion-catalogo">
            <h2>Sillas</h2>
            <div class="galeria-productos">
                
                <article class="tarjeta-producto">
                    <img src="<c:url value='/imagenes/sillas/silla_id_1.jpg'/>" alt="Silla Clásica de Madera">
                    <h3>Silla Clásica</h3>
                    <p>Sillas clásicas, modelo clásico, color natural.</p>
                    <p class="precio">Precio varía (Ref: S/.60) </p>
                </article>

                <article class="tarjeta-producto">
                    <img src="<c:url value='/imagenes/sillas/silla_id_2.jpg'/>" alt="Silla Elegante Tapizada">
                    <h3>Silla Elegante Tapizada</h3>
                    <p>Sillas elegantes, modelo clásico, tapizados, color caoba.</p>
                    <p class="precio">Precio varía (Ref: S/.90) </p>
                </article>
                
            </div>
        </section>

    </main>

    <footer class="pie-de-pagina">
        <div class="footer-contenedor">
            <div class="footer-columna">
                <h4>Contacto & Atención al Cliente</h4>
                <ul>
                    <li><a href="#">Teléfono Lima (01)500-5540</a></li>
                    <li><a href="#">Libro de Reclamaciones</a></li>
                </ul>
            </div>
            <div class="footer-columna">
                <h4>Sobre Nosotros</h4>
                <ul>
                    <li><a href="#">Nuestra historia</a></li>
                    <li><a href="#">Horarios, locales y zonas de reparto</a></li>
                    <li><a href="#">Trabaja con nosotros</a></li>
                    <li><a href="#">Catalago de productos</a></li>
                    <li><a href="#">Ventas corporativas</a></li>
                    <li><a href="#">Comprobantes electrónicos</a></li>
                    <li><a href="#">Ofrécenos tu inmueble</a></li>
                </ul>
            </div>
            <div class="footer-columna">
                <h4>Políticas & Términos</h4>
                <ul>
                    <li><a href="#">Términos y condiciones de la web</a></li>
                    <li><a href="#">Políticas de privacidad</a></li>
                    <li><a href="#">Políticas de delivery</a></li>
                    <li><a href="#">Términos y condiciones de promociones y campañas</a></li>
                    <li><a href="#">Línea Ética</a></li>
                    <li><a href="#">Pólitica de cookies</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-logo-bottom">
            <%-- La imagen ahora está aquí, centrada en la parte inferior --%>
            <img src="<c:url value='/imagenes/Carrito/footer.png'/>" alt="Logo Maderera Multiservicios">
        </div>
        <div class="footer-copyright">
            <p>&copy; 2024 Maderera Multiservicios. Todos los derechos reservados.</p>
        </div>
    </footer>

    <script>
        // Script para resaltar el enlace de navegación activo al hacer scroll
        const sections = document.querySelectorAll('.seccion-catalogo');
        const navLinks = document.querySelectorAll('.menu-principal-simple a');

        const options = {
            rootMargin: '-50% 0px -50% 0px', // Activa el enlace cuando la sección está en el centro
            threshold: 0
        };

        const observer = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const id = entry.target.getAttribute('id');
                    navLinks.forEach(link => {
                        link.classList.remove('activo');
                        if (link.getAttribute('href') === `#${id}`) {
                            link.classList.add('activo');
                        }
                    });
                }
            });
        }, options);

        sections.forEach(section => {
            observer.observe(section);
        });
    </script>
</body>
</html>