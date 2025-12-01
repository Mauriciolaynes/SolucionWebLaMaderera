package pe.idat.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.annotation.RequestParam;

import pe.idat.entity.OrdenCompra;
import pe.idat.entity.Proveedor;
import pe.idat.service.OrdenCompraService;
import pe.idat.service.ProveedorService;

@Controller
@RequestMapping("/ordenes-compra")
public class OrdenCompraController {

    @Autowired
    private OrdenCompraService ordenService;

    @Autowired
    private ProveedorService proveedorService;

    // 1. Mostrar formulario para NUEVA Orden
    @GetMapping("/nuevo")
    public String nuevaOrden(Model model) {
        OrdenCompra orden = new OrdenCompra();
        
        // Cargar proveedores para el <select>
        List<Proveedor> listaProveedores = proveedorService.listarProveedores();
        
        // "orden" debe coincidir con ${orden} en el JSP
        model.addAttribute("orden", orden);
        model.addAttribute("proveedores", listaProveedores);
        
        return "pedidos_compra/ordencompra-form"; // Nombre de tu archivo JSP
    }

    // 2. Mostrar formulario para EDITAR Orden existente
    @GetMapping("/editar/{id}")
    public String editarOrden(@PathVariable Integer id, Model model, RedirectAttributes redirect) {
        OrdenCompra orden = ordenService.obtenerPorId(id);

        if (orden == null) {
            redirect.addFlashAttribute("error", "La orden de compra no fue encontrada.");
            return "redirect:/compras";
        }

        List<Proveedor> listaProveedores = proveedorService.listarProveedores();

        model.addAttribute("orden", orden);
        model.addAttribute("proveedores", listaProveedores);

        return "pedidos_compra/ordencompra-form"; // Reutilizamos el mismo formulario de creación
    }

    // Método para VER el detalle de una orden
    @GetMapping("/ver/{id}")
    public String verOrden(@PathVariable Integer id, Model model, RedirectAttributes redirect) {
        OrdenCompra orden = ordenService.obtenerPorId(id);

        if (orden == null) {
            redirect.addFlashAttribute("error", "La orden de compra no fue encontrada.");
            return "redirect:/compras";
        }

        model.addAttribute("orden", orden);
        return "pedidos_compra/ver-orden"; // Necesitarás crear esta vista JSP
    }

    // PASO 1: Mostrar página de confirmación para ELIMINAR una orden
    @GetMapping("/eliminar/{id}")
    public String mostrarConfirmacionEliminar(@PathVariable Integer id, Model model, RedirectAttributes redirect) {
        OrdenCompra orden = ordenService.obtenerPorId(id);
        if (orden == null) {
            redirect.addFlashAttribute("error", "La orden de compra que intenta eliminar no existe.");
            return "redirect:/compras";
        }

        model.addAttribute("orden", orden);
        return "ordenes_compra/eliminar-resumen"; // Nueva vista de confirmación
    }

    // PASO 2: Procesar la eliminación después de la confirmación
    @PostMapping("/eliminar-confirmado")
    public String eliminarOrdenConfirmado(@RequestParam("idOrden") Integer id, RedirectAttributes redirect) {
        try {
            ordenService.eliminar(id);
            redirect.addFlashAttribute("success", "Orden de compra eliminada correctamente.");
        } catch (Exception e) {
            redirect.addFlashAttribute("error", "No se pudo eliminar la orden. Es posible que tenga facturas asociadas.");
            System.err.println("Error al eliminar orden: " + e.getMessage());
        }
        return "redirect:/compras";
    }

    // 3. Procesar el GUARDADO (Insertar o Actualizar)
    @PostMapping("/guardar")
    public String guardarOrden(@ModelAttribute OrdenCompra orden, RedirectAttributes redirect) {
        ordenService.guardar(orden); // Asumiendo que el servicio tiene un método 'guardar' que crea o actualiza
        redirect.addFlashAttribute("success", "Orden de compra guardada con éxito.");
        return "redirect:/compras";
    }
}