package pe.idat.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.idat.entity.Cotizacion;

public interface CotizacionRepository extends JpaRepository<Cotizacion, Integer> {
	Cotizacion findTopByOrderByIdCotizacionDesc();
	
	List<Cotizacion> findByPedido_IdPedidoCompra(Integer idPedidoCompra);
}
