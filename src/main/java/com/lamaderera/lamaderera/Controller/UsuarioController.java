package com.lamaderera.lamaderera.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class UsuarioController {

    // --- MÉTODOS GET PARA MOSTRAR LAS PÁGINAS ---

    @GetMapping("/login")
    public String verPaginaLogin() {
        return "Login";
    }

    @GetMapping("/registrar")
    public String verPaginaRegistro() {
        return "Registrar";
    }

    @GetMapping("/recuperar-cuenta")
    public String verPaginaRecuperarCuenta() {
        return "RecuperarCuenta";
    }

    @GetMapping("/restablecer-contraseña")
    public String verPaginaRestablecer() {
        return "RestablecerContraseña";
    }

    // --- MÉTODOS POST PARA PROCESAR LOS FORMULARIOS ---

    @PostMapping("/login")
    public String procesarLogin() {
        // Aquí irá la lógica para validar el usuario
        return "redirect:/"; // Redirige a la página principal por ahora
    }

    @PostMapping("/recuperar-cuenta")
    public String procesarRecuperarCuenta() {
        // Aquí irá la lógica para buscar el email del usuario y enviar el correo de recuperación.
        // Por ahora, simplemente redirigimos a la página de restablecer contraseña.
        return "redirect:/restablecer-contraseña";
    }
}