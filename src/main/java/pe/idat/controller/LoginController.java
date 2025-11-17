package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import pe.idat.entity.Usuario;
import pe.idat.repository.UsuarioRepository;


@Controller
public class LoginController {

	@Autowired
    private UsuarioRepository usuarioRepo;

    @PostMapping("/login")
    public String login(
            @RequestParam("usuario") String usuario,
            @RequestParam("contrasena") String contrasena,
            RedirectAttributes redirectAttributes,
            HttpSession session) {

        // Buscar usuario por correo y contraseña
        Usuario user = usuarioRepo.findByCorreoAndContrasena(usuario, contrasena);

        if (user != null) {
            // Guardamos al usuario en la sesión
            session.setAttribute("usuarioLogueado", user);

            String rol = user.getRol().getNombre();
            if ("ADMIN".equalsIgnoreCase(rol)) {
                return "redirect:/admin/admin-dashboard";
            } else if ("VENDEDOR".equalsIgnoreCase(rol)) {
                return "redirect:/ventas/registrar";
            } else if ("CLIENTE".equalsIgnoreCase(rol)) {
                return "redirect:/";
            } else {
                redirectAttributes.addFlashAttribute("error", "Rol no autorizado");
                return "redirect:/login";
            }
        }  else {
            // Verificar si el usuario existe
            Usuario usuarioExistente = usuarioRepo.findByCorreo(usuario);

            if (usuarioExistente == null) {
                redirectAttributes.addFlashAttribute("error", "El usuario no está registrado");
            } else {
                redirectAttributes.addFlashAttribute("error", "Contraseña incorrecta");
            }

            return "redirect:/login";
        }
    }

    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); 
        return "redirect:/login";
    }
}