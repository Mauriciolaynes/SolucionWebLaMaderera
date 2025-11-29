package pe.idat.dto;

import com.fasterxml.jackson.annotation.JsonProperty; // <-- ¡Importa esta anotación!

public class ProductoDTO {

    private Integer idProducto;
    private String nombre;
    private double precioCompra;
    private Integer idProveedor;

    // Constructor vacío (¡MUY IMPORTANTE!)
    public ProductoDTO() {
    }

    // Constructor
    public ProductoDTO(Integer idProducto, String nombre, double precioCompra, Integer idProveedor) {
        this.idProducto = idProducto;
        this.nombre = nombre;
        this.precioCompra = precioCompra;
        this.idProveedor = idProveedor;
    }

    // Getters y Setters con @JsonProperty
    @JsonProperty("idProducto")
    public Integer getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(Integer idProducto) {
        this.idProducto = idProducto;
    }

    @JsonProperty("nombre")
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    @JsonProperty("precioCompra")
    public double getPrecioCompra() {
        return precioCompra;
    }

    public void setPrecioCompra(double precioCompra) {
        this.precioCompra = precioCompra;
    }

    @JsonProperty("idProveedor")
    public Integer getIdProveedor() {
        return idProveedor;
    }

    public void setIdProveedor(Integer idProveedor) {
        this.idProveedor = idProveedor;
    }
}
