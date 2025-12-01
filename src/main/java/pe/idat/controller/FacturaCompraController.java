package pe.idat.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import pe.idat.entity.FacturaCompra;
import pe.idat.entity.Proveedor;
import pe.idat.service.FacturaCompraService;
import pe.idat.service.ProveedorService;

@Controller
@RequestMapping("/facturas-compra")
public class FacturaCompraController {

    //@Autowired
    //private FacturaCompraService facturaService;

    @Autowired
    private ProveedorService proveedorService;

    // 1. Método para mostrar el formulario de REGISTRO (Nuevo)
    @GetMapping("/nuevo")
    public String nuevaFactura(Model model) {
        FacturaCompra factura = new FacturaCompra();
        
        // Necesitamos la lista de proveedores para llenar el <select> del JSP
        List<Proveedor> listaProveedores = proveedorService.listarProveedores();
        
        model.addAttribute("factura", factura);
        model.addAttribute("proveedores", listaProveedores);
        
        return "pedidos_compra/factura-compra-form"; // Asegúrate de que tu JSP se llame así o cambia este nombre
    }

    // 3. Método para PROCESAR el formulario (Guardar/Actualizar)

}
