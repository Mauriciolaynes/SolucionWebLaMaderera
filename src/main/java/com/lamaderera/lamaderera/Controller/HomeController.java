package com.lamaderera.lamaderera.Controller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller // Esta anotación es fundamental para que Spring lo reconozca
@RequestMapping("/") // This annotation maps HTTP requests to handler methods
public class HomeController {

    public HomeController () {}

    @GetMapping("/") // Este método responderá a http://localhost:8080/laMaderera/
    public String verPaginaPrincipal_GET() {
        return "PaginaPrincipal"; // Devuelve el nombre del archivo JSP (sin la extensión)
    }
}