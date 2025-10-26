<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<c:url value='/Styles/Login.css'/>"/>
    <title>Iniciar Sesión</title>
</head>
<body>
    
    <%-- Creamos variables con las URLs para evitar errores de sintaxis --%>
    <c:url var="homeUrl" value="/" />
    <c:url var="registrarUrl" value="/registrar" />

    <%-- Apuntamos la acción al controlador de login que crearemos más adelante --%>
    <form class="login" action="<c:url value='/login'/>" method="post">
        
        <h1>Iniciar Sesión</h1>
        <label for="usuario">Usuario: </label>
        <input type="text" id="usuario" name="usuario" required><br>
        <label for="contraseña">Contraseña: </label>
        <input type="password" id="contraseña" name="contraseña" required><br>
        
        <button type="button" onclick="window.location.href='${registrarUrl}'">Registrarse</button>
        <button type="submit">Entrar</button>
        <button type="button" class="btn-secundario" onclick="window.location.href='${homeUrl}'">Volver al Inicio</button>
        <p>
            <a href="<c:url value='/recuperar-cuenta'/>" class="RecuperarCuenta">Recuperar tu contraseña</a>
        </p>
    </form> 
   
</body>
</html>