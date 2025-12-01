package pe.idat.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import pe.idat.entity.FacturaCompra;
import pe.idat.entity.Proveedor;
import pe.idat.service.FacturaCompraService;
import pe.idat.service.ProveedorService;

@Controller
@RequestMapping("/facturas-compra")
public class FacturaCompraController {

    @Autowired
    private FacturaCompraService facturaService;

    @Autowired
    private ProveedorService proveedorService;

    // 1. NUEVA FACTURA (Con autogeneración)
    @GetMapping("/nuevo")
    public String nuevaFactura(Model model) {
        FacturaCompra factura = new FacturaCompra();
        
        // Generar número automático
        String nuevoNumero = facturaService.generarSiguienteNumero();
        factura.setNumeroFactura(nuevoNumero);
        
        // Fecha por defecto
        factura.setFecha(LocalDate.now());
        
        List<Proveedor> listaProveedores = proveedorService.listarProveedores();
        
        model.addAttribute("factura", factura);
        model.addAttribute("proveedores", listaProveedores);
        
        return "pedidos_compra/factura-compra-form";
    }

    // 2. EDITAR FACTURA
    @GetMapping("/editar/{id}")
    public String editarFactura(@PathVariable Integer id, Model model, RedirectAttributes redirect) {
        FacturaCompra factura = facturaService.obtenerPorId(id);
        
        if (factura == null) {
            redirect.addFlashAttribute("error", "La factura no existe.");
            return "redirect:/compras"; // O tu ruta de listado
        }

        List<Proveedor> listaProveedores = proveedorService.listarProveedores();
        model.addAttribute("factura", factura);
        model.addAttribute("proveedores", listaProveedores);
        
        return "pedidos_compra/factura-compra-form";
    }

    // 3. GUARDAR FACTURA (Con asignación de proveedor)
    @PostMapping("/guardar")
    public String guardarFactura(
            @ModelAttribute("factura") FacturaCompra factura,
            @RequestParam("idProveedor") Integer idProveedor, // Recibimos el ID
            RedirectAttributes redirect) {
        
        try {
            // Buscamos el proveedor
            Proveedor proveedor = proveedorService.obtenerPorId(idProveedor);
            factura.setProveedor(proveedor);
            
            // Guardamos
            facturaService.guardar(factura);
            
            redirect.addFlashAttribute("success", "Factura guardada correctamente.");
        } catch (Exception e) {
            redirect.addFlashAttribute("error", "Error al guardar: " + e.getMessage());
        }
        
        return "redirect:/compras"; // O /facturas-compra/listado
    }
    
    // 4. ELIMINAR FACTURA
    @GetMapping("/eliminar/{id}")
    public String eliminarFactura(@PathVariable Integer id, RedirectAttributes redirect) {
        try {
            facturaService.eliminar(id);
            redirect.addFlashAttribute("success", "Factura eliminada.");
        } catch (Exception e) {
            redirect.addFlashAttribute("error", "Error al eliminar.");
        }
        return "redirect:/compras";
    }
}