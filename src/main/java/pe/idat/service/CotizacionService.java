package pe.idat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import pe.idat.entity.Cotizacion;
import pe.idat.entity.CotizacionDetalle;
import pe.idat.entity.CotizacionEstado;
import pe.idat.repository.CotizacionRepository;

import java.time.LocalDate;
import java.util.List;

@Service
public class CotizacionService {
    @Autowired
    private CotizacionRepository cotizacionRepository;

    // ================== LISTAR ====================
    @Transactional(readOnly = true)
    public List<Cotizacion> listarCotizaciones() {
        return cotizacionRepository.findAll();
    }

    // ================== OBTENER POR ID ====================
    @Transactional(readOnly = true)
    public Cotizacion obtenerPorId(Integer id) {
        return cotizacionRepository.findById(id).orElse(null);
    }

    // ================== CREAR/ACTUALIZAR ====================
    @Transactional
    public Cotizacion crearCotizacion(Cotizacion cotizacion) {

        // Solo si es NUEVO registro:
        if (cotizacion.getIdCotizacion() == null) {
            // Fecha
            if (cotizacion.getFecha() == null)
                cotizacion.setFecha(LocalDate.now());

            // Estado inicial (ENUM)
            if (cotizacion.getEstado() == null)
                cotizacion.setEstado(CotizacionEstado.POR_EVALUAR);

            // Número correlativo
            cotizacion.setNumeroCotizacion(generarSiguienteNumero());
        }

        // Vincular detalles (Necesario para la persistencia de relaciones)
        if (cotizacion.getDetalles() != null) {
            for (CotizacionDetalle d : cotizacion.getDetalles()) {
                d.setCotizacion(cotizacion);
            }
        }

        return cotizacionRepository.save(cotizacion);
    }

    // ================== ELIMINAR ====================
    @Transactional
    public void eliminar(Integer id) {
        cotizacionRepository.deleteById(id);
    }
    
    // ================== BUSCAR POR PEDIDO ====================
    @Transactional(readOnly = true)
    public List<Cotizacion> buscarPorPedido(Integer idPedido) {
        return cotizacionRepository.findByPedido_IdPedidoCompra(idPedido);
    }

    // ================== CAMBIO DE ESTADO ====================
    @Transactional
    public boolean actualizarEstado(Integer idCotizacion, CotizacionEstado nuevoEstado) {

        Cotizacion c = cotizacionRepository.findById(idCotizacion).orElse(null);
        if (c == null) return false;

        CotizacionEstado actual = c.getEstado();

        switch (nuevoEstado) {
            case APROBADA:
            case RECHAZADA:
                // Solo se puede aprobar o rechazar si está por evaluar
                if (actual != CotizacionEstado.POR_EVALUAR) return false;
                break;

            case ANULADA:
                // No se puede anular si está aprobada (según tu lógica de negocio)
                if (actual == CotizacionEstado.APROBADA) return false;
                break;
            
            default:
                break;
        }

        c.setEstado(nuevoEstado);
        cotizacionRepository.save(c);
        return true;
    }

    // ================== GENERAR CORRELATIVO ====================
    private String generarSiguienteNumero() {
        Cotizacion ultimo = cotizacionRepository.findTopByOrderByIdCotizacionDesc();
        int siguiente = 1;

        if (ultimo != null && ultimo.getNumeroCotizacion() != null) {
            try {
                String numStr = ultimo.getNumeroCotizacion().replaceAll("\\D+", "");
                siguiente = Integer.parseInt(numStr) + 1;
            } catch (Exception e) {
                siguiente = 1;
            }
        }

        return "COT-" + String.format("%06d", siguiente);
    }
}