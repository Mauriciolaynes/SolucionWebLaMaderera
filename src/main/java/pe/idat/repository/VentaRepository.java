package pe.idat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.idat.entity.Venta;

@Repository
public interface VentaRepository extends JpaRepository<Venta, Long> {
    // Aquí puedes agregar métodos de consulta personalizados en el futuro
}