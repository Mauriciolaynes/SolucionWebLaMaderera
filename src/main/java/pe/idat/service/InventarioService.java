package pe.idat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.idat.dto.EntradaMercanciaDTO;
import pe.idat.dto.ProductoEntradaDTO;
import pe.idat.entity.Almacen;
import pe.idat.entity.AlmacenProducto;
import pe.idat.entity.AlmacenProductoId;
import pe.idat.entity.Producto;
import pe.idat.repository.AlmacenProductoRepository;
import pe.idat.repository.ProductoRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class InventarioService {

    // Almacén principal por defecto (puede ser configurable)
    private static final Integer ID_ALMACEN_PRINCIPAL = 1;

    @Autowired
    private AlmacenProductoRepository almacenProductoRepository;

    @Autowired
    private ProductoRepository productoRepository;

    @Autowired
    private MovimientoAlmacenService movimientoService;

    // ==================== MÉTODOS EXISTENTES ====================

    /**
     * Listar todo el inventario
     */
    @Transactional(readOnly = true)
    public List<AlmacenProducto> listarTodos() {
        return almacenProductoRepository.findAll();
    }

    /**
     * Listar inventario por categoría
     */
    @Transactional(readOnly = true)
    public List<AlmacenProducto> listarPorCategoria(Integer idCategoria) {
        if (idCategoria != null) {
            return almacenProductoRepository.findByProductoCategoriaIdCategoria(idCategoria);
        } else {
            return listarTodos();
        }
    }

    /**
     * Buscar un producto específico en un almacén
     */
    @Transactional(readOnly = true)
    public AlmacenProducto buscarPorId(Integer idAlmacen, Integer idProducto) {
        return almacenProductoRepository.findById(new AlmacenProductoId(idAlmacen, idProducto))
                .orElse(null);
    }

    /**
     * Actualizar stock manualmente
     */
    @Transactional
    public void actualizarStock(AlmacenProducto almacenProducto) {
        AlmacenProducto existente = almacenProductoRepository.findById(almacenProducto.getId()).orElse(null);
        if (existente != null) {
            existente.setStockActual(almacenProducto.getStockActual());
            existente.setStockMinimo(almacenProducto.getStockMinimo());
            existente.setFechaActualizacion(LocalDateTime.now());
            almacenProductoRepository.save(existente);
        }
    }

    // ==================== NUEVOS MÉTODOS - GESTIÓN DE ENTRADAS
    // ====================

    /**
     * Procesa una entrada de mercancía (compra)
     * - Aumenta el stock de cada producto
     * - Registra movimientos de ENTRADA
     * - Crea el registro en almacen_producto si no existe
     * 
     * @param entradaDTO Datos de la entrada de mercancía
     * @param idUsuario  ID del usuario que registra la entrada
     * @return Mensaje de resultado
     */
    @Transactional
    public String procesarEntradaMercancia(EntradaMercanciaDTO entradaDTO, Integer idUsuario) {

        // Usar el almacén especificado o el principal por defecto
        Integer idAlmacen = (entradaDTO.getIdAlmacen() != null)
                ? entradaDTO.getIdAlmacen()
                : ID_ALMACEN_PRINCIPAL;

        int productosActualizados = 0;
        StringBuilder resultado = new StringBuilder();

        // Procesar cada producto en la entrada
        for (ProductoEntradaDTO productoDTO : entradaDTO.getProductos()) {
            try {
                // Validar que el producto existe
                Producto producto = productoRepository.findById(productoDTO.getIdProducto())
                        .orElseThrow(() -> new RuntimeException(
                                "Producto con ID " + productoDTO.getIdProducto() + " no encontrado"));

                // Aumentar stock
                aumentarStock(idAlmacen, productoDTO.getIdProducto(), productoDTO.getCantidad());

                // Registrar movimiento de ENTRADA
                String observacion = String.format("Entrada por compra - Factura: %s",
                        entradaDTO.getNumeroFactura() != null ? entradaDTO.getNumeroFactura() : "N/A");

                if (entradaDTO.getObservaciones() != null && !entradaDTO.getObservaciones().isEmpty()) {
                    observacion += " - " + entradaDTO.getObservaciones();
                }

                movimientoService.registrarEntrada(
                        productoDTO.getIdProducto(),
                        idAlmacen,
                        productoDTO.getCantidad(),
                        idUsuario,
                        observacion);

                productosActualizados++;
                resultado.append(String.format("✓ %s: +%d unidades\n",
                        producto.getNombre(), productoDTO.getCantidad()));

            } catch (Exception e) {
                resultado.append(String.format("✗ Error en producto ID %d: %s\n",
                        productoDTO.getIdProducto(), e.getMessage()));
            }
        }

        resultado.insert(0, String.format("Entrada procesada: %d/%d productos actualizados\n\n",
                productosActualizados, entradaDTO.getProductos().size()));

        return resultado.toString();
    }

    /**
     * Aumenta el stock de un producto en un almacén
     * Si no existe el registro, lo crea
     */
    @Transactional
    public void aumentarStock(Integer idAlmacen, Integer idProducto, Integer cantidad) {
        AlmacenProductoId id = new AlmacenProductoId(idAlmacen, idProducto);
        Optional<AlmacenProducto> optAlmacenProducto = almacenProductoRepository.findById(id);

        AlmacenProducto almacenProducto;

        if (optAlmacenProducto.isPresent()) {
            // Ya existe, solo aumentar stock
            almacenProducto = optAlmacenProducto.get();
            almacenProducto.setStockActual(almacenProducto.getStockActual() + cantidad);
        } else {
            // No existe, crear nuevo registro
            almacenProducto = new AlmacenProducto();
            almacenProducto.setId(id);

            // Cargar las entidades relacionadas
            Almacen almacen = new Almacen();
            almacen.setIdAlmacen(idAlmacen);
            almacenProducto.setAlmacen(almacen);

            Producto producto = productoRepository.findById(idProducto)
                    .orElseThrow(() -> new RuntimeException("Producto no encontrado con ID: " + idProducto));
            almacenProducto.setProducto(producto);

            almacenProducto.setStockActual(cantidad);
            almacenProducto.setStockMinimo(0); // Valor por defecto
        }

        almacenProducto.setFechaActualizacion(LocalDateTime.now());
        almacenProductoRepository.save(almacenProducto);
    }

    /**
     * Disminuye el stock de un producto en un almacén
     * Lanza excepción si no hay stock suficiente
     */
    @Transactional
    public void disminuirStock(Integer idAlmacen, Integer idProducto, Integer cantidad) {
        AlmacenProductoId id = new AlmacenProductoId(idAlmacen, idProducto);
        AlmacenProducto almacenProducto = almacenProductoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException(
                        "No existe registro de inventario para el producto ID " + idProducto +
                                " en el almacén ID " + idAlmacen));

        if (almacenProducto.getStockActual() < cantidad) {
            throw new RuntimeException(
                    String.format("Stock insuficiente. Disponible: %d, Solicitado: %d",
                            almacenProducto.getStockActual(), cantidad));
        }

        almacenProducto.setStockActual(almacenProducto.getStockActual() - cantidad);
        almacenProducto.setFechaActualizacion(LocalDateTime.now());
        almacenProductoRepository.save(almacenProducto);
    }

    /**
     * Obtiene productos con stock bajo (menor o igual al stock mínimo)
     */
    @Transactional(readOnly = true)
    public List<AlmacenProducto> obtenerProductosStockBajo() {
        return almacenProductoRepository.findAll().stream()
                .filter(ap -> ap.getStockActual() <= ap.getStockMinimo())
                .toList();
    }

    /**
     * Verifica si un producto tiene stock suficiente en un almacén
     */
    @Transactional(readOnly = true)
    public boolean tieneStockSuficiente(Integer idAlmacen, Integer idProducto, Integer cantidadRequerida) {
        Optional<AlmacenProducto> opt = almacenProductoRepository.findByAlmacen_IdAlmacenAndProducto_IdProducto(
                idAlmacen, idProducto);

        return opt.map(ap -> ap.getStockActual() >= cantidadRequerida).orElse(false);
    }
}
