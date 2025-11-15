package pe.idat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.idat.entity.AlmacenProducto;
import pe.idat.entity.AlmacenProductoId;
import java.util.Optional;
import java.util.List;

public interface AlmacenProductoRepository extends JpaRepository<AlmacenProducto, AlmacenProductoId> {
	List<AlmacenProducto> findById_IdAlmacen(Integer idAlmacen); // mejor que findByIdIdAlmacen
    List<AlmacenProducto> findByProducto_Categoria_IdCategoria(Integer idCategoria);
    Optional<AlmacenProducto> findById_IdProducto(Integer idProducto);


}
