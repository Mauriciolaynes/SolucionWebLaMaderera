package pe.idat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.idat.entity.FacturaCompra;

public interface FacturaCompraRepository extends JpaRepository<FacturaCompra, Integer> {
    
    // Método necesario para obtener la última factura registrada
    // (Ordenada por ID descendente para tomar la más reciente)
    FacturaCompra findTopByOrderByIdFacturaDesc();
}