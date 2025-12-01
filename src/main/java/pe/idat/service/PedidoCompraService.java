package pe.idat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.idat.entity.PedidoCompra;
import pe.idat.entity.PedidoCompraDetalle; // 🌟 IMPORTACIÓN NECESARIA PARA LA ENTIDAD DE DETALLE
import pe.idat.repository.PedidoCompraRepository;
import pe.idat.repository.PedidoCompraDetalleRepository; // 🌟 NUEVO REPOSITORIO INYECTADO
import org.springframework.transaction.annotation.Propagation;
import java.util.List;
import java.time.LocalDate;

@Service
public class PedidoCompraService {

	@Autowired
    private PedidoCompraRepository pedidoCompraRepository;
    
    @Autowired // 🌟 INYECCIÓN DEL REPOSITORIO DE DETALLES
    private PedidoCompraDetalleRepository detalleRepository;
    
    
    // ================== NUEVO MÉTODO DE FILTRO (Existente) ====================
    @Transactional(readOnly = true)
    public List<PedidoCompra> listarPorProveedor(Integer idProveedor) {
        return pedidoCompraRepository.findByProveedor_IdProveedor(idProveedor);
    }
    
    public List<PedidoCompra> listarPedidosConDetalles() {
        return pedidoCompraRepository.findAllConDetalles();
    }

    
    // ================== 🌟 MÉTODO CORREGIDO: OBTENER DETALLES 🌟 ====================
    /**
     * Devuelve la lista de detalles de un pedido específico,
     * necesaria para cargar los productos en la cotización.
     */
    @Transactional(readOnly = true)
    public List<PedidoCompraDetalle> obtenerDetallesPorId(Integer idPedido) {
        // 🚨 La implementación de este método requiere un cuerpo {}
        return detalleRepository.findByPedidoCompra_IdPedidoCompra(idPedido);
    }
    
    // --- MÉTODO NUEVO PARA LISTAR ---
    @Transactional(readOnly = true) 
    public List<PedidoCompra> listarTodos() {
        return pedidoCompraRepository.findAll();
    }

    // --- MÉTODO NUEVO PARA EL DASHBOARD ---
    @Transactional(readOnly = true)
    public List<PedidoCompra> listarUltimos5Pedidos() {
        return pedidoCompraRepository.findTop5ByOrderByIdPedidoCompraDesc();
    }

    /**
     * Método unificado para guardar (crear o actualizar) un Pedido de Compra.
     * Si el ID del pedido es nulo, lo trata como una creación y le asigna un número de pedido.
     * Si el ID ya existe, simplemente actualiza los datos.
     */
    @Transactional
    public void guardar(PedidoCompra pedido) {
        // Si es un nuevo pedido, asignamos valores iniciales.
        if (pedido.getIdPedidoCompra() == null) {
            pedido.setNumeroPedido(generarSiguienteNumeroPedido());
            if (pedido.getEstado() == null || pedido.getEstado().isEmpty()) {
                pedido.setEstado("PENDIENTE");
            }
        }
        // El método save() de JpaRepository maneja la lógica de inserción o actualización.
        pedidoCompraRepository.save(pedido);
    }


    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public PedidoCompra crearPedido(PedidoCompra pedidoCompra) {
        // Si el ID es nulo, es un pedido nuevo. Asignamos fecha y número.
        if (pedidoCompra.getIdPedidoCompra() == null) {
            pedidoCompra.setEstado("Pendiente");
            pedidoCompra.setFechaPedido(LocalDate.now());
            pedidoCompra.setNumeroPedido(generarSiguienteNumeroPedido());
        }
        
        // --- [NUEVO BLOQUE CRÍTICO] VINCULACIÓN DE SEGURIDAD ---
        if (pedidoCompra.getDetalles() != null) {
            for (pe.idat.entity.PedidoCompraDetalle detalle : pedidoCompra.getDetalles()) {
                detalle.setPedidoCompra(pedidoCompra);  
            }
        }
        
        guardar(pedidoCompra); // Reutilizamos el método de guardado
        return pedidoCompra;
    }
    
    /**
     * MÉTODO NUEVO: Actualiza un pedido existente.
     * No genera nuevo número ni fecha.
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public PedidoCompra actualizarPedido(PedidoCompra pedidoCompra) {
        // La fecha y el número de pedido no se tocan.
        // El estado podría actualizarse si fuera necesario, pero lo mantenemos.

        // Es crucial volver a vincular los detalles al padre (pedidoCompra)
        // para que JPA maneje correctamente la relación.
        if (pedidoCompra.getDetalles() != null) {
            for (pe.idat.entity.PedidoCompraDetalle detalle : pedidoCompra.getDetalles()) {
                detalle.setPedidoCompra(pedidoCompra);
            }
        }

        guardar(pedidoCompra); // Reutilizamos el método de guardado
        return pedidoCompra;
    }

    private String generarSiguienteNumeroPedido() {
        PedidoCompra ultimoPedido = pedidoCompraRepository.findTopByOrderByIdPedidoCompraDesc();
        int siguienteNumero = 1;

        if (ultimoPedido != null && ultimoPedido.getNumeroPedido() != null) {
            try {
                String ultimoNumeroStr = ultimoPedido.getNumeroPedido().substring(3);
                siguienteNumero = Integer.parseInt(ultimoNumeroStr) + 1;
            } catch (NumberFormatException | StringIndexOutOfBoundsException e) {
                siguienteNumero = 1;
            }
        }
        return "PC-" + String.format("%04d", siguienteNumero);
    }

    // ================== OBTENER POR ID (NUEVO) ====================
    /**
     * Busca un pedido de compra por su ID.
     * Necesario para las acciones de "Ver" y "Editar".
     */
    @Transactional(readOnly = true)
    public PedidoCompra obtenerPorId(Integer id) {
        return pedidoCompraRepository.findById(id).orElse(null);
    }

    // ================== ELIMINAR (NUEVO) ====================
    @Transactional
    public void eliminar(Integer id) {
        pedidoCompraRepository.deleteById(id);
    }

    // ================== ELIMINAR DETALLE (NUEVO) ====================
    /**
     * Elimina un detalle de pedido específico por su ID.
     * Se usa en la edición de pedidos para el borrado con AJAX.
     */
    @Transactional
    public void eliminarDetallePorId(Integer idDetalle) {
        detalleRepository.deleteById(idDetalle);
    }
}