package pe.idat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.idat.entity.FacturaCompra;

public interface FacturaCompraRepository extends JpaRepository<FacturaCompra, Integer> {
}
