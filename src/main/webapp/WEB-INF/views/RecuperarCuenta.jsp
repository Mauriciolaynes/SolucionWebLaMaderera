<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Cuenta de Usuario</title>
    <link rel="stylesheet" href="<c:url value='/Styles/Login.css'/>"/>
</head>
<body>
    <%-- Creamos una variable con la URL de la página principal para evitar errores de sintaxis --%>
    <c:url var="homeUrl" value="/" />
    <c:url var="RestablecerContraseña" value="/restablecer-contraseña" />


    <form class="recuperarcuenta" action="<c:url value='/recuperar-cuenta'/>" method="post">
        <h1>Recuperar Cuenta de Usuario</h1>
        <label for="direccion">Dirección</label>
        <input type="email" id="direccion" name="direccion" required>
        
        <button type="button" onclick="window.location.href='${RestablecerContraseña}'">Buscar</button>
        <button type="button" class="btn-secundario" onclick="window.location.href='${homeUrl}'">Volver al Inicio</button>
              
    </form> 
    
</body>
</html>