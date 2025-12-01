package pe.idat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.idat.entity.FacturaCompra;
import pe.idat.repository.FacturaCompraRepository;
import java.time.LocalDate;
import java.util.List;

@Service
public class FacturaCompraService {

    @Autowired
    private FacturaCompraRepository facturaRepository;

    @Transactional(readOnly = true)
    public List<FacturaCompra> listarFacturas() {
        return facturaRepository.findAll();
    }

    @Transactional(readOnly = true)
    public FacturaCompra obtenerPorId(Integer id) {
        return facturaRepository.findById(id).orElse(null);
    }

    @Transactional
    public FacturaCompra guardar(FacturaCompra factura) {
        // Si es nueva
        if (factura.getIdFactura() == null) {
            // Fecha actual por defecto si viene nula
            if (factura.getFecha() == null) {
                factura.setFecha(LocalDate.now());
            }
            // Generar número si no existe
            if (factura.getNumeroFactura() == null || factura.getNumeroFactura().isEmpty()) {
                factura.setNumeroFactura(generarSiguienteNumero());
            }
        }
        return facturaRepository.save(factura);
    }

    @Transactional
    public void eliminar(Integer id) {
        facturaRepository.deleteById(id);
    }

    // Lógica de Autoincremento: FAC-2025-001
    public String generarSiguienteNumero() {
        int anioActual = LocalDate.now().getYear();
        
        // Busca la última factura registrada (Asegúrate de tener este método en el Repo)
        FacturaCompra ultima = facturaRepository.findTopByOrderByIdFacturaDesc();
        
        int siguiente = 1;
        
        if (ultima != null && ultima.getNumeroFactura() != null) {
            String codigo = ultima.getNumeroFactura(); // Ej: FAC-2025-005
            String[] partes = codigo.split("-");
            
            // Validamos formato y año
            if (partes.length == 3 && partes[1].equals(String.valueOf(anioActual))) {
                try {
                    siguiente = Integer.parseInt(partes[2]) + 1;
                } catch (NumberFormatException e) {
                    siguiente = 1;
                }
            }
        }
        
        // Formato: FAC-2025-001
        return String.format("FAC-%d-%03d", anioActual, siguiente);
    }
}