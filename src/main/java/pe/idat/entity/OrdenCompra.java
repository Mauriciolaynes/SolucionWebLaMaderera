package pe.idat.entity;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import jakarta.persistence.*;

@Entity
@Table(name = "ordenes_compra")
public class OrdenCompra {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idOrden;

    private String numeroOrden;

    private LocalDate fecha;

    @ManyToOne
    @JoinColumn(name = "id_proveedor")
    private Proveedor proveedor;

    private String estado; // EJ: GENERADA, ENVIADA, RECIBIDA

    @OneToMany(mappedBy = "ordenCompra", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrdenCompraDetalle> detalles = new ArrayList<>();

    // opcional: referencia a la cotización origen
    @ManyToOne
    @JoinColumn(name = "id_cotizacion")
    private Cotizacion cotizacionOrigen;

    // getters / setters
    public Integer getIdOrden() { return idOrden; }
    public void setIdOrden(Integer idOrden) { this.idOrden = idOrden; }

    public String getNumeroOrden() { return numeroOrden; }
    public void setNumeroOrden(String numeroOrden) { this.numeroOrden = numeroOrden; }

    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }

    public Proveedor getProveedor() { return proveedor; }
    public void setProveedor(Proveedor proveedor) { this.proveedor = proveedor; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public List<OrdenCompraDetalle> getDetalles() { return detalles; }
    public void setDetalles(List<OrdenCompraDetalle> detalles) { this.detalles = detalles; }

    public Cotizacion getCotizacionOrigen() { return cotizacionOrigen; }
    public void setCotizacionOrigen(Cotizacion cotizacionOrigen) { this.cotizacionOrigen = cotizacionOrigen; }

}
