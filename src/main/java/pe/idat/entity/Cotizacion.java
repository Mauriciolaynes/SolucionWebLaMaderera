package pe.idat.entity;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "cotizaciones")
public class Cotizacion {
	
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idCotizacion;

    private String numeroCotizacion;

    private LocalDate fecha;

    @ManyToOne
    @JoinColumn(name = "id_proveedor")
    private Proveedor proveedor;

    // estado: POR_EVALUAR, APROBADA, RECHAZADA
    @Enumerated(EnumType.STRING)
    @Column(length = 20) // SOLUCIÓN: Aumentar el tamaño de la columna en la BD
    private CotizacionEstado estado;


    // ruta o nombre del archivo adjunto (puedes adaptar a BLOB si deseas)
    private String archivoAdjunto;
    
    @Column(columnDefinition = "TEXT")
    private String condiciones;


    @OneToMany(mappedBy = "cotizacion", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CotizacionDetalle> detalles = new ArrayList<>();

 // Nuevo campo: Relación con PedidoCompra y Validación de Negocio
    @NotNull(message = "Debe seleccionar el pedido de compra asociado.")
    @ManyToOne
    @JoinColumn(name = "id_pedido_compra") // Clave foránea
    private PedidoCompra pedido;
    
    
    public PedidoCompra getPedido() { return pedido; }
    public void setPedido(PedidoCompra pedido) { this.pedido = pedido; }
    // getters / setters

    public Integer getIdCotizacion() { return idCotizacion; }
    public void setIdCotizacion(Integer idCotizacion) { this.idCotizacion = idCotizacion; }

    public String getNumeroCotizacion() { return numeroCotizacion; }
    public void setNumeroCotizacion(String numeroCotizacion) { this.numeroCotizacion = numeroCotizacion; }

    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }

    public Proveedor getProveedor() { return proveedor; }
    public void setProveedor(Proveedor proveedor) { this.proveedor = proveedor; }

    public CotizacionEstado getEstado() {
        return estado;
    }

    public void setEstado(CotizacionEstado estado) {
        this.estado = estado;
    }

    public String getArchivoAdjunto() { return archivoAdjunto; }
    public void setArchivoAdjunto(String archivoAdjunto) { this.archivoAdjunto = archivoAdjunto; }

    public List<CotizacionDetalle> getDetalles() { return detalles; }
    public void setDetalles(List<CotizacionDetalle> detalles) { this.detalles = detalles; }
    
 // Getters y setters

    public String getCondiciones() {
        return condiciones;
    }

    public void setCondiciones(String condiciones) {
        this.condiciones = condiciones;
    }
}