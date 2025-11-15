package pe.idat.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "almacen")
public class Almacen {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_almacen")
    private Integer idAlmacen;

    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;

    @Column(name = "ubicacion", length = 150)
    private String ubicacion;

    @Column(name = "descripcion", length = 250)
    private String descripcion;

    @Column(name = "encargado")
    private Integer encargado; // referencia a usuario.id_usuario (puedes mapear como @ManyToOne si quieres)

    @Column(name = "fecha_creacion", insertable = false, updatable = false)
    private java.sql.Timestamp fechaCreacion;

    // getters & setters
    public Integer getIdAlmacen() { return idAlmacen; }
    public void setIdAlmacen(Integer idAlmacen) { this.idAlmacen = idAlmacen; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getUbicacion() { return ubicacion; }
    public void setUbicacion(String ubicacion) { this.ubicacion = ubicacion; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public Integer getEncargado() { return encargado; }
    public void setEncargado(Integer encargado) { this.encargado = encargado; }

    public java.sql.Timestamp getFechaCreacion() { return fechaCreacion; }
}
