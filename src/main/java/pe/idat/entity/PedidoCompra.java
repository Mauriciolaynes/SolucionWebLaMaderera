package pe.idat.entity;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

@Entity
@Table(name = "pedidos_compra")
public class PedidoCompra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idPedidoCompra;

    private String numeroPedido;
    private LocalDate fechaPedido;
    private Double total;
    
    private String estado;

    @ManyToOne
    @JoinColumn(name = "id_proveedor")
    private Proveedor proveedor;

    // --- CORRECCIÓN CRÍTICA AQUI ---
    @OneToMany(mappedBy = "pedidoCompra", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    private List<PedidoCompraDetalle> detalles = new ArrayList<>(); // Inicializado para seguridad

    @PrePersist
    protected void onCreate() {
        this.fechaPedido = LocalDate.now();
        // La lógica del estado se moverá al setter para que funcione en creación y actualización.
    }

    // --- GETTERS Y SETTERS ---

    public Integer getIdPedidoCompra() {
        return idPedidoCompra;
    }

    public void setIdPedidoCompra(Integer idPedidoCompra) {
        this.idPedidoCompra = idPedidoCompra;
    }

    public String getNumeroPedido() {
        return numeroPedido;
    }

    public void setNumeroPedido(String numeroPedido) {
        this.numeroPedido = numeroPedido;
    }

    public LocalDate getFechaPedido() {
        return fechaPedido;
    }

    public void setFechaPedido(LocalDate fechaPedido) {
        this.fechaPedido = fechaPedido;
    }

    public Double getTotal() {
        return total;
    }

    public void setTotal(Double total) {
        this.total = total;
    }

    public Proveedor getProveedor() {
        return proveedor;
    }

    public void setProveedor(Proveedor proveedor) {
        this.proveedor = proveedor;
    }

    public List<PedidoCompraDetalle> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<PedidoCompraDetalle> detalles) {
        // Truco pro: Si reasignas la lista completa, asegúrate de mantener la relación bidireccional
        this.detalles = detalles;
        if(detalles != null) {
            for(PedidoCompraDetalle d : detalles) {
                d.setPedidoCompra(this);
            }
        }
    }
    
    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        // --- LÓGICA CENTRALIZADA ---
        // Si el estado que llega es nulo o vacío, le asignamos "PENDIENTE" por defecto.
        // Si llega un estado válido ("Aprobado", "Rechazado", etc.), se asigna ese valor.
        if (estado == null || estado.trim().isEmpty()) {
            this.estado = "PENDIENTE";
        } else {
            this.estado = estado;
        }
    }
    
    // --- MÉTODO AYUDA (Opcional pero muy recomendado) ---
    // Úsalo para agregar detalles desde Java y mantener la coherencia
    public void agregarDetalle(PedidoCompraDetalle detalle) {
        detalles.add(detalle);
        detalle.setPedidoCompra(this);
    }
}