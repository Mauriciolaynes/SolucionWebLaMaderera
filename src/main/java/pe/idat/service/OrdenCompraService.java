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
import java.util.ArrayList;
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
        
        // Estado inicial
        orden.setEstado("GENERADA"); 
        
        orden.setCotizacionOrigen(cotizacion);
        // Generamos el número automáticamente
        orden.setNumeroOrden(generarSiguienteNumeroOrden());

        orden.setDetalles(new ArrayList<>());
        
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
     */
    @Transactional
    public OrdenCompra guardar(OrdenCompra orden) {
        // Si es una orden nueva (ID nulo)
        if (orden.getIdOrden() == null) {
            
            if (orden.getFecha() == null) {
                orden.setFecha(LocalDate.now());
            }
            if (orden.getEstado() == null) {
                orden.setEstado("GENERADA");
            }
            
            // Si no viene con número (por si acaso), lo generamos
            if (orden.getNumeroOrden() == null || orden.getNumeroOrden().isEmpty()) {
                orden.setNumeroOrden(generarSiguienteNumeroOrden());
            }
        }

        // Asegurar relación bidireccional
        if (orden.getDetalles() != null) {
            orden.getDetalles().forEach(detalle -> detalle.setOrdenCompra(orden));
        }

        return ordenCompraRepository.save(orden);
    }

    @Transactional
    public void eliminar(Integer id) {
        ordenCompraRepository.deleteById(id);
    }

    /**
     * Genera el correlativo con formato OC-YYYY-XX
     * Ejemplo: OC-2025-01, OC-2025-02...
     * Es PUBLIC para poder llamarlo desde el Controlador al abrir el formulario.
     */
    public String generarSiguienteNumeroOrden() {
        // 1. Obtener año actual
        int anioActual = LocalDate.now().getYear();
        
        // 2. Buscar la última orden registrada
        OrdenCompra ultimaOrden = ordenCompraRepository.findTopByOrderByIdOrdenDesc();
        
        int siguienteNumero = 1;
        
        if (ultimaOrden != null && ultimaOrden.getNumeroOrden() != null) {
            String ultimoCodigo = ultimaOrden.getNumeroOrden();
            // Esperamos formato: OC-2025-01 (separado por guiones)
            String[] partes = ultimoCodigo.split("-");
            
            // Validamos que tenga 3 partes y que el año coincida
            if (partes.length == 3 && partes[1].equals(String.valueOf(anioActual))) {
                try {
                    int correlativoActual = Integer.parseInt(partes[2]);
                    siguienteNumero = correlativoActual + 1;
                } catch (NumberFormatException e) {
                    siguienteNumero = 1;
                }
            }
        }
        
        // 3. Formatear: OC-2025-05 (con ceros a la izquierda si es necesario)
        return String.format("OC-%d-%02d", anioActual, siguienteNumero);
    }
}