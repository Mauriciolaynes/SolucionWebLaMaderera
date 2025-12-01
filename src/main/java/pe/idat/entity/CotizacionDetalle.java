package pe.idat.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "cotizaciones_detalle")
public class CotizacionDetalle  {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idCotizacionDetalle;

    @ManyToOne
    @JoinColumn(name = "id_cotizacion")
    private Cotizacion cotizacion;

    @ManyToOne
    @JoinColumn(name = "id_producto")
    private Producto producto;

    private Integer cantidad;
    private Double precioUnitario; // Precio ofrecido en esta cotización

    @Enumerated(EnumType.STRING)
    @Column(length = 20) // SOLUCIÓN: Aumentar el tamaño de la columna en la BD
    private CotizacionEstado estadoDetalle; // Estado del detalle, reflejando el de la cotización

    // Getters and Setters
    public Integer getIdCotizacionDetalle() {
        return idCotizacionDetalle;
    }

    public void setIdCotizacionDetalle(Integer idCotizacionDetalle) {
        this.idCotizacionDetalle = idCotizacionDetalle;
    }

    public Cotizacion getCotizacion() {
        return cotizacion;
    }

    public void setCotizacion(Cotizacion cotizacion) {
        this.cotizacion = cotizacion;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public Integer getCantidad() {
        return cantidad;
    }

    public void setCantidad(Integer cantidad) {
        this.cantidad = cantidad;
    }

    public Double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(Double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }

    public CotizacionEstado getEstadoDetalle() {
        return estadoDetalle;
    }

    public void setEstadoDetalle(CotizacionEstado estadoDetalle) {
        this.estadoDetalle = estadoDetalle;
    }
}
