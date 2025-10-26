<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Cuenta Nueva</title>
    <link rel="stylesheet" href="<c:url value='/Styles/Login.css'/>"/>
</head>
<body>
    <%-- Creamos una variable con la URL de la página principal para evitar errores de sintaxis --%>
    <c:url var="homeUrl" value="/" />

    <form class="registrar" action="<c:url value='/registrar'/>" method="post">
        <h1>Registrar Nuevo Usuario</h1>

        <label for="nombre-apellido">Nombres y Apellidos</label>
        <input type="text" id="nombre-apellido" name="nombre-apellido" required>

        <div class="columnas">
    <div class="col">
        <label for="tipo-documento">Tipo de Documento</label><br>
        <select id="tipo-documento" name="tipo-documento" required>
            <option value="">Seleccione</option>
            <option value="dni">DNI</option>
            <option value="ce">Carnet de Extranjería</option>
        </select>
    </div>
    <div class="col">
        <label for="numero-documento">Número de Documento</label><br>
        <input type="text" id="numero-documento" name="numero-documento" placeholder="Ingrese su número" required>
    </div>
</div>


        <label for="direccion">Dirección</label>
        <input type="text" id="direccion" name="direccion" required>

        <label for="celular">Celular</label>
        <input type="tel" id="celular" name="celular" required>

        <label for="correo">Correo Electrónico</label>
        <input type="email" id="correo" name="correo" required>

        <label for="contraseña">Contraseña</label>
        <input type="password" id="contraseña" name="contraseña" required>

        <button type="submit">Registrar</button>
        <button type="button" class="btn-secundario" onclick="window.location.href='${homeUrl}'">Volver al Inicio</button>
    </form>
</body>
</html>
