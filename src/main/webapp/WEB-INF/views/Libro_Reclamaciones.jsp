<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- La URI correcta para JSTL con Jakarta EE --%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Libro de Reclamaciones</title>
    <link rel="stylesheet" href="<c:url value='/Styles/libro_reclamaciones.css'/>">
</head>
<body>

<h2>Libro de Reclamaciones – Maderera</h2>

<form action="/libro/registrar" method="post">

    <h3>1. Datos del Consumidor</h3>

    <label>Nombre Completo:</label>
    <input type="text" name="nombre" required>

    <label>Documento:</label>
    <select name="tipoDocumento" required>
        <option value="DNI">DNI</option>
        <option value="CE">Carné de Extranjería</option>
    </select>

    <label>Número:</label>
    <input type="text" name="numeroDocumento" required>

    <label>Teléfono:</label>
    <input type="text" name="telefono" required>

    <label>Email:</label>
    <input type="email" name="correo" required>

    <h3>2. Identificación del Bien Contratado</h3>

    <label>Tipo:</label>
    <select name="tipoBien" required>
        <option value="Producto">Producto</option>
        <option value="Servicio">Servicio</option>
    </select>

    <label>Descripción:</label>
    <textarea name="descripcionBien" required></textarea>

    <h3>3. Detalle del Reclamo</h3>

    <label>Tipo de queja:</label>
    <select name="tipoReclamo" required>
        <option value="Reclamo">Reclamo</option>
        <option value="Queja">Queja</option>
    </select>

    <label>Descripción del reclamo/queja:</label>
    <textarea name="detalle" required></textarea>

    <label>Pedido del consumidor:</label>
    <textarea name="pedido" required></textarea>

    <button type="submit">Enviar Reclamo</button>
</form>

</body>
</html>
