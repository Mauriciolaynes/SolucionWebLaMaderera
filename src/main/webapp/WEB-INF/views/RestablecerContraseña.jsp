<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restablecer Contraseña</title>
    <link rel="stylesheet" href="<c:url value='/Styles/Login.css'/>"/>
</head>
<body>

    <%-- Creamos una variable con la URL de la página principal para evitar errores de sintaxis --%>
    <c:url var="homeUrl" value="/" />

    <form class="restablecercuenta" action="<c:url value='/restablecer-contraseña'/>" method="post">
        <h1>Restablecer Contraseña Nueva</h1>
        <label for="contraseña">Contraseña Nueva</label>
        <input type="password" id="contraseña" name="contraseña" required>
        
        <label for="contraseñaN">Validar Contraseña Nueva</label>
        <input type="password" id="contraseñaN" name="contraseñaN" required>
        
        <button type="submit">Restablecer Contraseña</button>
        <button type="button" class="btn-secundario" onclick="window.location.href='${homeUrl}'">Volver al Inicio</button>

    </form>
</body>
</html>