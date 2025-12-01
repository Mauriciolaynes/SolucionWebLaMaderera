package pe.idat.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import pe.idat.entity.CotizacionDetalle;
import pe.idat.repository.CotizacionDetalleRepository;

import java.util.List;

@Service
public class CotizacionDetalleService {
	@Autowired
    private CotizacionDetalleRepository cotizacionDetalleRepository;

    @Transactional(readOnly = true)
    public List<CotizacionDetalle> listarPorCotizacion(Integer idCotizacion) {
        return cotizacionDetalleRepository.findByCotizacionIdCotizacion(idCotizacion);
    }

    @Transactional
    public CotizacionDetalle guardar(CotizacionDetalle detalle) {
        return cotizacionDetalleRepository.save(detalle);
    }

    @Transactional
    public void eliminar(Integer idDetalle) {
        cotizacionDetalleRepository.deleteById(idDetalle);
    }
}