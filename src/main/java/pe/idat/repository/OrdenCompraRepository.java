package pe.idat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.idat.entity.OrdenCompra;

@Repository
public interface OrdenCompraRepository extends JpaRepository<OrdenCompra, Integer> {

    // CORREGIDO: Ahora coincide con el campo "idOrden" de tu entidad
    OrdenCompra findTopByOrderByIdOrdenDesc();
}