package pe.idat.repository;

// En la interfaz AlmacenProductoRepository.java

import org.springframework.data.jpa.repository.JpaRepository;
import pe.idat.entity.AlmacenProducto;
import pe.idat.entity.AlmacenProductoId;
import java.util.List;

public interface AlmacenProductoRepository extends JpaRepository<AlmacenProducto, AlmacenProductoId> {

    // Asegúrate de que este método exista y esté escrito exactamente así:
    List<AlmacenProducto> findByProductoCategoriaIdCategoria(Integer idCategoria);

    // Otros métodos que puedas tener, como el que se usa en AdminController:
    List<AlmacenProducto> findByStockActualLessThan(int umbral);
}

