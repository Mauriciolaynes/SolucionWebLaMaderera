package pe.idat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LibroReclamacionesController {

    @GetMapping("/libro-reclamaciones")
    public String verPaginaLibroReclamaciones() {
        // Devuelve el nombre del archivo JSP que se encuentra en /WEB-INF/views/
        return "Libro_Reclamaciones";
    }
}