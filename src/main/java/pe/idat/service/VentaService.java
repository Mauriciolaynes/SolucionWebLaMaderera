package pe.idat.service;

import pe.idat.entity.Venta;
import pe.idat.entity.DetalleVenta;
import pe.idat.entity.Producto;
import pe.idat.entity.Usuario;
import pe.idat.entity.AlmacenProducto;
import pe.idat.repository.VentaRepository;
import pe.idat.repository.UsuarioRepository;
import pe.idat.repository.ProductoRepository;
import pe.idat.repository.AlmacenProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.List;

@Service
public class VentaService {

    // Almacén principal (debe coincidir con InventarioService)
    private static final Integer ID_ALMACEN_PRINCIPAL = 1;

    @Autowired
    private VentaRepository ventaRepository;

    @Autowired
    private ProductoService productoService;

    // Si necesitas buscar el usuario por su ID antes de asignarlo a la venta
    // @Autowired
    // private UsuarioRepository usuarioRepository; // Necesitarías crear este
    // repositorio

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private AlmacenProductoRepository almacenProductoRepository;

    @Autowired
    private MovimientoAlmacenService movimientoService;

    @Transactional
    public Venta crearVenta(Venta venta) {
        // 1. Asignar la fecha actual
        venta.setFecha(LocalDateTime.now());

        // 2. Validar y cargar el usuario completo
        Usuario usuario = usuarioRepository.findById(venta.getUsuario().getIdUsuario())
                .orElseThrow(() -> new RuntimeException(
                        "Usuario no encontrado con ID: " + venta.getUsuario().getIdUsuario()));
        venta.setUsuario(usuario);

        BigDecimal totalVenta = BigDecimal.ZERO;

        // 3. Recorrer los detalles para validar, calcular total y actualizar stock
        for (DetalleVenta detalle : venta.getDetalles()) {
            // Asignar la venta al detalle
            detalle.setVenta(venta);

            // Cargar el producto completo para obtener su precio de venta real
            Producto producto = productoService.obtenerPorId(detalle.getProducto().getIdProducto());
            if (producto == null) {
                throw new RuntimeException("Producto no encontrado con ID: " + detalle.getProducto().getIdProducto());
            }
            detalle.setProducto(producto);

            // Usar el precio de venta de la base de datos para seguridad
            detalle.setPrecioUnitario(BigDecimal.valueOf(producto.getPrecioVenta()));

            // Calcular subtotal del detalle
            BigDecimal subtotal = detalle.getPrecioUnitario().multiply(new BigDecimal(detalle.getCantidad()));
            totalVenta = totalVenta.add(subtotal);

            // 4. Actualizar el stock del producto en el almacén
            // Asumimos que se descuenta del almacén principal (ID = 1). Esto se puede hacer
            // más dinámico.
            final Integer ID_ALMACEN_PRINCIPAL = 1;
            Optional<AlmacenProducto> inventarioOpt = almacenProductoRepository
                    .findByAlmacen_IdAlmacenAndProducto_IdProducto(ID_ALMACEN_PRINCIPAL, producto.getIdProducto());

            AlmacenProducto inventario = inventarioOpt
                    .orElseThrow(() -> new RuntimeException("No hay registro de inventario para el producto "
                            + producto.getNombre() + " en el almacén principal."));

            if (inventario.getStockActual() < detalle.getCantidad()) {
                throw new RuntimeException("Stock insuficiente para el producto: " + producto.getNombre());
            }

            inventario.setStockActual(inventario.getStockActual() - detalle.getCantidad());
            almacenProductoRepository.save(inventario);

            // 🆕 NUEVO: Registrar movimiento de SALIDA
            try {
                movimientoService.registrarSalida(
                        producto.getIdProducto(),
                        ID_ALMACEN_PRINCIPAL,
                        detalle.getCantidad(),
                        usuario.getIdUsuario(),
                        String.format("Venta a cliente: %s", usuario.getNombresApellidos()));
            } catch (Exception e) {
                // Log del error pero no fallar la venta
                System.err.println("Error al registrar movimiento de salida: " + e.getMessage());
            }
        }

        // 5. Asignar el total calculado a la venta
        venta.setTotal(totalVenta);

        // 6. Guardar la venta y sus detalles en la base de datos
        return ventaRepository.save(venta);
    }

    @Transactional(readOnly = true)
    public List<Venta> listarVentas() {
        return ventaRepository.findAll();
    }

    public Venta obtenerVentaPorId(Long id) {
        return ventaRepository.findById(id).orElse(null);
    }
}
