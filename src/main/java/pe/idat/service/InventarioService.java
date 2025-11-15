package pe.idat.service;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pe.idat.entity.AlmacenProducto;
import pe.idat.repository.AlmacenProductoRepository;

import java.util.List;

@Service
public class InventarioService {

	@Autowired
    private AlmacenProductoRepository almacenProductoRepository;

    // Listar todo el inventario
    public List<AlmacenProducto> listarTodos() {
        return almacenProductoRepository.findAll();
    }

    // Listar inventario por categoría
    public List<AlmacenProducto> listarPorCategoria(Integer idCategoria) {
        if (idCategoria != null) {
            return almacenProductoRepository.findByProducto_Categoria_IdCategoria(idCategoria);
        } else {
            return listarTodos();
        }
    }

    // Buscar un producto específico en un almacén
    public AlmacenProducto buscarPorId(Integer idAlmacen, Integer idProducto) {
        return almacenProductoRepository.findById(new pe.idat.entity.AlmacenProductoId(idAlmacen, idProducto))
                .orElse(null);
    }

    // Actualizar stock
    public void actualizarStock(AlmacenProducto almacenProducto) {
        AlmacenProducto existente = almacenProductoRepository.findById(almacenProducto.getId()).orElse(null);
        if (existente != null) {
            existente.setStockActual(almacenProducto.getStockActual());
            existente.setStockMinimo(almacenProducto.getStockMinimo());
            existente.setFechaActualizacion(java.time.LocalDateTime.now());
            almacenProductoRepository.save(existente);
        }
    }
}