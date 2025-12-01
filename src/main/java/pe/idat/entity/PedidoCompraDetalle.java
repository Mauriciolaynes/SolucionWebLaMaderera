package pe.idat.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "pedidos_compra_detalle")
public class PedidoCompraDetalle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idPedidoDetalle;
    
    private Integer cantidad;
    private Double precioCompra; // Usar camelCase

    // --- RELACIÓN CON PedidoCompra ---
    @ManyToOne
    @JoinColumn(name = "id_pedido_compra")
    @JsonBackReference
    private PedidoCompra pedidoCompra;


    // --- RELACIÓN CON Producto ---
    @ManyToOne
    @JoinColumn(name = "id_producto")
    private Producto producto;

    // --- GETTERS Y SETTERS ---

    public Integer getIdPedidoDetalle() {
        return idPedidoDetalle;
    }

    public void setIdPedidoDetalle(Integer idPedidoDetalle) {
        this.idPedidoDetalle = idPedidoDetalle;
    }

    public Integer getCantidad() {
        return cantidad;
    }

    public void setCantidad(Integer cantidad) {
        this.cantidad = cantidad;
    }

    public Double getPrecioCompra() {
        return precioCompra;
    }

    public void setPrecioCompra(Double precioCompra) {
        this.precioCompra = precioCompra;
    }

    public PedidoCompra getPedidoCompra() {
        return pedidoCompra;
    }

    public void setPedidoCompra(PedidoCompra pedidoCompra) {
        this.pedidoCompra = pedidoCompra;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }
}
