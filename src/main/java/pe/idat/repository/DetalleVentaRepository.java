package pe.idat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.idat.entity.DetalleVenta;
import java.util.List;

@Repository
public interface DetalleVentaRepository extends JpaRepository<DetalleVenta, Long> {
    // Ejemplo de método futuro: Buscar todos los detalles de una venta por el ID de la venta.
    List<DetalleVenta> findByVenta_Id(Long idVenta);
}