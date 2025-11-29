package pe.idat.entity;

import jakarta.persistence.*;
import java.util.List;

import jakarta.validation.constraints.*;

@Entity
@Table(name = "proveedor")
public class Proveedor {
		@Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    @Column(name = "id_proveedor")
	    private Integer idProveedor;
	
	    @NotBlank(message = "El nombre es obligatorio")
	    @Pattern(regexp = "^[A-Za-zÁÉÍÓÚáéíóúñÑ ]+$", 
	             message = "El nombre solo debe contener letras")
	    private String nombre;
	
	    @NotBlank(message = "El RUC es obligatorio")
	    @Size(min = 11, max = 11, message = "El RUC debe tener 11 dígitos")	             
	    private String ruc;
	
	    @NotBlank(message = "El teléfono es obligatorio")
	    @Pattern(regexp = "^[0-9]{6,9}$",
	             message = "El teléfono debe tener entre 6 y 9 dígitos")
	    private String telefono;
	
	    @Email(message = "El correo no es válido")
	    @NotBlank(message = "El correo es obligatorio")
	    private String correo;
	
	    @NotBlank(message = "La dirección es obligatoria")
	    private String direccion;
	
	    private Boolean estado = true;

	    @OneToMany(mappedBy = "proveedor")
	    private List<PedidoCompra> pedidosCompra;

	    // Getters y Setters
	    public Integer getIdProveedor() { return idProveedor; }
	    public void setIdProveedor(Integer idProveedor) { this.idProveedor = idProveedor; }

	    public String getNombre() { return nombre; }
	    public void setNombre(String nombre) { this.nombre = nombre; }

	    public String getRuc() { return ruc; }
	    public void setRuc(String ruc) { this.ruc = ruc; }

	    public String getTelefono() { return telefono; }
	    public void setTelefono(String telefono) { this.telefono = telefono; }

	    public String getCorreo() { return correo; }
	    public void setCorreo(String correo) { this.correo = correo; }

	    public String getDireccion() { return direccion; }
	    public void setDireccion(String direccion) { this.direccion = direccion; }

	    public Boolean getEstado() { return estado; }
	    public void setEstado(Boolean estado) { this.estado = estado; }

		public List<PedidoCompra> getPedidosCompra() { return pedidosCompra; }
		public void setPedidosCompra(List<PedidoCompra> pedidosCompra) { this.pedidosCompra = pedidosCompra; }
	
}
