package pe.idat.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.idat.entity.CotizacionDetalle;

public interface CotizacionDetalleRepository extends JpaRepository<CotizacionDetalle, Integer> {
    List<CotizacionDetalle> findByCotizacionIdCotizacion(Integer idCotizacion);
}