package pe.idat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.idat.entity.MovimientoAlmacen;

import java.util.List;

@Repository
public interface MovimientoAlmacenRepository extends JpaRepository<MovimientoAlmacen, Integer> {

    /**
     * Buscar todos los movimientos de un producto específico
     * Útil para generar el Kardex
     */
    List<MovimientoAlmacen> findByIdProductoOrderByFechaDesc(Integer idProducto);

    /**
     * Buscar movimientos por tipo (1=ENTRADA, 2=SALIDA)
     */
    List<MovimientoAlmacen> findByIdTipoMovimientoOrderByFechaDesc(Integer idTipoMovimiento);

    /**
     * Buscar movimientos de un producto en un almacén específico
     */
    @Query("SELECT m FROM MovimientoAlmacen m WHERE m.idProducto = :idProducto AND m.idAlmacen = :idAlmacen ORDER BY m.fecha DESC")
    List<MovimientoAlmacen> findByProductoAndAlmacen(@Param("idProducto") Integer idProducto,
            @Param("idAlmacen") Integer idAlmacen);

    /**
     * Obtener los últimos N movimientos (para dashboard)
     */
    List<MovimientoAlmacen> findTop10ByOrderByFechaDesc();
}
