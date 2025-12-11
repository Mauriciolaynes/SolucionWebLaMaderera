package pe.idat.dto;

/**
 * DTO para representar un producto con su cantidad en una entrada de mercancía
 */
public class ProductoEntradaDTO {

    private Integer idProducto;
    private String nombreProducto; // Para mostrar en la vista
    private Integer cantidad;
    private Double precioCompra; // Opcional: para actualizar precio

    public ProductoEntradaDTO() {
    }

    public ProductoEntradaDTO(Integer idProducto, Integer cantidad) {
        this.idProducto = idProducto;
        this.cantidad = cantidad;
    }

    // Getters y Setters
    public Integer getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(Integer idProducto) {
        this.idProducto = idProducto;
    }

    public String getNombreProducto() {
        return nombreProducto;
    }

    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
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
}
