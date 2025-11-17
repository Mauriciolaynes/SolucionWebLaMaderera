package pe.idat.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import pe.idat.entity.Proveedor;
import pe.idat.repository.ProveedorRepository;

@Controller
@RequestMapping("/proveedores")
public class ProveedorController {
	@Autowired
    private ProveedorRepository proveedorRepo;

    // Listar todos
    @GetMapping("/listar")
    public String listarProveedores(Model model) {
        List<Proveedor> proveedores = proveedorRepo.findAll();
        model.addAttribute("proveedores", proveedores);
        return "compras/proveedor-listar";
    }

    // Mostrar formulario de nuevo proveedor
    @GetMapping("/nuevo")
    public String nuevoProveedor(Model model) {
        model.addAttribute("proveedor", new Proveedor());
        return "compras/proveedor-form";
    }

    // Guardar o actualizar
    @PostMapping("/guardar")
    public String guardarProveedor(@Valid @ModelAttribute("proveedor") Proveedor proveedor,
                                   BindingResult result, Model model) {

        if (result.hasErrors()) {
            return "compras/proveedor-form";
        }

        // Validar RUC duplicado
        Proveedor proveedorExistente = proveedorRepo.findByRuc(proveedor.getRuc());
        if (proveedorExistente != null && !proveedorExistente.getIdProveedor().equals(proveedor.getIdProveedor())) {
            model.addAttribute("error", "El RUC ya está registrado");
            return "compras/proveedor-form";
        }

        // Validar correo duplicado
        Proveedor correoExistente = proveedorRepo.findByCorreo(proveedor.getCorreo());
        if (correoExistente != null && !correoExistente.getIdProveedor().equals(proveedor.getIdProveedor())) {
            model.addAttribute("error", "El correo ya está registrado");
            return "compras/proveedor-form";
        }

        proveedorRepo.save(proveedor);
        model.addAttribute("exito", "Proveedor guardado correctamente");
        return "redirect:/proveedores/listar";
    }

    // Editar proveedor
    @GetMapping("/editar/{id}")
    public String editarProveedor(@PathVariable("id") Integer id, Model model) {
        Proveedor proveedor = proveedorRepo.findById(id).orElse(null);
        if (proveedor == null) {
            return "redirect:/proveedores/listar";
        }
        model.addAttribute("proveedor", proveedor);
        return "compras/proveedor-actualizar";
    }

    // Eliminar proveedor
    @GetMapping("/eliminar/{id}")
    public String eliminarProveedor(@PathVariable("id") Integer id) {
        proveedorRepo.deleteById(id);
        return "redirect:/proveedores/listar";
    }
}
