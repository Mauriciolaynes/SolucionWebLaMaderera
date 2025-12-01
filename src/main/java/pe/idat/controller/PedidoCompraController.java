package pe.idat.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.ResponseEntity;
import java.util.Map;

import jakarta.validation.Valid;
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
    
    @GetMapping
    public String listarPedidosCompra(Model model) {

        // Método que debe traer pedidos + proveedor + detalles + producto
        List<PedidoCompra> pedidos = pedidoCompraService.listarPedidosConDetalles();

        model.addAttribute("pedidos", pedidos);

        return "pedidos_compra/listado-pedidos";  // tu JSP
    }
    
    @PostMapping("/resumen/editar")
    public String procesarResumenEditado(
            // 1. Recibimos los datos del formulario en un objeto TEMPORAL.
            // El ModelAttribute "pedidoEnProceso" es correcto porque el formulario está bindeado a él.
            @Valid @ModelAttribute("pedidoEnProceso") PedidoCompra pedidoForm,
            BindingResult result,
            Model model,
            RedirectAttributes attributes,
            SessionStatus status) {

        // --- 1. VALIDACIÓN PRIMERO ---
        // Validamos los datos que llegan directamente del formulario.
        if (result.hasErrors()) {
            attributes.addFlashAttribute("error", "Datos inválidos. Por favor, revise el formulario.");
            return "redirect:/pedidos-compra/editar/" + pedidoForm.getIdPedidoCompra();
        }
        
        // Validación manual para asegurar que la lista de detalles no esté vacía.
        if (pedidoForm.getDetalles() == null || pedidoForm.getDetalles().stream().allMatch(d -> d.getProducto() == null || d.getProducto().getIdProducto() == null)) {
            attributes.addFlashAttribute("error", "Debe agregar al menos un producto válido al pedido.");
            return "redirect:/pedidos-compra/editar/" + pedidoForm.getIdPedidoCompra();
        }

        // --- 2. LÓGICA DE SINCRONIZACIÓN (SI LA VALIDACIÓN PASA) ---
        // Obtenemos el objeto REAL que está en la sesión.
        PedidoCompra pedidoEnSesion = (PedidoCompra) model.getAttribute("pedidoEnProceso");

        // --- CORRECCIÓN CRÍTICA ---
        // 1. Guardamos una copia de los detalles que vienen del formulario ANTES de limpiar.
        List<PedidoCompraDetalle> detallesDelFormulario = new ArrayList<>(pedidoForm.getDetalles());
        
        // Limpiamos la lista de detalles del objeto en sesión para reconstruirla.
        pedidoEnSesion.getDetalles().clear();
        
        // Añadimos ÚNICAMENTE los detalles que vinieron del formulario (que ya pasaron la validación).
        // 2. Iteramos sobre la COPIA que guardamos.
        for (PedidoCompraDetalle detalle : detallesDelFormulario) {
            // Re-hidratamos el producto desde la BD para tener el objeto completo (nombre, etc.)
            Producto productoBD = productoRepository.findById(detalle.getProducto().getIdProducto()).orElse(null);
            detalle.setProducto(productoBD);
            pedidoEnSesion.agregarDetalle(detalle); // El método agregarDetalle restablece la relación
        }

        // --- 3. MOSTRAR VISTA DE RESUMEN ---
        // Ahora sí, la vista de resumen leerá el objeto 'pedidoEnProceso' correctamente sincronizado.
        return "pedidos_compra/resumen-pedido"; 
    }
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

        // --- [SOLUCIÓN CLAVE] ---
        // Si el pedido tiene un ID, significa que estamos editando.
        // Lo recuperamos de la BD para no perder la fecha y el número de pedido.
        if (pedido.getIdPedidoCompra() != null) {
            PedidoCompra pedidoExistente = pedidoCompraService.obtenerPorId(pedido.getIdPedidoCompra());
            if (pedidoExistente != null) {
                // Conservamos los datos originales que no vienen en el formulario de edición.
                pedido.setFechaPedido(pedidoExistente.getFechaPedido());
                pedido.setNumeroPedido(pedidoExistente.getNumeroPedido());
            }
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
            boolean esNuevo = pedido.getIdPedidoCompra() == null;

            // Usamos un único método 'guardar' que maneja tanto la creación como la actualización.
            pedidoCompraService.guardar(pedido);

            if (esNuevo) {
                flash.addFlashAttribute("success", "¡Pedido guardado con éxito! Nro: " + pedido.getNumeroPedido());
            } else {
                flash.addFlashAttribute("success", "¡Pedido #" + pedido.getNumeroPedido() + " actualizado con éxito!");
            }

            // 2. Limpiar la sesión para que el formulario vuelva a estar vacío la próxima vez
            status.setComplete();
            return "redirect:/pedidos-compra/nuevo";

        } catch (Exception e) {
            e.printStackTrace();
            flash.addFlashAttribute("error", "Error crítico al guardar en BD: " + e.getMessage());
            return "redirect:/pedidos-compra/resumen-vista"; // Volver al resumen si falla
        }
    }

    /**
     * ACCIÓN: Ver detalle de un Pedido de Compra.
     */
    @GetMapping("/ver/{id}")
    public String verPedido(@PathVariable Integer id, Model model, RedirectAttributes flash) {
        PedidoCompra pedido = pedidoCompraService.obtenerPorId(id);

        if (pedido == null) {
            flash.addFlashAttribute("error", "El pedido de compra no fue encontrado.");
            return "redirect:/pedidos-compra";
        }

        model.addAttribute("pedido", pedido);
        return "pedidos_compra/ver-pedido"; // Debes crear esta vista JSP
    }

    /**
     * ACCIÓN: Mostrar formulario para editar un Pedido de Compra.
     * Ahora carga los datos y muestra una vista de edición dedicada.
     */
    @GetMapping("/editar/{id}")
    public String editarPedido(@PathVariable Integer id, Model model, RedirectAttributes flash) {
        PedidoCompra pedido = pedidoCompraService.obtenerPorId(id);

        if (pedido == null) {
            flash.addFlashAttribute("error", "El pedido de compra no fue encontrado.");
            return "redirect:/pedidos-compra";
        }

        // 1. Cargar Proveedores para el select
        model.addAttribute("proveedores", proveedorRepository.findAll());

        try {
            // 2. Cargar y transformar productos a JSON (igual que en el método 'nuevo')
            List<Producto> listaProductosCompleta = productoRepository.findAll();
            List<ProductoDTO> listaProductosDTO = new ArrayList<>();

            for (Producto producto : listaProductosCompleta) {
                String nombreProducto = (producto.getNombre() != null) ? producto.getNombre() : "SIN NOMBRE";
                Integer idProveedor = (producto.getProveedor() != null) ? producto.getProveedor().getIdProveedor() : null;
                
                listaProductosDTO.add(new ProductoDTO(
                    producto.getIdProducto(),
                    nombreProducto, 
                    producto.getPrecioCompra(),
                    idProveedor
                ));
            }

            String productosJson = objectMapper.writeValueAsString(listaProductosDTO);
            model.addAttribute("productosJson", productosJson);

        } catch (JsonProcessingException e) {
            flash.addFlashAttribute("error", "Error crítico al cargar los productos para la edición.");
            return "redirect:/pedidos-compra";
        }

        // 3. Colocar el pedido a editar en el modelo (y en la sesión)
        model.addAttribute("pedidoEnProceso", pedido);

        // 4. Devolver la nueva vista de edición
        return "pedidos_compra/editar-pedido"; // Nueva vista JSP para editar
    }

    /**
     * PASO 1 (Eliminar): Mostrar vista de confirmación para eliminar.
     * Ya no elimina directamente, solo muestra los datos del pedido a borrar.
     */
    @GetMapping("/eliminar/{id}")
    public String mostrarConfirmacionEliminar(@PathVariable Integer id, Model model, RedirectAttributes flash) {
        PedidoCompra pedido = pedidoCompraService.obtenerPorId(id);

        if (pedido == null) {
            flash.addFlashAttribute("error", "El pedido de compra que intenta eliminar no fue encontrado.");
            return "redirect:/compras"; // Redirige a la vista principal de compras
        }

        model.addAttribute("pedido", pedido);
        return "pedidos_compra/eliminar-resumen"; // Nueva vista JSP de confirmación
    }

    /**
     * PASO 2 (Eliminar): Procesar la eliminación confirmada.
     * Se activa desde el formulario de la vista 'eliminar-resumen'.
     */
    @PostMapping("/eliminar-confirmado")
    public String eliminarPedidoConfirmado(@RequestParam("idPedido") Integer id, RedirectAttributes flash) {
        try {
            pedidoCompraService.eliminar(id); // Aquí se realiza el borrado
            flash.addFlashAttribute("success", "Pedido de compra eliminado correctamente.");
        } catch (Exception e) {
            flash.addFlashAttribute("error", "No se pudo eliminar el pedido. Es posible que tenga cotizaciones asociadas.");
            e.printStackTrace();
        }

        return "redirect:/compras"; // Redirige a la vista principal de compras
    }
    
    /**
     * ACCIÓN (API): Eliminar un detalle de un pedido de compra vía AJAX.
     * Se activa con una petición DELETE desde el JavaScript del formulario de edición.
     */
    @DeleteMapping("/detalle/eliminar/{idDetalle}")
    @ResponseBody // ¡Importante! Indica que la respuesta es el cuerpo, no el nombre de una vista.
    public ResponseEntity<?> eliminarDetalle(@PathVariable Integer idDetalle) {
        try {
            // Llama a un nuevo método en el servicio que se encarga de borrar el detalle.
            // --- CORRECCIÓN CRÍTICA ---
            // La llamada correcta es a 'eliminarDetallePorId', que borra solo la línea del producto.
            pedidoCompraService.eliminarDetallePorId(idDetalle); 
            
            // Si todo va bien, devolvemos una respuesta JSON con un mensaje de éxito.
            return ResponseEntity.ok(Map.of("success", true, "message", "Producto eliminado correctamente."));

        } catch (Exception e) {
            // Si algo falla (ej. el detalle no existe), devolvemos un error.
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "Error al eliminar el producto: " + e.getMessage()));
        }
    }
}