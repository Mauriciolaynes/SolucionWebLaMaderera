package pe.idat.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import pe.idat.entity.PedidoCompra;

@Repository
public interface PedidoCompraRepository extends JpaRepository<PedidoCompra, Integer> {

    // Método para obtener el último pedido (ya lo tenías para el correlativo)
    PedidoCompra findTopByOrderByIdPedidoCompraDesc();

    // --- MÉTODO FALTANTE ---
    // Añade esta línea para solucionar el error.
    List<PedidoCompra> findTop5ByOrderByIdPedidoCompraDesc();
    
    List<PedidoCompra> findByProveedor_IdProveedor(Integer idProveedor);
    
    @Query("SELECT p FROM PedidoCompra p " +
    	       "LEFT JOIN FETCH p.proveedor " +
    	       "LEFT JOIN FETCH p.detalles d " +
    	       "LEFT JOIN FETCH d.producto ")
    	List<PedidoCompra> findAllConDetalles();

    
}

