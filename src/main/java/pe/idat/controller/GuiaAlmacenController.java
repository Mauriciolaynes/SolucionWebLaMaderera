package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import pe.idat.entity.Venta;
import pe.idat.entity.PedidoCompra;
import pe.idat.entity.OrdenCompra;
import pe.idat.service.VentaService;
import pe.idat.service.PedidoCompraService;
import pe.idat.service.OrdenCompraService;

/**
 * Controlador para generar guías de entrada y salida de almacén
 */
@Controller
@RequestMapping("/guias")
public class GuiaAlmacenController {

    @Autowired
    private VentaService ventaService;

    @Autowired
    private PedidoCompraService pedidoCompraService;

    @Autowired
    private OrdenCompraService ordenCompraService;

    /**
     * Genera y muestra la guía de salida para una venta
     * Esta vista está optimizada para impresión
     * 
     * @param ventaId ID de la venta
     * @param model   Modelo para pasar datos a la vista
     * @return Vista de guía de salida
     */
    @GetMapping("/salida/{ventaId}")
    public String generarGuiaSalida(@PathVariable Long ventaId, Model model) {
        Venta venta = ventaService.obtenerVentaPorId(ventaId);

        if (venta == null) {
            return "redirect:/ventas/listar";
        }

        // Generar número de guía (formato: GS-00000X)
        String numeroGuia = String.format("GS-%06d", ventaId);

        model.addAttribute("venta", venta);
        model.addAttribute("numeroGuia", numeroGuia);
        model.addAttribute("tipoGuia", "SALIDA");

        return "guias/guia-salida";
    }

    /**
     * Genera guía de entrada basada en un Pedido de Compra
     * 
     * @param pedidoId ID del pedido de compra
     * @param model    Modelo para pasar datos
     * @return Vista de guía de entrada
     */
    @GetMapping("/entrada/pedido/{pedidoId}")
    public String generarGuiaEntradaPedido(@PathVariable Integer pedidoId, Model model) {
        PedidoCompra pedido = pedidoCompraService.obtenerPorId(pedidoId);

        if (pedido == null) {
            return "redirect:/compras";
        }

        String numeroGuia = String.format("GE-PED-%06d", pedidoId);

        model.addAttribute("pedido", pedido);
        model.addAttribute("numeroGuia", numeroGuia);
        model.addAttribute("tipoDocumento", "PEDIDO DE COMPRA");
        model.addAttribute("tipoGuia", "ENTRADA");

        return "guias/guia-entrada-pedido";
    }

    /**
     * Genera guía de entrada basada en una Orden de Compra
     * 
     * @param ordenId ID de la orden de compra
     * @param model   Modelo para pasar datos
     * @return Vista de guía de entrada
     */
    @GetMapping("/entrada/orden/{ordenId}")
    public String generarGuiaEntradaOrden(@PathVariable Integer ordenId, Model model) {
        OrdenCompra orden = ordenCompraService.obtenerPorId(ordenId);

        if (orden == null) {
            return "redirect:/compras";
        }

        String numeroGuia = String.format("GE-ORD-%06d", ordenId);

        model.addAttribute("orden", orden);
        model.addAttribute("numeroGuia", numeroGuia);
        model.addAttribute("tipoDocumento", "ORDEN DE COMPRA");
        model.addAttribute("tipoGuia", "ENTRADA");

        return "guias/guia-entrada-orden";
    }
}
