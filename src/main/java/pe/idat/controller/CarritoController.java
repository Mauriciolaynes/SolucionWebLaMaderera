package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import pe.idat.entity.Producto;
import pe.idat.entity.ItemCarrito;
import pe.idat.repository.ProductoRepository;

import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/carrito")
public class CarritoController {
    @Autowired
    private ProductoRepository productoRepository;

    // 1. VER EL CARRITO
    @GetMapping
    public String irAlCarrito(HttpSession session, Model model) {
        // Recuperar carrito de la sesión
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
        }

        // Calcular total
        Double total = 0.0;
        for (ItemCarrito item : carrito) {
            total += item.getSubtotal();
        }

        model.addAttribute("carrito", carrito);
        model.addAttribute("total", total);

        return "Carrito/Carrito"; // Retorna Carrito.jsp
    }

    // 2. AGREGAR PRODUCTO AL CARRITO
    @PostMapping("/agregar")
    public String agregarAlCarrito(@RequestParam("idProducto") Integer idProducto,
            @RequestParam(value = "cantidad", defaultValue = "1") Integer cantidad,
            HttpSession session) {

        // Buscar el producto en la BD
        Producto producto = productoRepository.findById(idProducto).orElse(null);

        if (producto != null) {
            // Recuperar carrito de sesión
            List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
            if (carrito == null) {
                carrito = new ArrayList<>();
            }

            // Buscar si ya existe para aumentar cantidad
            boolean existe = false;
            for (ItemCarrito item : carrito) {
                if (item.getProducto().getIdProducto().equals(idProducto)) {
                    item.setCantidad(item.getCantidad() + cantidad);
                    existe = true;
                    break;
                }
            }

            // Si no existe, lo agregamos
            if (!existe) {
                carrito.add(new ItemCarrito(producto, cantidad));
            }

            // Guardar en sesión
            session.setAttribute("carrito", carrito);
        }

        return "redirect:/carrito"; // Redirigir a la vista del carrito
    }

    // 3. ELIMINAR PRODUCTO
    @GetMapping("/eliminar/{id}")
    public String eliminarDelCarrito(@PathVariable("id") Integer idProducto, HttpSession session) {
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
        if (carrito != null) {
            // Eliminar el item que coincida con el ID
            carrito.removeIf(item -> item.getProducto().getIdProducto().equals(idProducto));
            session.setAttribute("carrito", carrito);
        }
        return "redirect:/carrito";
    }
    // ... tus métodos anteriores ...

    // 4. SUMAR CANTIDAD (+1)
    @GetMapping("/sumar/{id}")
    public String sumarCantidad(@PathVariable("id") Integer idProducto, HttpSession session) {
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
        if (carrito != null) {
            for (ItemCarrito item : carrito) {
                if (item.getProducto().getIdProducto().equals(idProducto)) {
                    item.setCantidad(item.getCantidad() + 1);
                    break;
                }
            }
        }
        return "redirect:/carrito";
    }

    // 5. RESTAR CANTIDAD (-1)
    @GetMapping("/restar/{id}")
    public String restarCantidad(@PathVariable("id") Integer idProducto, HttpSession session) {
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
        if (carrito != null) {
            for (ItemCarrito item : carrito) {
                if (item.getProducto().getIdProducto().equals(idProducto)) {
                    if (item.getCantidad() > 1) {
                        item.setCantidad(item.getCantidad() - 1);
                    } else {
                        // Opcional: Si baja de 1, podrías eliminarlo o dejarlo en 1
                        // Por ahora lo dejamos en 1 para evitar accidentes
                    }
                    break;
                }
            }
        }
        return "redirect:/carrito";
    }

    @GetMapping("/procesar")
    public String procesarPago(HttpSession session, Model model) {
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");

        // Validación: Si no hay carrito o está vacío, volver al inicio
        if (carrito == null || carrito.isEmpty()) {
            return "redirect:/";
        }

        // Calculamos el total nuevamente por seguridad
        Double total = 0.0;
        for (ItemCarrito item : carrito) {
            total += item.getSubtotal();
        }
        model.addAttribute("total", total);

        return "Carrito/Pago"; // Busca el archivo Pago.jsp
    }

    @PostMapping("/finalizar")
    public String finalizarVenta(HttpSession session, Model model) {
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");

        if (carrito == null || carrito.isEmpty()) {
            return "redirect:/";
        }

        // Calculamos totales para el Ticket
        Double subtotal = 0.0;
        for (ItemCarrito item : carrito) {
            subtotal += item.getSubtotal();
        }

        // Enviamos datos al Ticket.jsp
        model.addAttribute("items", carrito);
        model.addAttribute("total", subtotal);
        model.addAttribute("fecha", java.time.LocalDate.now());
        model.addAttribute("hora", java.time.LocalTime.now().toString().substring(0, 5));
        model.addAttribute("nroPedido", "P-" + System.currentTimeMillis());

        // --- ¡ESTA ES LA LÍNEA MÁGICA QUE TE FALTABA! ---
        // Borramos el carrito de la memoria para que quede vacío
        session.removeAttribute("carrito");
        // ------------------------------------------------

        return "Carrito/Ticket";
    }
}