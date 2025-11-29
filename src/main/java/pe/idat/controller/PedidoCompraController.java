package pe.idat.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import pe.idat.dto.ProductoDTO;
import pe.idat.entity.PedidoCompra;
import pe.idat.entity.PedidoCompraDetalle;
import pe.idat.entity.Producto;
import pe.idat.entity.Proveedor;
import pe.idat.repository.ProductoRepository;
import pe.idat.repository.ProveedorRepository;
import pe.idat.service.PedidoCompraService;

@Controller
@RequestMapping("/pedidos-compra")
@SessionAttributes("pedidoEnProceso") // ¡Vital! Mantiene el objeto vivo entre el Resumen y el Guardado final
public class PedidoCompraController {

    @Autowired
    private PedidoCompraService pedidoCompraService;

    @Autowired
    private ProveedorRepository proveedorRepository;

    @Autowired
    private ProductoRepository productoRepository;

    @Autowired
    private ObjectMapper objectMapper; // Para convertir a JSON

    /**
     * PASO 1: Mostrar el formulario vacío.
     * Carga proveedores y la lista de productos en formato JSON para el JavaScript.
     */
    @GetMapping("/nuevo")
    public String mostrarFormularioNuevo(Model model, RedirectAttributes flash) {
        // 1. Cargar Proveedores para el select
        model.addAttribute("proveedores", proveedorRepository.findAll());
        
        try {
            // 2. Cargar Productos (optimizada con Fetch Join si lo tienes, sino findAll normal)
            // Nota: Asegúrate de que tu repositorio tenga este método o usa findAll()
            List<Producto> listaProductosCompleta = productoRepository.findAll(); 
            
            // 3. Transformar a DTO para enviar solo lo necesario al JSON (ID, Nombre, Precio, ID_Proveedor)
            List<ProductoDTO> listaProductosDTO = new ArrayList<>();

            for (Producto producto : listaProductosCompleta) {
                
                // Validación de nombre nulo para evitar errores en el JS
                String nombreProducto = producto.getNombre();
                if (nombreProducto == null || nombreProducto.trim().isEmpty()) {
                    nombreProducto = "PRODUCTO SIN NOMBRE (ID: " + producto.getIdProducto() + ")";
                }

                // Evitar NullPointer si el producto no tiene proveedor asignado
                Integer idProveedor = (producto.getProveedor() != null) ? producto.getProveedor().getIdProveedor() : null;
                
                listaProductosDTO.add(new ProductoDTO(
                    producto.getIdProducto(),
                    nombreProducto, 
                    producto.getPrecioCompra(),
                    idProveedor
                ));
            }

            // 4. Convertir la lista DTO a String JSON
            String productosJson = objectMapper.writeValueAsString(listaProductosDTO);
            model.addAttribute("productosJson", productosJson);

        } catch (JsonProcessingException e) {
            System.err.println("Error al crear JSON de productos: " + e.getMessage());
            model.addAttribute("productosJson", "[]"); // Enviar array vacío para que no rompa el JS
            model.addAttribute("error", "Error cargando lista de productos.");
        }
        
        // Si no hay un objeto previo en el modelo, creamos uno nuevo
        if (!model.containsAttribute("pedidoEnProceso")) {
            model.addAttribute("pedidoEnProceso", new PedidoCompra());
        }

        return "pedidos_compra/crear-pedido"; // Tu JSP del formulario
    }

