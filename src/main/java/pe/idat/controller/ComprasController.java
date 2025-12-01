package pe.idat.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import pe.idat.entity.*;
import pe.idat.service.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

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

    // Vista principal
    @GetMapping
    public String vistaCompras(Model model) {
        model.addAttribute("pedidos", pedidoCompraService.listarTodos()); // o listarPedidos() si lo agregaste
        model.addAttribute("cotizaciones", cotizacionService.listarCotizaciones());
        model.addAttribute("ordenes", ordenCompraService.listarOrdenes());
        model.addAttribute("facturas", facturaCompraService.listarFacturas());
        return "pedidos_compra/Listado-Compras";
    }

    // --- Cotizaciones ---
    @GetMapping("/cotizaciones/nueva")
    public String formNuevaCotizacion(Model model) {
        model.addAttribute("cotizacion", new Cotizacion());
        return "compras/cotizacion-form"; // crea formulario JSP
    }

    @PostMapping("/cotizaciones/guardar")
    public String guardarCotizacion(@ModelAttribute Cotizacion cotizacion) {
        // Vincula detalles si vienen desde el formulario (asegúrate de form fields)
        cotizacionService.crearCotizacion(cotizacion);
        return "redirect:/compras";
    }

    // --- Generar orden desde cotización ---
    @PostMapping("/cotizaciones/{id}/generar-orden")
    public String generarOrdenDesdeCotizacion(@PathVariable Integer id, RedirectAttributes redirect) {
        Cotizacion cot = cotizacionService.obtenerPorId(id);
        if (cot == null || cot.getEstado() != CotizacionEstado.APROBADA) {
            redirect.addFlashAttribute("error", "Solo se puede generar una orden desde una cotización APROBADA.");
            return "redirect:/compras";
        }

        ordenCompraService.crearOrdenDesdeCotizacion(cot);

        // Actualizar el estado de la cotización a ORDEN_GENERADA
        // Y también el estado de sus detalles
        cot.getDetalles().forEach(det -> det.setEstadoDetalle(CotizacionEstado.ORDEN_GENERADA));

        // Actualizar el estado de la cotización
        cot.setEstado(CotizacionEstado.ORDEN_GENERADA);
        cotizacionService.crearCotizacion(cot);
        redirect.addFlashAttribute("success", "Orden de compra generada exitosamente. La cotización #" + id + " ha sido actualizada.");
        return "redirect:/compras";
    }

    // --- Registrar factura ---
    @GetMapping("/facturas/nueva")
    public String formNuevaFactura(Model model) {
        model.addAttribute("factura", new FacturaCompra());
        return "compras/factura-form";
    }

    @PostMapping("/facturas/guardar")
    public String guardarFactura(@ModelAttribute FacturaCompra factura) {
        facturaCompraService.registrarFactura(factura);
        return "redirect:/compras";
    }

}
