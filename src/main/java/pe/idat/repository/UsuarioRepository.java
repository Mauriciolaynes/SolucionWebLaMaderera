package pe.idat.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import pe.idat.entity.Usuario;


@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {

    // Buscar administrador por correo y contraseña
    Usuario findByCorreoAndContrasenaAndRol_Nombre(String correo, String contrasena, String rolNombre);

    // Buscar usuario por correo y contraseña (general)
    Usuario findByCorreoAndContrasena(String correo, String contrasena);

    // --- Métodos para validación de registro ---
    Usuario findByNumeroDocumento(String numeroDocumento);

    Usuario findByCorreo(String correo);

    // Buscar por nombre
    List<Usuario> findByNombresApellidosContainingIgnoreCase(String nombre);

    // Buscar solo por rol
    List<Usuario> findByRolIdRol(Integer idRol);

    // Buscar por nombre y rol
    List<Usuario> findByNombresApellidosContainingIgnoreCaseAndRolIdRol(String nombre, Integer idRol);
    
    long countByEstado(int estado);

}
