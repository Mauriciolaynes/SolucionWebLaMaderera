package pe.idat.repository;

import java.util.List; // Necesario para List
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query; // Necesario para @Query
import org.springframework.stereotype.Repository;

import pe.idat.entity.Producto;

@Repository
public interface ProductoRepository extends JpaRepository<Producto, Integer> {

    // Busca el último producto de una categoría específica, ordenado por ID descendente.
    // Esto es necesario para generar el código de producto consecutivo.
    Producto findTopByCategoriaIdCategoriaOrderByIdProductoDesc(Integer idCategoria);
    
    // --- NUEVA FUNCIÓN A AGREGAR ---
    
    /**
     * Recupera todos los Productos, forzando la carga inmediata (Eagerly) 
     * del objeto Proveedor asociado mediante un FETCH JOIN.
     * Esto resuelve la LazyInitializationException en el controlador.
     */
    @Query("SELECT p FROM Producto p JOIN FETCH p.proveedor")
    List<Producto> findAllWithProveedor();
}