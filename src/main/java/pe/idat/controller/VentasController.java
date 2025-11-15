package pe.idat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class VentasController {

	@GetMapping("/ventas/registrar")
    public String verRegistrarVentas() {
        return "RegistrarVentas"; // nombre del JSP que creamos
    }
}
