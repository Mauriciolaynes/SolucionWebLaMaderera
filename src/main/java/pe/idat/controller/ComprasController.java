package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import pe.idat.entity.*;
import pe.idat.service.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/compras")
public class ComprasController {

    @Autowired
    private PedidoCompraService pedidoCompraService;

    @Autowired
    private CotizacionService cotizacionService;

    @Autowired
    private OrdenCompraService ordenCompraService;

    @Autowired
    private FacturaCompraService facturaCompraService;

    @Autowired
    private ProveedorService proveedorService; // <--- AGREGADO: Necesario para los combos

    // --- Vista principal ---
    @GetMapping
    public String vistaCompras(Model model) {
        // Cargar todas las listas para la vista principal
        // Asegúrate de que los métodos .listar...() existan en tus servicios
        model.addAttribute("pedidos", pedidoCompraService.listarTodos());
        model.addAttribute("cotizaciones", cotizacionService.listarCotizaciones());
        model.addAttribute("ordenes", ordenCompraService.listarOrdenes());
        model.addAttribute("facturas", facturaCompraService.listarFacturas());
        
        return "pedidos_compra/Listado-Compras";
    }

    // --- Cotizaciones ---
    @GetMapping("/cotizaciones/nueva")
    public String formNuevaCotizacion(Model model) {
        model.addAttribute("cotizacion", new Cotizacion());
        model.addAttribute("proveedores", proveedorService.listarProveedores());
        return "compras/cotizacion-form";
    }

    @PostMapping("/cotizaciones/guardar")
    public String guardarCotizacion(@ModelAttribute Cotizacion cotizacion) {
        cotizacionService.crearCotizacion(cotizacion);
        return "redirect:/compras";
    }

    @PostMapping("/cotizaciones/{id}/generar-orden")
    public String generarOrdenDesdeCotizacion(@PathVariable Integer id, RedirectAttributes redirect) {
        Cotizacion cot = cotizacionService.obtenerPorId(id);
        
        // Validación simple
        if (cot == null) {
            redirect.addFlashAttribute("error", "Cotización no encontrada.");
            return "redirect:/compras";
        }
        
        // Lógica de negocio en el servicio
        ordenCompraService.crearOrdenDesdeCotizacion(cot);
        
        redirect.addFlashAttribute("success", "Orden generada correctamente desde la cotización.");
        return "redirect:/compras";
    }

    // --- Facturas (AQUÍ ESTABAN LOS ERRORES) ---
    
    @GetMapping("/facturas/nueva")
    public String formNuevaFactura(Model model) {
        model.addAttribute("factura", new FacturaCompra());
        model.addAttribute("proveedores", proveedorService.listarProveedores()); // Enviar proveedores
        return "pedidos_compra/factura-compra-form"; // Verifica que este JSP exista con este nombre
    }

    @PostMapping("/facturas/guardar")
    public String guardarFactura(
            @ModelAttribute FacturaCompra factura,
            @RequestParam(value = "idProveedor", required = false) Integer idProveedor, // Capturar ID del proveedor
            RedirectAttributes redirect) {
        
        try {
            // 1. Asignar Proveedor si viene del formulario
            if (idProveedor != null) {
                Proveedor p = proveedorService.obtenerPorId(idProveedor);
                factura.setProveedor(p);
            }

            // 2. CORRECCIÓN: Usar el método 'guardar' (antes tenías 'registrarFactura')
            facturaCompraService.guardar(factura);
            
            redirect.addFlashAttribute("success", "Factura registrada correctamente.");
            
        } catch (Exception e) {
            redirect.addFlashAttribute("error", "Error al guardar factura: " + e.getMessage());
        }
        
        return "redirect:/compras";
    }
}