package pe.idat.controller.inventario;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import pe.idat.entity.AlmacenProducto;
import pe.idat.entity.Categoria;
import pe.idat.repository.CategoriaRepository;
import pe.idat.service.InventarioService;

import java.util.List;

@Controller
@RequestMapping("/inventario")
public class InventarioController {
	
	@Autowired
    private InventarioService inventarioService;

    @Autowired
    private CategoriaRepository categoriaRepository;

 
    @GetMapping("/listar")
    public String mostrarInventario(@RequestParam(name = "categoria", required = false) Integer idCategoria,
                                    Model model) {

        List<Categoria> categorias = categoriaRepository.findAll();
        model.addAttribute("categorias", categorias);

        List<AlmacenProducto> productos = inventarioService.listarPorCategoria(idCategoria);
        model.addAttribute("productos", productos);
        model.addAttribute("categoriaSeleccionada", idCategoria);

        return "inventario/inventario-productos";
    }

    
    @GetMapping("/editar/{idAlmacen}/{idProducto}")
    public String editarStock(@PathVariable("idAlmacen") Integer idAlmacen,
                              @PathVariable("idProducto") Integer idProducto,
                              Model model) {

        AlmacenProducto registro = inventarioService.buscarPorId(idAlmacen, idProducto);
        if (registro != null) {
            model.addAttribute("almacenProducto", registro);
            return "admin/editar-stock";
        } else {
            return "redirect:/admin/inventario";
        }
    }

    // ====================================
    // GUARDAR CAMBIOS DE STOCK
    // ====================================
    @PostMapping("/actualizar")
    public String actualizarStock(@ModelAttribute("almacenProducto") AlmacenProducto almacenProducto) {
        inventarioService.actualizarStock(almacenProducto);
        return "redirect:/admin/inventario";
    }
}