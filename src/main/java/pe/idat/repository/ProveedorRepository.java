package pe.idat.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.idat.entity.Proveedor;

@Repository
public interface ProveedorRepository extends JpaRepository<Proveedor, Integer>{
	boolean existsByRuc(String ruc);
    boolean existsByCorreo(String correo);
    
 // Estos son nuevos para poder validar duplicados al actualizar
    Proveedor findByRuc(String ruc);
    Proveedor findByCorreo(String correo);
}
