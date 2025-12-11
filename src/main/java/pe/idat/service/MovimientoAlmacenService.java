package pe.idat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.idat.entity.MovimientoAlmacen;
import pe.idat.repository.MovimientoAlmacenRepository;

import java.util.List;

@Service
public class MovimientoAlmacenService {

    // Constantes para tipos de movimiento
    public static final Integer TIPO_ENTRADA = 1;
    public static final Integer TIPO_SALIDA = 2;

    @Autowired
    private MovimientoAlmacenRepository movimientoRepository;

    /**
     * Registra un movimiento de ENTRADA al inventario
     * Usado en: Compras, Devoluciones de clientes, Ajustes positivos
     */
    @Transactional
    public MovimientoAlmacen registrarEntrada(Integer idProducto, Integer idAlmacen,
            Integer cantidad, Integer idUsuario,
            String observacion) {
        MovimientoAlmacen movimiento = new MovimientoAlmacen();
        movimiento.setIdTipoMovimiento(TIPO_ENTRADA);
        movimiento.setIdProducto(idProducto);
        movimiento.setIdAlmacen(idAlmacen);
        movimiento.setCantidad(cantidad);
        movimiento.setIdUsuario(idUsuario);
        movimiento.setObservacion(observacion);

        return movimientoRepository.save(movimiento);
    }

    /**
     * Registra un movimiento de SALIDA del inventario
     * Usado en: Ventas, Devoluciones a proveedores, Ajustes negativos
     */
    @Transactional
    public MovimientoAlmacen registrarSalida(Integer idProducto, Integer idAlmacen,
            Integer cantidad, Integer idUsuario,
            String observacion) {
        MovimientoAlmacen movimiento = new MovimientoAlmacen();
        movimiento.setIdTipoMovimiento(TIPO_SALIDA);
        movimiento.setIdProducto(idProducto);
        movimiento.setIdAlmacen(idAlmacen);
        movimiento.setCantidad(cantidad);
        movimiento.setIdUsuario(idUsuario);
        movimiento.setObservacion(observacion);

        return movimientoRepository.save(movimiento);
    }

    /**
     * Obtiene el historial (Kardex) de un producto
     */
    @Transactional(readOnly = true)
    public List<MovimientoAlmacen> obtenerKardexProducto(Integer idProducto) {
        return movimientoRepository.findByIdProductoOrderByFechaDesc(idProducto);
    }

    /**
     * Obtiene los últimos movimientos para dashboard
     */
    @Transactional(readOnly = true)
    public List<MovimientoAlmacen> obtenerUltimosMovimientos() {
        return movimientoRepository.findTop10ByOrderByFechaDesc();
    }

    /**
     * Obtiene movimientos por tipo
     */
    @Transactional(readOnly = true)
    public List<MovimientoAlmacen> obtenerPorTipo(Integer tipoMovimiento) {
        return movimientoRepository.findByIdTipoMovimientoOrderByFechaDesc(tipoMovimiento);
    }
}
