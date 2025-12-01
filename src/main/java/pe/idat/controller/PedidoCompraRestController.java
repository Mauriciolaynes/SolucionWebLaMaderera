package pe.idat.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


import pe.idat.entity.PedidoCompra;
import pe.idat.entity.PedidoCompraDetalle;
import pe.idat.service.PedidoCompraService;

@RestController // ¡Importante! Usa RestController
@RequestMapping("/api/v1/pedidos") // URL base para la API
public class PedidoCompraRestController {
	@Autowired
    private PedidoCompraService pedidoCompraService;

    /**
     * Endpoint que devuelve pedidos de compra en formato JSON
     * filtrados por el ID del proveedor.
     * URL: /api/v1/pedidos/proveedor/{idProveedor}
     */
    @GetMapping("/proveedor/{idProveedor}")
    public List<PedidoCompra> getPedidosByProveedor(@PathVariable Integer idProveedor) {
        // Llama al servicio para obtener la lista filtrada
        return pedidoCompraService.listarPorProveedor(idProveedor);
    }
    @GetMapping("/{idPedidoCompra}/detalles") // Mantenemos la URL
    public List<PedidoCompraDetalle> getDetallesByPedido(@PathVariable Integer idPedidoCompra) {
        // Necesitas implementar este método en PedidoCompraService
        // Nota: Asumo que idPedidoCompra es Integer
        return pedidoCompraService.obtenerDetallesPorId(idPedidoCompra);
    }
}