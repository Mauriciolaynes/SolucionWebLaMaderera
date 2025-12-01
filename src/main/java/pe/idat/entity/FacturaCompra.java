package pe.idat.entity;

import java.time.LocalDate;
import jakarta.persistence.*;

@Entity
@Table(name = "facturas_compra")
public class FacturaCompra {
	 @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Integer idFactura;

	    private String numeroFactura;
	    private LocalDate fecha;
	    private Double monto;
	    private String archivoAdjunto; // ruta/nombre del archivo
	    private String estadoPago; // PENDIENTE, PAGADO

	    @ManyToOne
	    @JoinColumn(name = "id_proveedor")
	    private Proveedor proveedor;

	    @ManyToOne
	    @JoinColumn(name = "id_orden")
	    private OrdenCompra ordenCompra;

	    // getters / setters
	    public Integer getIdFactura() { return idFactura; }
	    public void setIdFactura(Integer idFactura) { this.idFactura = idFactura; }

	    public String getNumeroFactura() { return numeroFactura; }
	    public void setNumeroFactura(String numeroFactura) { this.numeroFactura = numeroFactura; }

	    public LocalDate getFecha() { return fecha; }
	    public void setFecha(LocalDate fecha) { this.fecha = fecha; }

	    public Double getMonto() { return monto; }
	    public void setMonto(Double monto) { this.monto = monto; }

	    public String getArchivoAdjunto() { return archivoAdjunto; }
	    public void setArchivoAdjunto(String archivoAdjunto) { this.archivoAdjunto = archivoAdjunto; }

	    public String getEstadoPago() { return estadoPago; }
	    public void setEstadoPago(String estadoPago) { this.estadoPago = estadoPago; }

	    public Proveedor getProveedor() { return proveedor; }
	    public void setProveedor(Proveedor proveedor) { this.proveedor = proveedor; }

	    public OrdenCompra getOrdenCompra() { return ordenCompra; }
	    public void setOrdenCompra(OrdenCompra ordenCompra) { this.ordenCompra = ordenCompra; }
	
}
