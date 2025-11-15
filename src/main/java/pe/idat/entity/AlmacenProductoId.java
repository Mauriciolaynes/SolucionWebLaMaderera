package pe.idat.entity;


import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class AlmacenProductoId implements Serializable {

    private Integer idAlmacen;
    private Integer idProducto;

    // -----------------------------
    // CONSTRUCTORES
    // -----------------------------
    public AlmacenProductoId() {
    }

    public AlmacenProductoId(Integer idAlmacen, Integer idProducto) {
        this.idAlmacen = idAlmacen;
        this.idProducto = idProducto;
    }

    // -----------------------------
    // GETTERS Y SETTERS
    // -----------------------------
    public Integer getIdAlmacen() {
        return idAlmacen;
    }

    public void setIdAlmacen(Integer idAlmacen) {
        this.idAlmacen = idAlmacen;
    }

    public Integer getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(Integer idProducto) {
        this.idProducto = idProducto;
    }

    // -----------------------------
    // HASHCODE EQUALS
    // -----------------------------
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AlmacenProductoId)) return false;
        AlmacenProductoId that = (AlmacenProductoId) o;
        return Objects.equals(getIdAlmacen(), that.getIdAlmacen()) &&
               Objects.equals(getIdProducto(), that.getIdProducto());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getIdAlmacen(), getIdProducto());
    }
}