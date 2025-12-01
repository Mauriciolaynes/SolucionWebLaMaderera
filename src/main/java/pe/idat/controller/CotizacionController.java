package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;

import pe.idat.entity.*;
import pe.idat.service.*;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/cotizaciones")
public class CotizacionController {

    @Autowired
    private CotizacionService cotizacionService;

    @Autowired
    private PedidoCompraService pedidoCompraService;
    @Autowired
    private ProveedorService proveedorService;
    @Autowired
    private ProductoService productoService;


    @GetMapping
    public String listar(Model model) {
        model.addAttribute("cotizaciones", cotizacionService.listarCotizaciones());
        model.addAttribute("pedidos", pedidoCompraService.listarTodos());
        return "pedidos_compra/Listado-Compras"; 
    }
    
    @GetMapping("/nueva")
    public String nueva(Model model) {
        Cotizacion cot = new Cotizacion();
        cot.setDetalles(new java.util.ArrayList<>());
        model.addAttribute("cotizacion", cot);
        model.addAttribute("proveedores", proveedorService.listarProveedores());
        model.addAttribute("productos", productoService.listarProductos());
        model.addAttribute("estados", CotizacionEstado.values());
        model.addAttribute("pedidos", pedidoCompraService.listarTodos()); 
        return "cotizaciones/cotizacion-form";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Integer id, Model model, RedirectAttributes redirect) {
        Cotizacion cot = cotizacionService.obtenerPorId(id);
        
        if (cot == null) {
            redirect.addFlashAttribute("error", "Cotización no encontrada.");
            return "redirect:/cotizaciones";
        }
        
        if (cot.getEstado() == CotizacionEstado.APROBADA || cot.getEstado() == CotizacionEstado.RECHAZADA) {
            redirect.addFlashAttribute("warning", "No se puede editar una cotización en estado: " + cot.getEstado() + ".");
            return "redirect:/cotizaciones/ver/" + id; 
        }

        cot.setDetalles(cot.getDetalles() == null ? Collections.emptyList() : cot.getDetalles());

        model.addAttribute("cotizacion", cot);
        model.addAttribute("proveedores", proveedorService.listarProveedores());
        model.addAttribute("productos", productoService.listarProductos());
        model.addAttribute("estados", CotizacionEstado.values());
        model.addAttribute("pedidos", pedidoCompraService.listarTodos());

        return "cotizaciones/editar"; // Apuntamos a la nueva vista de edición
    }

    @PostMapping("/guardar")
    public String guardar(@Valid Cotizacion cotizacion, BindingResult result, Model model, @RequestParam("estado") String estadoForm, @RequestParam("archivoFile") MultipartFile archivo, RedirectAttributes redirect) {
        
        if (result.hasErrors()) {
            model.addAttribute("cotizacion", cotizacion);
            model.addAttribute("proveedores", proveedorService.listarProveedores());
            model.addAttribute("productos", productoService.listarProductos());
            model.addAttribute("estados", CotizacionEstado.values());
            model.addAttribute("pedidos", pedidoCompraService.listarTodos());
            
            if (cotizacion.getDetalles() == null) {
                cotizacion.setDetalles(new java.util.ArrayList<>());
            }
            return "cotizaciones/cotizacion-form"; 
        }
        
        if (archivo != null && !archivo.isEmpty()) {
            try {
                String directorioUpload = "C:\\uploads\\cotizaciones";
                Path ruta = Paths.get(directorioUpload);
                if (!Files.exists(ruta)) {
                    Files.createDirectories(ruta);
                }
                String nombreArchivo = archivo.getOriginalFilename();
                Path rutaCompleta = ruta.resolve(nombreArchivo);
                Files.copy(archivo.getInputStream(), rutaCompleta);
                cotizacion.setArchivoAdjunto(nombreArchivo);
            } catch (Exception e) {
                redirect.addFlashAttribute("error", "Error subiendo archivo: " + e.getMessage());
                return "redirect:/cotizaciones/nueva"; 
            }
        }

        CotizacionEstado nuevoEstado = CotizacionEstado.POR_EVALUAR;
        if (estadoForm != null && !estadoForm.isEmpty()) {
            nuevoEstado = CotizacionEstado.valueOf(estadoForm);
        }
        cotizacion.setEstado(nuevoEstado);

        if (cotizacion.getDetalles() != null) {
            cotizacion.getDetalles().forEach(det -> det.setCotizacion(cotizacion));
        }

        cotizacionService.crearCotizacion(cotizacion);
        
        // --- ACTUALIZAR ESTADO DEL PEDIDO AL GUARDAR ---
        actualizarEstadoPedido(cotizacion, redirect);

        redirect.addFlashAttribute("success", "Cotización guardada exitosamente.");
        return "redirect:/compras";
    }

