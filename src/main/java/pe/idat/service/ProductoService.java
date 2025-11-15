package pe.idat.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.idat.entity.Producto;
import pe.idat.repository.ProductoRepository;

@Service
public class ProductoService {

	 @Autowired
	    private ProductoRepository repo;

	    public List<Producto> listarProductos() {
	        return repo.findAll();
	    }
	}