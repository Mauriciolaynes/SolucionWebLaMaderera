package pe.idat.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import pe.idat.entity.Producto;
import pe.idat.repository.ProductoRepository;

@Service
public class ProductoService {

	 @Autowired
	    private ProductoRepository repo;

	    public List<Producto> listarProductos() {
	        return repo.findAll();
	    }
	    @Autowired
	    private ProductoRepository productoRepository;

	    @Transactional(readOnly = true)
	    public List<Producto> listar() {
	        return productoRepository.findAll();
	    }

	    @Transactional(readOnly = true)
	    public Producto obtenerPorId(Integer id) {
	        return productoRepository.findById(id).orElse(null);
	    }
	}