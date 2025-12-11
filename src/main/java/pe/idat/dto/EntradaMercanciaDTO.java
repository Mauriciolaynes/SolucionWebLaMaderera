package pe.idat.dto;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DTO para recibir una entrada de mercancía completa (compra)
 * Incluye datos de la factura y los productos recibidos
 */
public class EntradaMercanciaDTO {

    private Integer idFactura; // Si queremos vincular con una factura existente
    private String numeroFactura;
    private LocalDate fechaRecepcion;
    private Integer idProveedor;
    private String nombreProveedor; // Para mostrar
    private Integer idAlmacen; // Almacén donde se recibe
    private String observaciones;
    private List<ProductoEntradaDTO> productos = new ArrayList<>();

    public EntradaMercanciaDTO() {
        this.fechaRecepcion = LocalDate.now();
    }

    // Getters y Setters
    public Integer getIdFactura() {
        return idFactura;
    }

    public void setIdFactura(Integer idFactura) {
        this.idFactura = idFactura;
    }

    public String getNumeroFactura() {
        return numeroFactura;
    }

    public void setNumeroFactura(String numeroFactura) {
        this.numeroFactura = numeroFactura;
    }

    public LocalDate getFechaRecepcion() {
        return fechaRecepcion;
    }

    public void setFechaRecepcion(LocalDate fechaRecepcion) {
        this.fechaRecepcion = fechaRecepcion;
    }

    public Integer getIdProveedor() {
        return idProveedor;
    }

    public void setIdProveedor(Integer idProveedor) {
        this.idProveedor = idProveedor;
    }

    public String getNombreProveedor() {
        return nombreProveedor;
    }

    public void setNombreProveedor(String nombreProveedor) {
        this.nombreProveedor = nombreProveedor;
    }

    public Integer getIdAlmacen() {
        return idAlmacen;
    }

    public void setIdAlmacen(Integer idAlmacen) {
        this.idAlmacen = idAlmacen;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public List<ProductoEntradaDTO> getProductos() {
        return productos;
    }

    public void setProductos(List<ProductoEntradaDTO> productos) {
        this.productos = productos;
    }

    public void agregarProducto(ProductoEntradaDTO producto) {
        this.productos.add(producto);
    }
}
