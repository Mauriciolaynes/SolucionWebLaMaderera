package pe.idat.controller;

import java.util.ArrayList;
import java.util.List;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import pe.idat.entity.PedidoCompra;
import pe.idat.entity.PedidoCompraDetalle;
import pe.idat.entity.Producto;
import pe.idat.entity.Proveedor;
import pe.idat.dto.ProductoDTO;
import pe.idat.repository.ProductoRepository;
import pe.idat.repository.ProveedorRepository;
import pe.idat.service.PedidoCompraService;

@Controller
@RequestMapping("/pedidos-compra")
@SessionAttributes("pedidoEnProceso") 
public class PedidoCompraController {

    @Autowired
    private PedidoCompraService pedidoCompraService;

    @Autowired
    private ProveedorRepository proveedorRepository;

    @Autowired
    private ProductoRepository productoRepository;

    @Autowired
    private ObjectMapper objectMapper;

    /**
     * Muestra el formulario inicial para crear un nuevo pedido.
     * Carga los proveedores y productos, y convierte la lista de productos a JSON.
     */
    @GetMapping("/nuevo")
    public String mostrarFormularioNuevo(Model model, RedirectAttributes flash) {
        // Enviamos la lista de todos los proveedores para el selector principal
        model.addAttribute("proveedores", proveedorRepository.findAll());
        
        try {
            // 1. Obtenemos la lista completa de productos usando FETCH JOIN 
            List<Producto> listaProductosCompleta = productoRepository.findAllWithProveedor();
            
            // 2. Creamos una lista de DTOs
            List<ProductoDTO> listaProductosDTO = new ArrayList<>();

            // 3. Convertimos cada Producto a un ProductoDTO.
            for (Producto producto : listaProductosCompleta) {
                
                // *** 💡 DEPURA EL NOMBRE EN LA CONSOLA DEL SERVIDOR ***
                System.out.println("DEBUG - Producto ID: " + producto.getIdProducto() + " | Nombre de la BD: [" + producto.getNombre() + "]");
                
                // *** CORRECCIÓN TEMPORAL: Manejar nombres nulos/vacíos ***
                String nombreProducto = producto.getNombre();
                if (nombreProducto == null || nombreProducto.trim().isEmpty()) {
                    nombreProducto = "PRODUCTO SIN NOMBRE (ID: " + producto.getIdProducto() + ")";
                }

                // El Proveedor ya está cargado gracias a 'findAllWithProveedor'.
                Integer idProveedor = (producto.getProveedor() != null) ? producto.getProveedor().getIdProveedor() : null;
                
                listaProductosDTO.add(new ProductoDTO(
                    producto.getIdProducto(),
                    nombreProducto, // Usamos la variable corregida
                    producto.getPrecioCompra(),
                    idProveedor
                ));
            }

            // 4. Convertimos la lista de DTOs a JSON.
            String productosJson = objectMapper.writeValueAsString(listaProductosDTO);
            model.addAttribute("productosJson", productosJson);
        } catch (JsonProcessingException e) {
            // En caso de error, enviamos un JSON vacío
            System.err.println("Error al serializar productos a JSON: " + e.getMessage());
            flash.addFlashAttribute("error", "No se pudieron cargar los productos para la selección.");
            model.addAttribute("productosJson", "[]");
        }
        
        // El nombre de la vista JSP
        return "pedidos_compra/crear-pedido"; 
        
    }

    /**
     * Procesa los datos del formulario de creación y prepara el resumen.
     */
    @PostMapping("/resumen")
    public String procesarResumen(@ModelAttribute PedidoCompra pedido, 
                                 Model model, 
                                 RedirectAttributes flash) {

        // --- VALIDACIÓN DE PRODUCTOS ---
        if (pedido.getDetalles() == null || pedido.getDetalles().isEmpty()) {
            flash.addFlashAttribute("error", "No se puede generar un resumen sin productos. Por favor, añada al menos un item.");
            return "redirect:/pedidos-compra/nuevo";
        }

        // Remover detalles donde no se seleccionó un producto.
        pedido.getDetalles().removeIf(d -> d.getProducto() == null || d.getProducto().getIdProducto() == null);

        if (pedido.getDetalles().isEmpty()) {
            flash.addFlashAttribute("error", "El pedido debe tener al menos un producto válido seleccionado.");
            return "redirect:/pedidos-compra/nuevo";
        }

        try {
            // 1. Cargar el objeto Proveedor completo desde la base de datos
            Proveedor proveedor = proveedorRepository.findById(pedido.getProveedor().getIdProveedor())
                    .orElseThrow(() -> new IllegalArgumentException("Proveedor no válido:" + pedido.getProveedor().getIdProveedor()));
            pedido.setProveedor(proveedor);

            // 2. Para cada detalle, cargar el objeto Producto completo
            for (PedidoCompraDetalle detalle : pedido.getDetalles()) {
                Producto producto = productoRepository.findById(detalle.getProducto().getIdProducto())
                        .orElseThrow(() -> new IllegalArgumentException("Producto no válido:" + detalle.getProducto().getIdProducto()));
                detalle.setProducto(producto);
                // Establecer la relación bidireccional
                detalle.setPedidoCompra(pedido);
            }

            // 3. Poner el objeto en el modelo para que @SessionAttributes lo guarde en la sesión
            model.addAttribute("pedidoEnProceso", pedido);

            // 4. Redirigir a la URL que mostrará el resumen
            return "redirect:/pedidos-compra/resumen-vista";

        } catch (Exception e) {
            flash.addFlashAttribute("error", "Ocurrió un error al procesar el pedido: " + e.getMessage());
            return "redirect:/pedidos-compra/nuevo";
        }
    }

    /**
     * Muestra la página de resumen, recuperando el pedido de la sesión.
     */
    @GetMapping("/resumen-vista")
    public String mostrarResumenVista(@ModelAttribute("pedidoEnProceso") PedidoCompra pedido, Model model) {
        return "pedidos_compra/resumen-pedido";
    }


    /**
     * Guarda el pedido de la sesión en la base de datos y limpia la sesión.
     */
    @PostMapping("/guardar")
    public String guardarPedidoConfirmado(@ModelAttribute("pedidoEnProceso") PedidoCompra pedido,
                                         RedirectAttributes flash,
                                         SessionStatus status) {
        try {
            // El objeto 'pedido' viene completo desde la sesión
            pedidoCompraService.crearPedido(pedido);

            // Limpiar el objeto de la sesión
            status.setComplete();

            flash.addFlashAttribute("success", "Pedido de compra creado con éxito. Número de pedido: " + pedido.getNumeroPedido());
            return "redirect:/pedidos-compra/nuevo";

        } catch (Exception e) {
            flash.addFlashAttribute("error", "Error al guardar el pedido: " + e.getMessage());
            return "redirect:/pedidos-compra/resumen-vista";
        }
        
    }
    
}