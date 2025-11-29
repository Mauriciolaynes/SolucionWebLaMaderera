package pe.idat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.idat.entity.PedidoCompra;
import java.util.List;
import pe.idat.repository.PedidoCompraRepository;
import org.springframework.transaction.annotation.Propagation;
import java.time.LocalDate;

@Service
public class PedidoCompraService {

    @Autowired
    private PedidoCompraRepository pedidoCompraRepository;

    // --- MÉTODO NUEVO PARA LISTAR ---
    @Transactional(readOnly = true) // Es una buena práctica para operaciones de solo lectura
    public List<PedidoCompra> listarTodos() {
        return pedidoCompraRepository.findAll();
    }

    // --- MÉTODO NUEVO PARA EL DASHBOARD ---
    @Transactional(readOnly = true)
    public List<PedidoCompra> listarUltimos5Pedidos() {
        return pedidoCompraRepository.findTop5ByOrderByIdPedidoCompraDesc();
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public PedidoCompra crearPedido(PedidoCompra pedidoCompra) {
        // Criterio de Aceptación: El pedido debe tener un estado inicial “Pendiente”.
        pedidoCompra.setEstado("Pendiente");

        // Asignar fecha actual
        pedidoCompra.setFechaPedido(LocalDate.now());

        // Generar número correlativo
        pedidoCompra.setNumeroPedido(generarSiguienteNumeroPedido());

        // --- [NUEVO BLOQUE CRÍTICO] VINCULACIÓN DE SEGURIDAD ---
        // Recorremos los detalles y les decimos explícitamente: "Este es tu padre"
        if (pedidoCompra.getDetalles() != null) {
            for (pe.idat.entity.PedidoCompraDetalle detalle : pedidoCompra.getDetalles()) {
                detalle.setPedidoCompra(pedidoCompra); 
            }
        }
        // GUARDADO
            PedidoCompra pedidoGuardado = pedidoCompraRepository.save(pedidoCompra);
            
            // *** TRUCO DE DEBUG: Forzar que se vea el ID generado ***
            System.out.println("DEBUG: Pedido guardado con ID: " + pedidoGuardado.getIdPedidoCompra());
            
            return pedidoGuardado;
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
