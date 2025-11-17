package pe.idat.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import pe.idat.entity.Categoria;
import pe.idat.entity.Producto;

@Repository
public interface ProductoRepository extends JpaRepository<Producto, Integer> {
    boolean existsByCodigo(String codigo);
    Producto findByCodigo(String codigo);
    long countByCategoria(Categoria categoria);
    List<Producto> findByCategoria_IdCategoria(Integer idCategoria);
    
    @Query("SELECT p FROM Producto p WHERE p.categoria.idCategoria = :idCategoria ORDER BY p.id_producto DESC")
    Producto findTopByCategoriaIdCategoriaOrderByIdDesc(@Param("idCategoria") Integer idCategoria);


}