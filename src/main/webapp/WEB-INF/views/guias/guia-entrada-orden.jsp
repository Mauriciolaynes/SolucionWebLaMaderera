<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Guía de Entrada ${numeroGuia}</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"
                    rel="stylesheet">
                <style>
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        font-family: 'Inter', Arial, sans-serif;
                        padding: 20px;
                        background: #f5f5f5;
                    }

                    @media screen {
                        .guia-container {
                            max-width: 210mm;
                            margin: 0 auto;
                            background: white;
                            padding: 40px;
                            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
                        }

                        .no-print {
                            position: fixed;
                            top: 20px;
                            right: 20px;
                            z-index: 1000;
                        }
                    }

                    @media print {
                        body {
                            background: white;
                            padding: 0;
                        }

                        .guia-container {
                            width: 100%;
                            padding: 0;
                            box-shadow: none;
                        }

                        .no-print {
                            display: none;
                        }

                        @page {
                            size: A4;
                            margin: 2cm;
                        }
                    }

                    .header {
                        border-bottom: 3px solid #16a34a;
                        padding-bottom: 20px;
                        margin-bottom: 30px;
                    }

                    .header h1 {
                        color: #15803d;
                        font-size: 28px;
                        margin-bottom: 5px;
                    }

                    .header .numero-guia {
                        font-size: 18px;
                        color: #64748b;
                        font-weight: 600;
                    }

                    .header .tipo-doc {
                        font-size: 14px;
                        color: #16a34a;
                        font-weight: 600;
                        margin-top: 5px;
                    }

                    .info-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 30px;
                        margin-bottom: 30px;
                    }

                    .info-section h3 {
                        color: #15803d;
                        font-size: 14px;
                        text-transform: uppercase;
                        margin-bottom: 10px;
                        border-bottom: 2px solid #e2e8f0;
                        padding-bottom: 5px;
                    }

                    .info-section p {
                        margin: 8px 0;
                        font-size: 14px;
                        color: #334155;
                    }

                    .info-section strong {
                        color: #1e293b;
                        display: inline-block;
                        width: 120px;
                    }

                    table {
                        width: 100%;
                        border-collapse: collapse;
                        margin: 20px 0;
                    }

                    thead {
                        background: #15803d;
                        color: white;
                    }

                    th {
                        padding: 12px;
                        text-align: left;
                        font-weight: 600;
                        font-size: 13px;
                        text-transform: uppercase;
                    }

                    td {
                        padding: 12px;
                        border-bottom: 1px solid #e2e8f0;
                        font-size: 14px;
                        color: #475569;
                    }

                    tbody tr:hover {
                        background: #f8fafc;
                    }

                    th.text-right,
                    td.text-right {
                        text-align: right;
                    }

                    th.text-center,
                    td.text-center {
                        text-align: center;
                    }

                    .btn-print {
                        background: #16a34a;
                        color: white;
                        border: none;
                        padding: 12px 24px;
                        border-radius: 8px;
                        font-size: 16px;
                        font-weight: 600;
                        cursor: pointer;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                        transition: all 0.3s;
                    }

                    .btn-print:hover {
                        background: #15803d;
                        transform: translateY(-2px);
                    }

                    .btn-volver {
                        background: #64748b;
                        color: white;
                        text-decoration: none;
                        padding: 12px 24px;
                        border-radius: 8px;
                        font-size: 16px;
                        font-weight: 600;
                        display: inline-block;
                        margin-left: 10px;
                    }

                    .observaciones {
                        margin: 30px 0;
                        padding: 15px;
                        background: #dcfce7;
                        border-left: 4px solid #16a34a;
                        border-radius: 4px;
                    }

                    .firmas {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 50px;
                        margin-top: 60px;
                        padding-top: 40px;
                        border-top: 1px solid #e2e8f0;
                    }

                    .firma-box {
                        text-align: center;
                    }

                    .firma-line {
                        border-top: 2px solid #334155;
                        margin: 50px 20px 10px 20px;
                    }

                    .firma-label {
                        font-weight: 600;
                        color: #475569;
                        font-size: 13px;
                    }

                    .footer {
                        margin-top: 40px;
                        padding-top: 20px;
                        border-top: 1px solid #e2e8f0;
                        text-align: center;
                        color: #94a3b8;
                        font-size: 12px;
                    }
                </style>
            </head>

            <body>
                <div class="no-print">
                    <button onclick="window.print()" class="btn-print">🖨️ Imprimir Guía</button>
                    <a href="${pageContext.request.contextPath}/compras" class="btn-volver">← Volver</a>
                </div>

                <div class="guia-container">
                    <div class="header">
                        <h1>🏢 LA MADERERA</h1>
                        <div class="numero-guia">GUÍA DE ENTRADA N° ${numeroGuia}</div>
                        <div class="tipo-doc">${tipoDocumento} - ${orden.numeroOrden}</div>
                    </div>

                    <div class="info-grid">
                        <div class="info-section">
                            <h3>📅 Información de la Guía</h3>
                            <p><strong>Fecha:</strong>
                                <c:out value="${orden.fecha}" />
                            </p>
                            <p><strong>Almacén Destino:</strong> Almacén Principal</p>
                            <p><strong>Motivo:</strong> COMPRA - ${tipoDocumento}</p>
                            <p><strong>Estado:</strong>
                                <c:out value="${orden.estado}" />
                            </p>
                        </div>

                        <div class="info-section">
                            <h3>🏭 Datos del Proveedor</h3>
                            <p><strong>Nombre:</strong>
                                <c:out value="${orden.proveedor.nombre}" />
                            </p>
                            <p><strong>RUC:</strong>
                                <c:out value="${orden.proveedor.ruc}" />
                            </p>
                            <p><strong>Teléfono:</strong>
                                <c:out value="${orden.proveedor.telefono}" />
                            </p>
                            <p><strong>Dirección:</strong>
                                <c:out value="${orden.proveedor.direccion}" />
                            </p>
                        </div>
                    </div>

                    <h3 style="color: #15803d; margin-bottom: 15px;">📦 Productos a Recibir</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Producto</th>
                                <th class="text-center">Cantidad</th>
                                <th class="text-center">Unidad</th>
                                <th class="text-right">Precio Unit.</th>
                                <th class="text-right">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="detalle" items="${orden.detalles}">
                                <tr>
                                    <td>
                                        <c:out value="${detalle.producto.nombre}" />
                                    </td>
                                    <td class="text-center">
                                        <c:out value="${detalle.cantidad}" />
                                    </td>
                                    <td class="text-center">UND</td>
                                    <td class="text-right">S/
                                        <fmt:formatNumber value="${detalle.precioUnitario}" type="number"
                                            minFractionDigits="2" maxFractionDigits="2" />
                                    </td>
                                    <td class="text-right">S/
                                        <fmt:formatNumber value="${detalle.precioUnitario * detalle.cantidad}"
                                            type="number" minFractionDigits="2" maxFractionDigits="2" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="observaciones">
                        <h4>📝 Observaciones</h4>
                        <p>Verificar que los productos lleguen en perfectas condiciones y coincidan con las cantidades
                            solicitadas.</p>
                    </div>

                    <div class="firmas">
                        <div class="firma-box">
                            <div class="firma-line"></div>
                            <div class="firma-label">ENTREGADO POR</div>
                            <div style="margin-top: 5px; font-size: 12px; color: #94a3b8;">
                                <c:out value="${orden.proveedor.nombre}" />
                            </div>
                        </div>

                        <div class="firma-box">
                            <div class="firma-line"></div>
                            <div class="firma-label">RECIBIDO POR</div>
                            <div style="margin-top: 5px; font-size: 12px; color: #94a3b8;">LA MADERERA - Almacén</div>
                        </div>
                    </div>

                    <div class="footer">
                        <p>Documento generado electrónicamente • LA MADERERA</p>
                        <p>Guía de Entrada N° ${numeroGuia} •
                            <c:out value="${orden.fecha}" />
                        </p>
                    </div>
                </div>
            </body>

            </html>