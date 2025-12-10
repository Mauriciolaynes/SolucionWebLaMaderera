package pe.idat.repository;

// En la interfaz AlmacenProductoRepository.java

import org.springframework.data.jpa.repository.JpaRepository;
import pe.idat.entity.AlmacenProducto;
import pe.idat.entity.AlmacenProductoId;
import java.util.List;
import java.util.Optional;

public interface AlmacenProductoRepository extends JpaRepository<AlmacenProducto, AlmacenProductoId> {

    // Asegúrate de que este método exista y esté escrito exactamente así:
    List<AlmacenProducto> findByProductoCategoriaIdCategoria(Integer idCategoria);

    // MÉTODO FALTANTE: Busca el stock de un producto en un almacén específico.
    Optional<AlmacenProducto> findByAlmacen_IdAlmacenAndProducto_IdProducto(Integer idAlmacen, Integer idProducto);

    // Otros métodos que puedas tener, como el que se usa en AdminController:
    List<AlmacenProducto> findByStockActualLessThan(int umbral);
}