    /**
     * PASO 2: Recibir los datos del formulario, validar y preparar el Resumen.
     * Aquí NO se guarda en BD todavía, solo se prepara la vista previa.
     */
    @PostMapping("/resumen")
    public String procesarResumen(@ModelAttribute PedidoCompra pedido, 
                                  Model model, 
                                  RedirectAttributes flash) {

        // --- A. VALIDACIÓN BÁSICA DE LA LISTA ---
        // Eliminar filas que puedan venir vacías o nulas por error del frontend
        if (pedido.getDetalles() != null) {
            pedido.getDetalles().removeIf(d -> 
                d.getProducto() == null || d.getProducto().getIdProducto() == null
            );
        }

        if (pedido.getDetalles() == null || pedido.getDetalles().isEmpty()) {
            flash.addFlashAttribute("error", "Debe agregar al menos un producto válido al pedido.");
            return "redirect:/pedidos-compra/nuevo";
        }

        try {
            // --- B. HIDRATACIÓN DE DATOS (Recuperar objetos completos desde la BD) ---
            
            // 1. Recuperar Proveedor completo (el formulario solo mandó el ID)
            Proveedor proveedor = proveedorRepository.findById(pedido.getProveedor().getIdProveedor())
                    .orElseThrow(() -> new IllegalArgumentException("Proveedor no encontrado"));
            pedido.setProveedor(proveedor);

            // 2. Establecer ESTADO INICIAL
            pedido.setEstado("PENDIENTE");

            // 3. Procesar cada detalle
            double totalCalculado = 0.0;

            for (PedidoCompraDetalle detalle : pedido.getDetalles()) {
                // Recuperar Producto completo para tener el nombre y precio real
                Producto productoBD = productoRepository.findById(detalle.getProducto().getIdProducto())
                        .orElseThrow(() -> new IllegalArgumentException("Producto no existe ID: " + detalle.getProducto().getIdProducto()));
                
                detalle.setProducto(productoBD);
                
                // Asegurar que el precio venga del formulario o de la BD (según tu lógica)
                if (detalle.getPrecioCompra() == null) {
                    detalle.setPrecioCompra(productoBD.getPrecioCompra());
                }

                // *** CRUCIAL: RELACIÓN BIDIRECCIONAL ***
                // Esto le dice al hijo "Tu padre es este pedido". Sin esto, no se guardan los hijos.
                detalle.setPedidoCompra(pedido);

                // Calcular subtotal para el total general
                totalCalculado += (detalle.getCantidad() * detalle.getPrecioCompra());
            }

            pedido.setTotal(totalCalculado);

            // --- C. GUARDAR EN SESIÓN Y REDIRIGIR ---
            // Al agregar 'pedido' al modelo, @SessionAttributes lo captura automáticamente.
            model.addAttribute("pedidoEnProceso", pedido);

            return "redirect:/pedidos-compra/resumen-vista";

        } catch (Exception e) {
            e.printStackTrace();
            flash.addFlashAttribute("error", "Error procesando el resumen: " + e.getMessage());
            return "redirect:/pedidos-compra/nuevo";
        }
    }

    /**
     * PASO 3: Mostrar la vista JSP del Resumen.
     * Recupera 'pedidoEnProceso' automáticamente de la sesión.
     */
    @GetMapping("/resumen-vista")
    public String mostrarResumenVista(@ModelAttribute("pedidoEnProceso") PedidoCompra pedido, Model model) {
        // Aquí el objeto 'pedido' ya viene lleno con lo que hicimos en el paso anterior.
        return "pedidos_compra/resumen-pedido"; // Tu JSP de resumen
    }

    /**
     * PASO 4: Guardar definitivamente en la Base de Datos.
     */
    @PostMapping("/guardar")
    public String guardarPedidoConfirmado(@ModelAttribute("pedidoEnProceso") PedidoCompra pedido,
                                          RedirectAttributes flash,
                                          SessionStatus status) {
        try {
            // El objeto 'pedido' viene completo de la sesión (con detalles, proveedor y estado).
            
            // 1. Guardar en BD (El CascadeType.ALL en la entidad guardará los detalles automáticamente)
            pedidoCompraService.crearPedido(pedido);

            // 2. Limpiar la sesión para que el formulario vuelva a estar vacío la próxima vez
            status.setComplete();

            flash.addFlashAttribute("success", "¡Pedido guardado con éxito! Nro: " + pedido.getNumeroPedido());
            return "redirect:/pedidos-compra/nuevo";

        } catch (Exception e) {
            e.printStackTrace();
            flash.addFlashAttribute("error", "Error crítico al guardar en BD: " + e.getMessage());
            return "redirect:/pedidos-compra/resumen-vista"; // Volver al resumen si falla
        }
    }
}