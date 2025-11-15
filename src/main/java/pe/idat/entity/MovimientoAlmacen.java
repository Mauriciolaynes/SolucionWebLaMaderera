package pe.idat.entity;


import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "movimiento_almacen")
public class MovimientoAlmacen {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_movimiento")
    private Integer idMovimiento;

    @Column(name = "id_tipo_movimiento", nullable = false)
    private Integer idTipoMovimiento; // opcional: mapear como @ManyToOne a TipoMovimiento

    @ManyToOne
    @JoinColumn(name = "id_producto", insertable = false, updatable = false)
    private Producto producto;

    @Column(name = "id_producto", nullable = false)
    private Integer idProducto;

    @Column(name = "id_usuario", nullable = false)
    private Integer idUsuario;

    @Column(name = "id_almacen", nullable = false)
    private Integer idAlmacen;

    @Column(name = "cantidad", nullable = false)
    private Integer cantidad;

    @Column(name = "observacion", length = 255)
    private String observacion;

    @Column(name = "fecha", insertable = false, updatable = false)
    private Timestamp fecha;

    // getters & setters
    public Integer getIdMovimiento() { return idMovimiento; }
    public void setIdMovimiento(Integer idMovimiento) { this.idMovimiento = idMovimiento; }

    public Integer getIdTipoMovimiento() { return idTipoMovimiento; }
    public void setIdTipoMovimiento(Integer idTipoMovimiento) { this.idTipoMovimiento = idTipoMovimiento; }

    public Producto getProducto() { return producto; }
    public Integer getIdProducto() { return idProducto; }
    public void setIdProducto(Integer idProducto) { this.idProducto = idProducto; }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public Integer getIdAlmacen() { return idAlmacen; }
    public void setIdAlmacen(Integer idAlmacen) { this.idAlmacen = idAlmacen; }

    public Integer getCantidad() { return cantidad; }
    public void setCantidad(Integer cantidad) { this.cantidad = cantidad; }

    public String getObservacion() { return observacion; }
    public void setObservacion(String observacion) { this.observacion = observacion; }

    public Timestamp getFecha() { return fecha; }
}
