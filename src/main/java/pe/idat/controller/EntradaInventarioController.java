package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import pe.idat.dto.EntradaMercanciaDTO;
import pe.idat.dto.ProductoEntradaDTO;
import pe.idat.entity.Producto;
import pe.idat.entity.Proveedor;
import pe.idat.entity.Usuario;
import pe.idat.service.InventarioService;
import pe.idat.service.ProductoService;
import pe.idat.service.ProveedorService;

import java.util.ArrayList;
import java.util.List;

/**
 * Controlador para gestionar las entradas de mercancía al inventario
 * Este controlador maneja el proceso de recepción de compras y actualización de
 * stock
 */
@Controller
@RequestMapping("/inventario/entradas")
public class EntradaInventarioController {

    @Autowired
    private InventarioService inventarioService;

    @Autowired
    private ProductoService productoService;

    @Autowired
    private ProveedorService proveedorService;

    /**
     * Muestra el formulario para registrar una nueva entrada de mercancía
     */
    @GetMapping("/nuevo")
    public String mostrarFormularioEntrada(Model model) {
        // Crear DTO vacío
        EntradaMercanciaDTO entradaDTO = new EntradaMercanciaDTO();

        // Cargar listas para los select
        List<Producto> productos = productoService.listar();
        List<Proveedor> proveedores = proveedorService.listarProveedores();

        model.addAttribute("entradaDTO", entradaDTO);
        model.addAttribute("productos", productos);
        model.addAttribute("proveedores", proveedores);

        return "inventario/entrada-mercancia-form";
    }

    /**
     * Procesa el registro de una entrada de mercancía
     * Recibe los datos del formulario y actualiza el inventario
     */
    @PostMapping("/guardar")
    public String guardarEntrada(
            @RequestParam("numeroFactura") String numeroFactura,
            @RequestParam(value = "idProveedor", required = false) Integer idProveedor,
            @RequestParam(value = "observaciones", required = false) String observaciones,
            @RequestParam("productosJson") String productosJson, // Recibiremos JSON con los productos
            HttpSession session,
            RedirectAttributes redirect) {

        try {
            // Obtener usuario de la sesión
            Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
            if (usuarioLogueado == null) {
                redirect.addFlashAttribute("error", "Debe iniciar sesión para realizar esta operación");
                return "redirect:/login";
            }

            // Crear DTO
            EntradaMercanciaDTO entradaDTO = new EntradaMercanciaDTO();
            entradaDTO.setNumeroFactura(numeroFactura);
            entradaDTO.setIdProveedor(idProveedor);
            entradaDTO.setObservaciones(observaciones);

            // Parsear JSON de productos (implementación simple)
            // En producción, usar Jackson o Gson
            List<ProductoEntradaDTO> productos = parsearProductosJson(productosJson);
            entradaDTO.setProductos(productos);

            // Procesar la entrada
            String resultado = inventarioService.procesarEntradaMercancia(
                    entradaDTO,
                    usuarioLogueado.getIdUsuario());

            redirect.addFlashAttribute("success", resultado);
            return "redirect:/inventario/listar";

        } catch (Exception e) {
            redirect.addFlashAttribute("error", "Error al procesar entrada: " + e.getMessage());
            return "redirect:/inventario/entradas/nuevo";
        }
    }

    /**
     * Endpoint REST para registrar entrada vía JSON (para uso con JavaScript)
     */
    @PostMapping("/registrar")
    @ResponseBody
    public ResponseEntity<?> registrarEntradaJSON(
            @RequestBody EntradaMercanciaDTO entradaDTO,
            HttpSession session) {

        try {
            Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
            if (usuarioLogueado == null) {
                return ResponseEntity.status(401).body("Usuario no autenticado");
            }

            String resultado = inventarioService.procesarEntradaMercancia(
                    entradaDTO,
                    usuarioLogueado.getIdUsuario());

            return ResponseEntity.ok(resultado);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    /**
     * Método auxiliar para parsear JSON simple de productos
     * Formato esperado: "idProducto1:cantidad1,idProducto2:cantidad2"
     */
    private List<ProductoEntradaDTO> parsearProductosJson(String productosJson) {
        List<ProductoEntradaDTO> productos = new ArrayList<>();

        if (productosJson == null || productosJson.trim().isEmpty()) {
            return productos;
        }

        String[] items = productosJson.split(",");
        for (String item : items) {
            String[] partes = item.split(":");
            if (partes.length == 2) {
                try {
                    Integer idProducto = Integer.parseInt(partes[0].trim());
                    Integer cantidad = Integer.parseInt(partes[1].trim());
                    productos.add(new ProductoEntradaDTO(idProducto, cantidad));
                } catch (NumberFormatException e) {
                    // Ignorar items mal formateados
                }
            }
        }

        return productos;
    }
}
