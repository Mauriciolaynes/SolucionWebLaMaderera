package pe.idat.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.idat.entity.PedidoCompraDetalle;

@Repository
public interface PedidoCompraDetalleRepository extends JpaRepository<PedidoCompraDetalle, Integer> {

    // --- MÉTODO FALTANTE ---
    // Busca todos los detalles que pertenecen a un PedidoCompra específico por su ID.
    List<PedidoCompraDetalle> findByPedidoCompra_IdPedidoCompra(Integer idPedidoCompra);
}