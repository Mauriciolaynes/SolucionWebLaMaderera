package pe.idat.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

@Entity
@Table(name = "proveedor")
public class Proveedor {
	 @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Integer id_proveedor;

	    @NotBlank(message = "El nombre es obligatorio")
	    private String nombre;

	    @NotBlank(message = "El RUC es obligatorio")
	    @Size(min = 11, max = 11, message = "El RUC debe tener 11 dígitos")
	    private String ruc;

	    @NotBlank(message = "El teléfono es obligatorio")
	    private String telefono;

	    @Email(message = "El correo no es válido")
	    @NotBlank(message = "El correo es obligatorio")
	    private String correo;

	    @NotBlank(message = "La dirección es obligatoria")
	    private String direccion;

	    private Boolean estado = true;

	    // Getters y Setters
	    public Integer getIdProveedor() { return id_proveedor; }
	    public void setIdProveedor(Integer id_proveedor) { this.id_proveedor = id_proveedor; }

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
	
}
