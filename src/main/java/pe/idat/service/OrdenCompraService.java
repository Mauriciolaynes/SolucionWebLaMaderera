package pe.idat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.idat.entity.OrdenCompra;
import pe.idat.entity.OrdenCompraDetalle;
import pe.idat.entity.Cotizacion;
import pe.idat.entity.CotizacionEstado;
import pe.idat.repository.OrdenCompraRepository;
import pe.idat.repository.CotizacionRepository;
import java.time.LocalDate;
import java.util.List;

@Service
public class OrdenCompraService {
    @Autowired
    private OrdenCompraRepository ordenCompraRepository;

    @Autowired
    private CotizacionRepository cotizacionRepository;

    @Transactional(readOnly = true)
    public List<OrdenCompra> listarOrdenes() {
        return ordenCompraRepository.findAll();
    }

    @Transactional(readOnly = true)
    public OrdenCompra obtenerPorId(Integer id) {
        return ordenCompraRepository.findById(id).orElse(null);
    }

    @Transactional
    public OrdenCompra crearOrdenDesdeCotizacion(Cotizacion cotizacion) {
        // Validar que la cotización esté aprobada
        if (cotizacion == null || cotizacion.getEstado() != CotizacionEstado.APROBADA) {
            throw new IllegalStateException("La cotización debe estar APROBADA para generar la orden.");
        }

        OrdenCompra orden = new OrdenCompra();
        orden.setProveedor(cotizacion.getProveedor());
        orden.setFecha(LocalDate.now());
        
        // Asumiendo que el estado en OrdenCompra es String (según tu código anterior)
        orden.setEstado("GENERADA"); 
        
        orden.setCotizacionOrigen(cotizacion);
        orden.setNumeroOrden(generarSiguienteNumero());

        // Mapeo de detalles
        if (cotizacion.getDetalles() != null) {
            for (var det : cotizacion.getDetalles()) {
                OrdenCompraDetalle od = new OrdenCompraDetalle();
                od.setOrdenCompra(orden);
                od.setProducto(det.getProducto());
                od.setCantidad(det.getCantidad());
                od.setPrecioUnitario(det.getPrecioUnitario());
                orden.getDetalles().add(od);
            }
        }

        // Actualizar estado de la cotización
        cotizacion.setEstado(CotizacionEstado.ORDEN_GENERADA);
        cotizacionRepository.save(cotizacion);

        return ordenCompraRepository.save(orden);
    }

    /**
     * Guarda o actualiza una orden de compra.
     * Si la orden es nueva (sin ID), le asigna fecha, estado y número.
     * Si ya existe, simplemente guarda los cambios.
     */
    @Transactional
    public OrdenCompra guardar(OrdenCompra orden) {
        // Si es una orden nueva, asignamos valores por defecto.
        if (orden.getIdOrden() == null) {
            orden.setFecha(LocalDate.now());
            orden.setEstado("GENERADA"); // Estado inicial para órdenes creadas manualmente
            orden.setNumeroOrden(generarSiguienteNumero());
        }

        // Es buena práctica asegurar la relación bidireccional antes de guardar.
        if (orden.getDetalles() != null) {
            orden.getDetalles().forEach(detalle -> detalle.setOrdenCompra(orden));
        }

        return ordenCompraRepository.save(orden);
    }

    @Transactional
    public void eliminar(Integer id) {
        ordenCompraRepository.deleteById(id);
    }

    private String generarSiguienteNumero() {
        // CORREGIDO: Llamada al método actualizado del repositorio
        OrdenCompra ultimo = ordenCompraRepository.findTopByOrderByIdOrdenDesc();
        
        int siguiente = 1;
        if (ultimo != null && ultimo.getNumeroOrden() != null) {
            try {
                String numStr = ultimo.getNumeroOrden().replaceAll("\\D+", "");
                siguiente = Integer.parseInt(numStr) + 1;
            } catch (Exception e) {
                siguiente = 1;
            }
        }
        return "OC-" + String.format("%04d", siguiente);
    }
}