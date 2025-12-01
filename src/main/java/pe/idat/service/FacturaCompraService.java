package pe.idat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.idat.entity.FacturaCompra;
import pe.idat.entity.OrdenCompra;
import pe.idat.repository.FacturaCompraRepository;
import pe.idat.repository.OrdenCompraRepository;
import java.time.LocalDate;
import java.util.List;

@Service
public class FacturaCompraService {

	@Autowired
    private FacturaCompraRepository facturaCompraRepository;

    @Autowired
    private OrdenCompraRepository ordenCompraRepository;

    @Transactional(readOnly = true)
    public List<FacturaCompra> listarFacturas() {
        return facturaCompraRepository.findAll();
    }

    @Transactional
    public FacturaCompra registrarFactura(FacturaCompra factura) {
        if (factura.getFecha() == null) factura.setFecha(LocalDate.now());
        if (factura.getEstadoPago() == null) factura.setEstadoPago("PENDIENTE");
        // Validar asociación a orden
        if (factura.getOrdenCompra() != null) {
            OrdenCompra oc = ordenCompraRepository.findById(factura.getOrdenCompra().getIdOrden()).orElse(null);
            if (oc == null) throw new IllegalStateException("Orden de compra no encontrada.");
        }
        // numero de factura: no correlativo global aquí; se espera que lo proveas o lo generes
        factura.setNumeroFactura(generarSiguienteNumero());
        return facturaCompraRepository.save(factura);
    }

    private String generarSiguienteNumero() {
        // Simple: usar timestamp o contenedor secuencial (se puede mejorar)
        long ts = System.currentTimeMillis() % 100000; // ejemplo sencillo
        return "F-" + String.format("%06d", ts);
    }
}
