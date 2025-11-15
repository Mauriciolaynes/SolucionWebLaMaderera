package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import pe.idat.entity.Rol;
import pe.idat.entity.Usuario;
import pe.idat.repository.RolRepository;
import pe.idat.repository.UsuarioRepository;

@Controller

public class UsuarioController 
{
	@Autowired
    private UsuarioRepository usuarioRepo;

    @Autowired
    private RolRepository rolRepo;
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

    @PostMapping("/registrar")
    public String registrarUsuario(
            @RequestParam("nombre-apellido") String nombresApellidos,
            @RequestParam("tipo-documento") String tipoDocumento,
            @RequestParam("numero-documento") String numeroDocumento,
            @RequestParam("direccion") String direccion,
            @RequestParam("celular") String celular,
            @RequestParam("correo") String correo,
            @RequestParam("contraseña") String contrasena,
            RedirectAttributes redirectAttributes) {

        // Buscamos el rol 'CLIENTE'. Asumimos que ya existe en la BD.
        Rol rolCliente = rolRepo.findByNombre("CLIENTE");

        // Si el rol no existe, sería bueno manejar el error.
        if (rolCliente == null) {
            // Podrías crear el rol aquí si no existe o lanzar un error.
            redirectAttributes.addFlashAttribute("error", "El rol 'CLIENTE' no está configurado en el sistema.");
            return "redirect:/registrar";
        }
        
        // --- VALIDACIÓN DE USUARIO EXISTENTE ---
        // 1. Validar si el número de documento ya existe
        if (usuarioRepo.findByNumeroDocumento(numeroDocumento) != null) {
            redirectAttributes.addFlashAttribute("error", "Ya hay una persona registrada con este número de documento.");
            return "redirect:/registrar";
        }

        // 2. Validar si el correo ya existe
        if (usuarioRepo.findByCorreo(correo) != null) {
            redirectAttributes.addFlashAttribute("error", "La dirección de correo electrónico ya está en uso.");
            return "redirect:/registrar";
        }

        // Creamos la nueva entidad Usuario
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombresApellidos(nombresApellidos);
        nuevoUsuario.setTipoDocumento(tipoDocumento);
        nuevoUsuario.setNumeroDocumento(numeroDocumento);
        nuevoUsuario.setDireccion(direccion);
        nuevoUsuario.setCelular(celular);
        nuevoUsuario.setCorreo(correo);
        nuevoUsuario.setContrasena(contrasena); // En un sistema real, ¡cifra esta contraseña!
        nuevoUsuario.setRol(rolCliente); // Asignamos el rol de CLIENTE
        nuevoUsuario.setEstado(1); // Estado activo

        usuarioRepo.save(nuevoUsuario);

        // Enviamos un mensaje de éxito a la página de login
        redirectAttributes.addFlashAttribute("exito", "¡Te has registrado con éxito! Ahora puedes iniciar sesión.");
        return "redirect:/login";
    }
    
}
