package pe.idat.entity;
import jakarta.persistence.*;

@Entity
@Table(name = "ordenes_compra_detalle")
public class OrdenCompraDetalle {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idOrdenDetalle;

    private Integer cantidad;
    private Double precioUnitario;

    @ManyToOne
    @JoinColumn(name = "id_orden")
    private OrdenCompra ordenCompra;

    @ManyToOne
    @JoinColumn(name = "id_producto")
    private Producto producto;

    // getters / setters
    public Integer getIdOrdenDetalle() { return idOrdenDetalle; }
    public void setIdOrdenDetalle(Integer id) { this.idOrdenDetalle = id; }

    public Integer getCantidad() { return cantidad; }
    public void setCantidad(Integer cantidad) { this.cantidad = cantidad; }

    public Double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(Double precioUnitario) { this.precioUnitario = precioUnitario; }

    public OrdenCompra getOrdenCompra() { return ordenCompra; }
    public void setOrdenCompra(OrdenCompra ordenCompra) { this.ordenCompra = ordenCompra; }

    public Producto getProducto() { return producto; }
    public void setProducto(Producto producto) { this.producto = producto; }
}
