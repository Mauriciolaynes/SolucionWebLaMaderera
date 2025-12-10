package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import pe.idat.repository.ProductoRepository;

@Controller
@RequestMapping("/")
public class HomeController 
{
	public HomeController() {}
	@Autowired
    private ProductoRepository productoRepository;
	
	@GetMapping("/") // Responde a la ruta raíz (localhost:8090/)
    public String verPaginaPrincipal_GET(Model model) {
        
        // 1. Usamos el repositorio para ir a la Base de Datos y traer la lista
        // (JPA hace el SELECT * FROM producto por ti)
        model.addAttribute("listaProductos", productoRepository.findAll());
        
        // 2. Enviamos esa lista al JSP para que el <c:forEach> tenga qué mostrar
        return "PaginaPrincipal"; 
    }
}














