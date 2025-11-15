package pe.idat.controller;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import pe.idat.entity.Rol;
import pe.idat.entity.Usuario;
import pe.idat.repository.RolRepository;
import pe.idat.repository.UsuarioRepository;

@Controller
public class AdminController {
	@Autowired
    private UsuarioRepository usuarioRepo;

    @Autowired
    private RolRepository rolRepo;

    // --- DASHBOARD ADMIN ---
    @GetMapping("/admin/admin-dashboard")
    public String mostrarDashboard() {
        return "admin/admin-dashboard"; // JSP: WEB-INF/views/admin/admin-dashboard.jsp
    }

    // --- GESTIÓN DE EMPLEADOS ---
    @GetMapping("/admin/form-empleado")
    public String verFormularioEmpleado(Model model) {
        model.addAttribute("roles", rolRepo.findAll());
        return "admin/form-empleado"; // JSP: WEB-INF/views/admin/form-empleado.jsp
    }
    
    @GetMapping("/admin/listar-empleados")
    public String listarEmpleados(
            @RequestParam(name = "nombre", required = false) String nombre,
            @RequestParam(name = "rolId", required = false) Integer rolId,
            Model model) {

        List<Usuario> empleados;

        if ((nombre == null || nombre.isEmpty()) && rolId == null) {
            // Sin filtros
            empleados = usuarioRepo.findAll();
        } else if ((nombre != null && !nombre.isEmpty()) && rolId != null) {
            // Filtrar por nombre y rol
            empleados = usuarioRepo.findByNombresApellidosContainingIgnoreCaseAndRolIdRol(nombre, rolId);
        } else if (nombre != null && !nombre.isEmpty()) {
            // Filtrar solo por nombre
            empleados = usuarioRepo.findByNombresApellidosContainingIgnoreCase(nombre);
        } else {
            // Filtrar solo por rol
            empleados = usuarioRepo.findByRolIdRol(rolId);
        }

        model.addAttribute("empleados", empleados);
        model.addAttribute("roles", rolRepo.findAll());
        return "admin/listar-empleados";
    }

    
    @PostMapping("/admin/guardarEmpleado")
    public String guardarEmpleado(
            @RequestParam String nombresApellidos,
            @RequestParam String tipoDocumento,
            @RequestParam String numeroDocumento,
            @RequestParam String direccion,
            @RequestParam String celular,
            @RequestParam String correo,
            @RequestParam String contrasena,
            @RequestParam Integer idRol,
            RedirectAttributes redirectAttributes) {

        Rol rolSeleccionado = rolRepo.findById(idRol).orElse(null);

        if (rolSeleccionado == null) {
            redirectAttributes.addFlashAttribute("error", "Rol no válido.");
            return "redirect:/admin/listar-empleados";
        }

        // Evitar duplicados
        if (usuarioRepo.findByCorreo(correo) != null) {
            redirectAttributes.addFlashAttribute("error", "Ya existe un usuario con este correo.");
            return "redirect:/admin/listar-empleados";
        }

        Usuario nuevoEmpleado = new Usuario();
        nuevoEmpleado.setNombresApellidos(nombresApellidos);
        nuevoEmpleado.setTipoDocumento(tipoDocumento);
        nuevoEmpleado.setNumeroDocumento(numeroDocumento);
        nuevoEmpleado.setDireccion(direccion);
        nuevoEmpleado.setCelular(celular);
        nuevoEmpleado.setCorreo(correo);
        nuevoEmpleado.setContrasena(contrasena); // En un sistema real, cifrar
        nuevoEmpleado.setRol(rolSeleccionado);
        nuevoEmpleado.setEstado(1);

        usuarioRepo.save(nuevoEmpleado);

        redirectAttributes.addFlashAttribute("exito", "Empleado registrado correctamente.");
        return "redirect:/admin/listar-empleados";
    }
    
 // FORMULARIO EDITAR
    @GetMapping("/admin/empleados/editar/{idUsuario}")
    public String editarEmpleado(@PathVariable Integer idUsuario, Model model, RedirectAttributes redirectAttributes) {
        Usuario empleado = usuarioRepo.findById(idUsuario).orElse(null);
        if (empleado == null) {
            redirectAttributes.addFlashAttribute("error", "Empleado no encontrado.");
            return "redirect:/admin/form-empleado-editar";
        }
        model.addAttribute("empleado", empleado);
        model.addAttribute("roles", rolRepo.findAll());
        return "admin/form-empleado-editar"; // Crear JSP para edición
    }

    // ACTUALIZAR EMPLEADO
    @PostMapping("/admin/empleados/actualizar")
    public String actualizarEmpleado(
            @RequestParam Integer idUsuario,
            @RequestParam String nombresApellidos,
            @RequestParam String tipoDocumento,
            @RequestParam String numeroDocumento,
            @RequestParam String direccion,
            @RequestParam String celular,
            @RequestParam String correo,
            @RequestParam String contrasena,
            @RequestParam Integer idRol,
            RedirectAttributes redirectAttributes) {

        Usuario empleado = usuarioRepo.findById(idUsuario).orElse(null);
        if (empleado == null) {
            redirectAttributes.addFlashAttribute("error", "Empleado no encontrado.");
            return "redirect:/admin/listar-empleados";
        }

        Rol rol = rolRepo.findById(idRol).orElse(null);
        if (rol == null) {
            redirectAttributes.addFlashAttribute("error", "Rol no válido.");
            return "redirect:/admin/empleados/editar/" + idUsuario;
        }

        empleado.setNombresApellidos(nombresApellidos);
        empleado.setTipoDocumento(tipoDocumento);
        empleado.setNumeroDocumento(numeroDocumento);
        empleado.setDireccion(direccion);
        empleado.setCelular(celular);
        empleado.setCorreo(correo);
        empleado.setContrasena(contrasena);
        empleado.setRol(rol);

        usuarioRepo.save(empleado);
        redirectAttributes.addFlashAttribute("exito", "Empleado actualizado correctamente.");
        return "redirect:/admin/listar-empleados";
    }

    // ELIMINAR EMPLEADO
    @GetMapping("/admin/empleados/eliminar/{idUsuario}")
    public String eliminarEmpleado(@PathVariable Integer idUsuario, RedirectAttributes redirectAttributes) {
        Usuario empleado = usuarioRepo.findById(idUsuario).orElse(null);
        if (empleado != null) {
            usuarioRepo.delete(empleado);
            redirectAttributes.addFlashAttribute("exito", "Empleado eliminado correctamente.");
        } else {
            redirectAttributes.addFlashAttribute("error", "Empleado no encontrado.");
        }
        return "redirect:/admin/listar-empleados";
    }

}