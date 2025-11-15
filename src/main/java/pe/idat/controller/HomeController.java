package pe.idat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class HomeController 
{
	public HomeController() {}
	
	@GetMapping("/") // Este método responderá a http://localhost:8090/laMaderera/
    public String verPaginaPrincipal_GET() {
        return "PaginaPrincipal"; // Devuelve el nombre del archivo JSP (sin la extensión)
    }
}














