package pe.idat.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.idat.entity.Usuario;
import pe.idat.repository.UsuarioRepository;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    /**
     * Devuelve una lista de todos los usuarios registrados.
     * Utilizado en el formulario de ventas para listar los posibles clientes.
     */
    @Transactional(readOnly = true)
    public List<Usuario> listarTodos() {
        return usuarioRepository.findAll();
    }

    // Aquí puedes agregar más métodos de negocio para la entidad Usuario en el futuro,
    // como buscar por ID, cambiar estado, etc.
}