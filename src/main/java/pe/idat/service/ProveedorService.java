package pe.idat.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import pe.idat.entity.Proveedor;
import pe.idat.repository.ProveedorRepository;

import java.util.List;

@Service
public class ProveedorService {
	
	 @Autowired
	    private ProveedorRepository proveedorRepository;

	    @Transactional(readOnly = true)
	    public List<Proveedor> listarProveedores() {
	        return proveedorRepository.findAll();
	    }

	    @Transactional(readOnly = true)
	    public Proveedor obtenerPorId(Integer id) {
	        return proveedorRepository.findById(id).orElse(null);
	    }
	}
