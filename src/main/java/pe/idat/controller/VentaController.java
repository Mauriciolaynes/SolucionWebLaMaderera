package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import pe.idat.entity.Venta;
import pe.idat.service.ProductoService;
import pe.idat.service.UsuarioService;
import pe.idat.service.VentaService;

@Controller
@RequestMapping("/ventas")
public class VentaController {

    @Autowired
    private VentaService ventaService;

    @Autowired
    private ProductoService productoService;

    @Autowired
    private UsuarioService usuarioService;

    @GetMapping("/listar")
    public String listarVentas(Model model) {
        model.addAttribute("ventas", ventaService.listarVentas());
        return "admin/ventas-listar"; // Vista para listar todas las ventas
    }

    @GetMapping("/nueva")
    public String mostrarFormularioNuevaVenta(Model model) {
        model.addAttribute("venta", new Venta());
        // Enviamos la lista de productos y usuarios (clientes) a la vista
        model.addAttribute("productos", productoService.listar());
        model.addAttribute("usuarios", usuarioService.listarTodos());
        return "admin/venta-formulario"; // Vista con el formulario para crear una venta
    }

    /**
     * Este endpoint es para ser llamado por una API (ej. JavaScript)
     * Recibe el JSON de la venta, la procesa y devuelve el resultado.
     */
    @PostMapping("/guardar")
    @ResponseBody // Importante: indica que el retorno es el cuerpo de la respuesta (JSON)
    public ResponseEntity<?> guardarVenta(@RequestBody Venta venta) {
        try {
            Venta nuevaVenta = ventaService.crearVenta(venta);
            return new ResponseEntity<>(nuevaVenta, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            // Capturamos excepciones de negocio (ej. "Stock insuficiente")
            // y devolvemos un mensaje de error claro.
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            // Otras excepciones inesperadas
            return new ResponseEntity<>("Ocurrió un error inesperado al procesar la venta.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/ver/{id}")
    public String verDetalleVenta(@PathVariable Long id, Model model) {
        Venta venta = ventaService.obtenerVentaPorId(id);
        if (venta == null) {
            return "redirect:/ventas/listar"; // Si no se encuentra, redirigir
        }
        model.addAttribute("venta", venta);
        return "admin/venta-detalle"; // Vista para mostrar los detalles de una venta
    }
}