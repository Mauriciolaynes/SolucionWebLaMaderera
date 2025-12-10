package pe.idat.entity;


import pe.idat.entity.Producto;

public class ItemCarrito {
	private Producto producto; // Guardamos todo el objeto Producto (con su imagen, precio, etc)
    private Integer cantidad;

    public ItemCarrito(Producto producto, Integer cantidad) {
        this.producto = producto;
        this.cantidad = cantidad;
    }

    // Calculamos el subtotal automáticamente
    public Double getSubtotal() {
        return producto.getPrecioVenta() * cantidad;
    }

    // Getters y Setters
    public Producto getProducto() { return producto; }
    public void setProducto(Producto producto) { this.producto = producto; }

    public Integer getCantidad() { return cantidad; }
    public void setCantidad(Integer cantidad) { this.cantidad = cantidad; }
}