    // ================== MÉTODO AUXILIAR PARA ACTUALIZAR PEDIDO ==================
    private void actualizarEstadoPedido(Cotizacion cotizacion, RedirectAttributes redirect) {
        try {
            PedidoCompra pedidoAsociado = cotizacion.getPedido();
            if (pedidoAsociado != null && pedidoAsociado.getIdPedidoCompra() != null) {
                PedidoCompra pedidoParaActualizar = pedidoCompraService.obtenerPorId(pedidoAsociado.getIdPedidoCompra());
                if (pedidoParaActualizar != null) {
                    
                    // Mapeo de estados: Cotización -> Pedido
                    String nuevoEstadoPedido = "PENDIENTE"; // Default
                    
                    if (cotizacion.getEstado() == CotizacionEstado.APROBADA) {
                        nuevoEstadoPedido = "Aprobada";
                    } else if (cotizacion.getEstado() == CotizacionEstado.RECHAZADA) {
                        nuevoEstadoPedido = "Rechazada";
                    } else if (cotizacion.getEstado() == CotizacionEstado.ANULADA) {
                        nuevoEstadoPedido = "Anulada";
                    } else {
                         // Si está en evaluación, quizás quieras ponerle "En Cotización" o dejarlo Pendiente
                         nuevoEstadoPedido = "En Evaluación"; 
                    }

                    pedidoParaActualizar.setEstado(nuevoEstadoPedido);
                    pedidoCompraService.crearPedido(pedidoParaActualizar);
                }
            }
        } catch (Exception e) {
            System.err.println("ERROR al actualizar pedido: " + e.getMessage());
            // No bloqueamos el flujo, solo logueamos
        }
    }
    // ==========================================================================

    @GetMapping("/por-pedido/{idPedido}")
    public String listarPorPedido(@PathVariable Integer idPedido, Model model, RedirectAttributes redirect) {
        List<Cotizacion> cotizaciones = cotizacionService.buscarPorPedido(idPedido);
        if (cotizaciones.isEmpty()) {
             redirect.addFlashAttribute("info", "No hay cotizaciones registradas para el Pedido #" + idPedido);
             return "redirect:/pedidos"; 
        }
        model.addAttribute("cotizaciones", cotizaciones);
        model.addAttribute("idPedido", idPedido);
        return "cotizaciones/listado-por-pedido"; 
    }

    @GetMapping("/ver/{id}")
    public String ver(@PathVariable Integer id, Model model) {
        Cotizacion cot = cotizacionService.obtenerPorId(id);
        model.addAttribute("cotizacion", cot);
        return "cotizaciones/ver"; 
    }
    
    @GetMapping("/eliminar/{id}")
    public String mostrarConfirmacionEliminar(@PathVariable Integer id, Model model, RedirectAttributes redirect) {
        Cotizacion cotizacion = cotizacionService.obtenerPorId(id);
        if (cotizacion == null) {
            redirect.addFlashAttribute("error", "La cotización no existe.");
            return "redirect:/compras";
        }
        model.addAttribute("cotizacion", cotizacion);
        return "cotizaciones/eliminar-resumen"; 
    }

    @PostMapping("/eliminar-confirmado")
    public String eliminarConfirmado(@RequestParam("idCotizacion") Integer id, RedirectAttributes redirect) {
        try {
            cotizacionService.eliminar(id);
            redirect.addFlashAttribute("success", "Cotización eliminada correctamente.");
        } catch (Exception e) {
            redirect.addFlashAttribute("error", "No se pudo eliminar la cotización.");
        }
        return "redirect:/compras";
    }

    // ================== APROBAR ====================
    @PostMapping("/aprobar")
    public String aprobar(@RequestParam("idCotizacion") Integer id, RedirectAttributes redirect) {
        Cotizacion cotizacion = cotizacionService.obtenerPorId(id);
        if (cotizacion != null) {
            cotizacion.setEstado(CotizacionEstado.APROBADA);
            cotizacionService.crearCotizacion(cotizacion);
            
            // Actualizar Pedido
            actualizarEstadoPedido(cotizacion, redirect);
            
            redirect.addFlashAttribute("success", "Cotización aprobada.");
        }
        return "redirect:/compras";
    }

    // ================== RECHAZAR ====================
    @PostMapping("/rechazar")
    public String rechazar(@RequestParam("idCotizacion") Integer id, RedirectAttributes redirect) {
        Cotizacion cotizacion = cotizacionService.obtenerPorId(id);
        if (cotizacion != null) {
            cotizacion.setEstado(CotizacionEstado.RECHAZADA);
            cotizacionService.crearCotizacion(cotizacion);
            
            // Actualizar Pedido
            actualizarEstadoPedido(cotizacion, redirect);
            
            redirect.addFlashAttribute("warning", "Cotización rechazada.");
        }
        return "redirect:/compras";
    }

    // ================== ANULAR ====================
    @PostMapping("/anular")
    public String anular(@RequestParam("idCotizacion") Integer id, RedirectAttributes redirect) {
        Cotizacion cotizacion = cotizacionService.obtenerPorId(id);
        if (cotizacion != null) {
            cotizacion.setEstado(CotizacionEstado.ANULADA);
            cotizacionService.crearCotizacion(cotizacion);
            
            // Actualizar Pedido
            actualizarEstadoPedido(cotizacion, redirect);
            
            redirect.addFlashAttribute("info", "Cotización anulada.");
        }
        return "redirect:/compras";
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.setAutoGrowCollectionLimit(1024);
        binder.setIgnoreInvalidFields(true);
    }
}