package pe.idat.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import pe.idat.entity.OrdenCompra;
import pe.idat.entity.Proveedor;
import pe.idat.service.OrdenCompraService;
import pe.idat.service.ProveedorService;
import pe.idat.service.PedidoCompraService;
import pe.idat.service.CotizacionService;
import pe.idat.service.FacturaCompraService;

@Controller
@RequestMapping("/ordenes-compra")
public class OrdenCompraController {

    @Autowired
    private OrdenCompraService ordenService;

    @Autowired
    private ProveedorService proveedorService;

    // Servicios adicionales para mantener las tablas llenas
    @Autowired private PedidoCompraService pedidoService;
    @Autowired private CotizacionService cotizacionService;
    @Autowired private FacturaCompraService facturaService;


    // ==========================================
    // 1. LISTAR TODO
    // ==========================================
    @GetMapping("/listado")
    public String listarOrdenes(Model model) {
        model.addAttribute("ordenes", ordenService.listarOrdenes());
        
        // Cargar las otras tablas para que la vista no se quede vacía
        model.addAttribute("pedidos", pedidoService.listarTodos()); 
        model.addAttribute("cotizaciones", cotizacionService.listarCotizaciones());
        model.addAttribute("facturas", facturaService.listarFacturas());

        return "pedidos_compra/Listado-Compras";
    }


    // ==========================================
    // 2. NUEVA ORDEN (Con Autogeneración de Número)
    // ==========================================
    @GetMapping("/nuevo")
    public String nuevaOrden(Model model) {
        OrdenCompra orden = new OrdenCompra();
        
        // A. Generar número automático (OC-2025-XX)
        String nuevoNumero = ordenService.generarSiguienteNumeroOrden();
        orden.setNumeroOrden(nuevoNumero);
        
        // B. Establecer fecha actual por defecto
        orden.setFecha(LocalDate.now());
        
        // C. Cargar proveedores
        List<Proveedor> listaProveedores = proveedorService.listarProveedores();

        model.addAttribute("orden", orden);
        model.addAttribute("proveedores", listaProveedores);

        return "pedidos_compra/ordencompra-form";
    }


    // ==========================================
    // 3. EDITAR ORDEN
    // ==========================================
    @GetMapping("/editar/{id}")
    public String editarOrden(@PathVariable Integer id, Model model, RedirectAttributes redirect) {
        OrdenCompra orden = ordenService.obtenerPorId(id);

        if (orden == null) {
            redirect.addFlashAttribute("error", "La orden de compra no existe.");
            return "redirect:/ordenes-compra/listado";
        }

        List<Proveedor> listaProveedores = proveedorService.listarProveedores();

        model.addAttribute("orden", orden);
        model.addAttribute("proveedores", listaProveedores);

        return "pedidos_compra/ordencompra-form";
    }


    // ==========================================
    // 4. GUARDAR ORDEN (Con asignación de Proveedor)
    // ==========================================
    @PostMapping("/guardar")
    public String guardarOrden(
            @ModelAttribute("orden") OrdenCompra orden,
            @RequestParam("idProveedor") Integer idProveedor, // Captura el ID del select
            RedirectAttributes redirect) {
        
        try {
            // 1. Buscar el proveedor real en la BD
            Proveedor proveedorEncontrado = proveedorService.obtenerPorId(idProveedor);
            
            // 2. Asignarlo a la orden
            orden.setProveedor(proveedorEncontrado);

            // 3. Guardar
            ordenService.guardar(orden);
            
            redirect.addFlashAttribute("success", "Orden guardada correctamente.");
            
        } catch (Exception e) {
            redirect.addFlashAttribute("error", "Error al guardar: " + e.getMessage());
        }

        return "redirect:/ordenes-compra/listado";
    }


    // ==========================================
    // 5. ELIMINAR ORDEN
    // ==========================================
    @GetMapping("/eliminar/{id}")
    public String eliminarOrden(@PathVariable Integer id, RedirectAttributes redirect) {
        try {
            ordenService.eliminar(id);
            redirect.addFlashAttribute("success", "Orden eliminada correctamente.");
        } catch (Exception e) {
            redirect.addFlashAttribute("error", "No se pudo eliminar la orden.");
        }
        return "redirect:/ordenes-compra/listado";
    }
    
    // (Opcional) Método ver detalle si lo usas
    @GetMapping("/ver/{id}")
    public String verOrden(@PathVariable Integer id, Model model, RedirectAttributes redirect) {
        OrdenCompra orden = ordenService.obtenerPorId(id);
        if (orden == null) return "redirect:/ordenes-compra/listado";
        model.addAttribute("orden", orden);
        return "pedidos_compra/ver-orden";
    }
}