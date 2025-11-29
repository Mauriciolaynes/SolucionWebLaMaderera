package pe.idat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.idat.entity.PedidoCompra;

@Repository
public interface PedidoCompraRepository extends JpaRepository<PedidoCompra, Integer> {
    // Busca el último pedido por su ID en orden descendente para obtener el más reciente
    PedidoCompra findTopByOrderByIdPedidoCompraDesc();
}