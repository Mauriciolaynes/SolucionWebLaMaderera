package pe.idat.controller.compras;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import pe.idat.entity.Producto;
import pe.idat.repository.ProductoRepository;
import pe.idat.repository.CategoriaRepository;
import pe.idat.repository.ProveedorRepository;

@Controller
@RequestMapping("/productos")
public class ProductoController {

	@Autowired
    private ProductoRepository productoRepo;

    @Autowired
    private CategoriaRepository categoriaRepo;

    @Autowired
    private ProveedorRepository proveedorRepo;

    // ======================================================
    // LISTAR
    // ======================================================
    @GetMapping("/listar")
    public String listarProductos(Model model) {
        model.addAttribute("productos", productoRepo.findAll());
        return "producto/producto-listar";
    }

    // ======================================================
    // NUEVO
    // ======================================================
    @GetMapping("/nuevo")
    public String nuevoProducto(Model model) {
        model.addAttribute("producto", new Producto());
        model.addAttribute("categorias", categoriaRepo.findAll());
        model.addAttribute("proveedores", proveedorRepo.findAll());
        return "producto/producto-form";
    }

    // ======================================================
    // GUARDAR
    // ======================================================
    @PostMapping("/guardar")
    public String guardarProducto(@Valid @ModelAttribute("producto") Producto producto,
                                  BindingResult result,
                                  Model model) {

        if (result.hasErrors()) {
            model.addAttribute("categorias", categoriaRepo.findAll());
            model.addAttribute("proveedores", proveedorRepo.findAll());
            return "producto/producto-form"; // ¡CORRECCIÓN! El nombre correcto de la vista.
        }

        // Cargar la categoría completa desde DB
        if (producto.getCategoria() != null && producto.getCategoria().getIdCategoria() != null) {
            var categoriaReal = categoriaRepo.findById(producto.getCategoria().getIdCategoria())
                                             .orElseThrow(() -> new IllegalArgumentException("Categoría no encontrada"));
            producto.setCategoria(categoriaReal);
        }
        
        // --- ¡ESTA ES LA CORRECCIÓN CLAVE! ---
        // Cargar el proveedor completo desde la DB y asignarlo al producto.
        if (producto.getProveedor() != null && producto.getProveedor().getIdProveedor() != null) {
            var proveedorReal = proveedorRepo.findById(producto.getProveedor().getIdProveedor())
                                             .orElseThrow(() -> new IllegalArgumentException("Proveedor no encontrado"));
            producto.setProveedor(proveedorReal);
        }

        // Si el producto es nuevo
        if (producto.getIdProducto() == null) {
            asignarCodigo(producto);
        } else {
            Producto productoExistente = productoRepo.findById(producto.getIdProducto()).orElse(null);
            if (productoExistente != null) {
                if (!productoExistente.getCategoria().getIdCategoria()
                        .equals(producto.getCategoria().getIdCategoria())) {
                    // La categoría cambió → regenerar código
                    asignarCodigo(producto);
                } else {
                    // Mantener el mismo código
                    producto.setCodigo(productoExistente.getCodigo());
                }
            }
        }

        productoRepo.save(producto);
        return "redirect:/productos/listar";
    }
    
    private void asignarCodigo(Producto producto) {
        if (producto.getCategoria() == null || producto.getCategoria().getNombre() == null) {
            return; // No se puede generar código si no hay categoría
        }

        // Generar prefijo según los primeros 2 caracteres de cada palabra de la categoría
        String[] palabras = producto.getCategoria().getNombre().split(" ");
        String prefijo;
        if (palabras.length >= 2) {
            prefijo = palabras[0].substring(0, 2).toUpperCase() + "-" +
                      palabras[1].substring(0, 2).toUpperCase();
        } else {
            prefijo = palabras[0].substring(0, Math.min(4, palabras[0].length())).toUpperCase();
        }

        // Buscar el último producto creado en esa categoría
        Producto ultimoProducto = productoRepo.findTopByCategoriaIdCategoriaOrderByIdProductoDesc(
                producto.getCategoria().getIdCategoria());

        int siguienteNumero = 1;
        if (ultimoProducto != null && ultimoProducto.getCodigo() != null) {
            // Extraer el número del código
            String codigoUltimo = ultimoProducto.getCodigo();
            String numeroStr = codigoUltimo.replaceAll("[^0-9]", ""); // solo los números
            try {
                siguienteNumero = Integer.parseInt(numeroStr) + 1;
            } catch (NumberFormatException e) {
                siguienteNumero = 1;
            }
        }

        // Formatear código: PREFIJO + número de 3 dígitos
        String nuevoCodigo = String.format("%s%03d", prefijo, siguienteNumero);
        producto.setCodigo(nuevoCodigo);
    }

    // ======================================================
    // EDITAR
    // ======================================================
    @GetMapping("/editar/{id}")
    public String editarProducto(@PathVariable("id") Integer id, Model model) {
        Producto producto = productoRepo.findById(id).orElse(null);
        if (producto == null) {
            return "redirect:/productos/listar";
        }
        model.addAttribute("producto", producto);
        model.addAttribute("categorias", categoriaRepo.findAll());
        model.addAttribute("proveedores", proveedorRepo.findAll());
        return "producto/producto-editar";
    }

    // ======================================================
    // ELIMINAR
    // ======================================================
    @GetMapping("/eliminar/{id}")
    public String eliminarProducto(@PathVariable("id") Integer id) {
        productoRepo.deleteById(id);
        return "redirect:/productos/listar";
    }
}