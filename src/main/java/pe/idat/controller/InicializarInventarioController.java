package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Controlador de utilidad para inicializar el inventario
 * TEMPORAL - Solo usar para configuración inicial
 */
@Controller
@RequestMapping("/admin/utilidades")
public class InicializarInventarioController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final Integer ID_ALMACEN_PRINCIPAL = 1;

    /**
     * Endpoint para inicializar inventario automáticamente
     * Crea registros en almacen_producto para todos los productos que no los tengan
     * 
     * Acceder:
     * http://localhost:8090/laMaderera/admin/utilidades/inicializar-inventario
     */
    @GetMapping("/inicializar-inventario")
    @ResponseBody
    public String inicializarInventario() {
        try {
            StringBuilder resultado = new StringBuilder();
            resultado.append("<html><head><meta charset='UTF-8'></head><body>");
            resultado.append("<h2>🔧 Inicialización de Inventario</h2>");

            // 1. Verificar/crear almacén principal
            Integer countAlmacen = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM almacen WHERE id_almacen = ?",
                    Integer.class,
                    ID_ALMACEN_PRINCIPAL);

            if (countAlmacen == 0) {
                jdbcTemplate.update(
                        "INSERT INTO almacen (id_almacen, nombre, ubicacion, descripcion) VALUES (?, ?, ?, ?)",
                        ID_ALMACEN_PRINCIPAL,
                        "Almacén Principal",
                        "Bodega Central",
                        "Almacén principal de La Maderera");
                resultado.append("<p>✅ Almacén principal creado</p>");
            } else {
                resultado.append("<p>✅ Almacén principal ya existe</p>");
            }

            // 2. Inicializar inventario para productos que no tienen registro
            String sqlInsert = "INSERT INTO almacen_producto (id_almacen, id_producto, stock_actual, stock_minimo, fecha_actualizacion) "
                    +
                    "SELECT ?, p.id_producto, 0, 10, NOW() " +
                    "FROM producto p " +
                    "WHERE p.estado = 1 " +
                    "AND NOT EXISTS ( " +
                    "    SELECT 1 FROM almacen_producto ap " +
                    "    WHERE ap.id_almacen = ? AND ap.id_producto = p.id_producto " +
                    ")";

            int registrosCreados = jdbcTemplate.update(sqlInsert, ID_ALMACEN_PRINCIPAL, ID_ALMACEN_PRINCIPAL);

            // 3. Contar productos totales
            Integer totalProductos = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM producto WHERE estado = 1",
                    Integer.class);

            Integer productosEnInventario = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM almacen_producto WHERE id_almacen = ?",
                    Integer.class,
                    ID_ALMACEN_PRINCIPAL);

            resultado.append("<hr>");
            resultado.append("<h3>📊 Resumen:</h3>");
            resultado.append("<ul>");
            resultado.append("<li>✅ Nuevos registros creados: <b>").append(registrosCreados).append("</b></li>");
            resultado.append("<li>📦 Productos activos en sistema: <b>").append(totalProductos).append("</b></li>");
            resultado.append("<li>📋 Productos en inventario: <b>").append(productosEnInventario).append("</b></li>");
            resultado.append("</ul>");

            if (registrosCreados > 0) {
                resultado.append(
                        "<div style='padding:15px; background:#d4edda; border:1px solid #28a745; border-radius:5px; margin:20px 0;'>");
                resultado.append("<h3 style='color:#155724; margin-top:0;'>✅ ¡Éxito!</h3>");
                resultado.append("<p style='color:#155724;'>Se inicializaron <b>").append(registrosCreados)
                        .append(" productos</b> con stock = 0</p>");
                resultado.append("</div>");
            } else {
                resultado.append(
                        "<div style='padding:15px; background:#fff3cd; border:1px solid #ffc107; border-radius:5px; margin:20px 0;'>");
                resultado.append(
                        "<p style='color:#856404;'>⚠️ Todos los productos ya tenían registros de inventario</p>");
                resultado.append("</div>");
            }

            resultado.append("<hr>");
            resultado.append("<h3>⚠️ Próximos pasos:</h3>");
            resultado.append("<p>Los productos se inicializaron con <b>stock = 0</b>. Para agregar stock:</p>");
            resultado.append("<ol>");
            resultado.append(
                    "<li><a href='/laMaderera/admin/utilidades/dar-stock-inicial' style='color:#007bff;'>Dar stock automático (50 unidades a todos)</a></li>");
            resultado.append(
                    "<li><a href='/laMaderera/inventario/entradas/nuevo' style='color:#007bff;'>Registrar entrada de mercancía</a></li>");
            resultado.append(
                    "<li><a href='/laMaderera/inventario/listar' style='color:#007bff;'>Editar stock manualmente</a></li>");
            resultado.append("</ol>");

            resultado.append("<p style='margin-top:30px;'>");
            resultado.append(
                    "<a href='/laMaderera/inventario/listar' style='padding:12px 24px; background:#007bff; color:white; text-decoration:none; border-radius:5px; display:inline-block;'>📦 Ver Inventario</a>");
            resultado.append("</p>");

            resultado.append("</body></html>");

            return resultado.toString();

        } catch (Exception e) {
            return "<html><body><h2>❌ Error</h2><p>" + e.getMessage() + "</p><pre>" + getStackTrace(e)
                    + "</pre></body></html>";
        }
    }

    /**
     * Endpoint para dar stock inicial a todos los productos
     */
    @GetMapping("/dar-stock-inicial")
    @ResponseBody
    public String darStockInicial() {
        try {
            String sql = "UPDATE almacen_producto SET stock_actual = 50, fecha_actualizacion = NOW() WHERE id_almacen = ? AND stock_actual = 0";
            int actualizados = jdbcTemplate.update(sql, ID_ALMACEN_PRINCIPAL);

            StringBuilder resultado = new StringBuilder();
            resultado.append("<html><body>");
            resultado.append("<h2>📦 Stock Inicial Asignado</h2>");
            resultado.append("<p>Se asignaron <b>50 unidades</b> a <b>").append(actualizados)
                    .append(" productos</b></p>");
            resultado.append(
                    "<p><a href='/laMaderera/inventario/listar' style='padding:10px 20px; background:#28a745; color:white; text-decoration:none; border-radius:5px;'>✅ Ver Inventario</a></p>");
            resultado.append("</body></html>");

            return resultado.toString();
        } catch (Exception e) {
            return "<html><body><h2>❌ Error</h2><p>" + e.getMessage() + "</p></body></html>";
        }
    }

    private String getStackTrace(Exception e) {
        StringBuilder sb = new StringBuilder();
        for (StackTraceElement element : e.getStackTrace()) {
            sb.append(element.toString()).append("\n");
        }
        return sb.toString();
    }
}
