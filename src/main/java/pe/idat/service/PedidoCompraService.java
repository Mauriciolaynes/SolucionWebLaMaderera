package pe.idat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.idat.entity.PedidoCompra;
import pe.idat.repository.PedidoCompraRepository;

import java.time.LocalDate;

@Service
public class PedidoCompraService {

    @Autowired
    private PedidoCompraRepository pedidoCompraRepository;

    @Transactional
    public PedidoCompra crearPedido(PedidoCompra pedidoCompra) {
        // Criterio de Aceptación: El pedido debe tener un estado inicial “Pendiente”.
        pedidoCompra.setEstado("Pendiente");

        // ¡CORRECCIÓN! Se usa el método correcto 'setFechaPedido'.
        pedidoCompra.setFechaPedido(LocalDate.now());

        // Criterio de Aceptación: El pedido debe generar un número único y consecutivo.
        pedidoCompra.setNumeroPedido(generarSiguienteNumeroPedido());

        return pedidoCompraRepository.save(pedidoCompra);
    }

    private String generarSiguienteNumeroPedido() {
        // 1. Obtener el último pedido de la base de datos
        PedidoCompra ultimoPedido = pedidoCompraRepository.findTopByOrderByIdPedidoCompraDesc();
        int siguienteNumero = 1;

        if (ultimoPedido != null && ultimoPedido.getNumeroPedido() != null) {
            // 2. Extraer el número del string "PC-000X" y sumarle 1
            try {
                String ultimoNumeroStr = ultimoPedido.getNumeroPedido().substring(3); // "0001"
                siguienteNumero = Integer.parseInt(ultimoNumeroStr) + 1;
            } catch (NumberFormatException | StringIndexOutOfBoundsException e) {
                // Si el formato del número de pedido es inesperado, reiniciamos el contador.
                siguienteNumero = 1;
            }
        }

        // 3. Formatear el nuevo número a 4 dígitos (ej. 2 -> "0002")
        return "PC-" + String.format("%04d", siguienteNumero);
    }
}
