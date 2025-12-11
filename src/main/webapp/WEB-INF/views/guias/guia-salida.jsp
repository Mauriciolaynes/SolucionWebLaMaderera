<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Guía de Salida ${numeroGuia}</title>
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

                    /* Estilos para pantalla */
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

                    /* Estilos para impresión */
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

                    /* Encabezado */
                    .header {
                        border-bottom: 3px solid #2563eb;
                        padding-bottom: 20px;
                        margin-bottom: 30px;
                    }

                    .header h1 {
                        color: #1e40af;
                        font-size: 28px;
                        margin-bottom: 5px;
                    }

                    .header .numero-guia {
                        font-size: 18px;
                        color: #64748b;
                        font-weight: 600;
                    }

                    /* Grid de información */
                    .info-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 30px;
                        margin-bottom: 30px;
                    }

                    .info-section h3 {
                        color: #1e40af;
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
                        width: 100px;
                    }

                    /* Tabla de productos */
                    table {
                        width: 100%;
                        border-collapse: collapse;
                        margin: 20px 0;
                    }

                    thead {
                        background: #1e40af;
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

                    /* Total */
                    .total-section {
                        text-align: right;
                        margin: 20px 0;
                        padding: 15px;
                        background: #f1f5f9;
                        border-radius: 8px;
                    }

                    .total-section .total {
                        font-size: 24px;
                        font-weight: 700;
                        color: #1e40af;
                    }

                    /* Firmas */
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

                    /* Observaciones */
                    .observaciones {
                        margin: 30px 0;
                        padding: 15px;
                        background: #fef3c7;
                        border-left: 4px solid #f59e0b;
                        border-radius: 4px;
                    }

                    .observaciones h4 {
                        color: #92400e;
                        margin-bottom: 10px;
                    }

                    /* Botón de impresión */
                    .btn-print {
                        background: #2563eb;
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
                        background: #1d4ed8;
                        transform: translateY(-2px);
                        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
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
                        transition: all 0.3s;
                    }

                    .btn-volver:hover {
                        background: #475569;
                    }

                    /* Pie de página */
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
                <!-- Botones de acción (solo en pantalla) -->
                <div class="no-print">
                    <button onclick="window.print()" class="btn-print">
                        🖨️ Imprimir Guía
                    </button>
                    <a href="${pageContext.request.contextPath}/ventas/ver/${venta.id}" class="btn-volver">
                        ← Volver
                    </a>
                </div>

                <div class="guia-container">
                    <!-- Encabezado -->
                    <div class="header">
                        <h1>🏢 LA MADERERA</h1>
                        <div class="numero-guia">GUÍA DE SALIDA N° ${numeroGuia}</div>
                    </div>

                    <!-- Información de la guía y cliente -->
                    <div class="info-grid">
                        <div class="info-section">
                            <h3>📅 Información de la Guía</h3>
                            <p><strong>Fecha:</strong>
                                <c:out value="${venta.fecha}" />
                            </p>
                            <p><strong>Almacén:</strong> Almacén Principal</p>
                            <p><strong>Motivo:</strong> VENTA</p>
                        </div>

                        <div class="info-section">
                            <h3>👤 Datos del Cliente</h3>
                            <p><strong>Nombre:</strong>
                                <c:out value="${venta.usuario.nombresApellidos}" />
                            </p>
                            <p><strong>Documento:</strong>
                                <c:out value="${venta.usuario.tipoDocumento}" /> -
                                <c:out value="${venta.usuario.numeroDocumento}" />
                            </p>
                            <p><strong>Correo:</strong>
                                <c:out value="${venta.usuario.correo}" />
                            </p>
                        </div>
                    </div>

                    <!-- Tabla de productos -->
                    <h3 style="color: #1e40af; margin-bottom: 15px;">📦 Productos</h3>
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
                            <c:forEach var="detalle" items="${venta.detalles}">
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

                    <!-- Total -->
                    <div class="total-section">
                        <div class="total">
                            Total: S/
                            <fmt:formatNumber value="${venta.total}" type="number" minFractionDigits="2"
                                maxFractionDigits="2" />
                        </div>
                    </div>

                    <!-- Observaciones (opcional) -->
                    <div class="observaciones">
                        <h4>📝 Observaciones</h4>
                        <p>Material entregado en perfectas condiciones. Verificar productos al recibir.</p>
                    </div>

                    <!-- Firmas -->
                    <div class="firmas">
                        <div class="firma-box">
                            <div class="firma-line"></div>
                            <div class="firma-label">ENTREGADO POR</div>
                            <div style="margin-top: 5px; font-size: 12px; color: #94a3b8;">LA MADERERA</div>
                        </div>

                        <div class="firma-box">
                            <div class="firma-line"></div>
                            <div class="firma-label">RECIBIDO POR</div>
                            <div style="margin-top: 5px; font-size: 12px; color: #94a3b8;">
                                <c:out value="${venta.usuario.nombresApellidos}" />
                            </div>
                        </div>
                    </div>

                    <!-- Pie de página -->
                    <div class="footer">
                        <p>Documento generado electrónicamente • LA MADERERA</p>
                        <p>Guía de Salida N° ${numeroGuia} •
                            <c:out value="${venta.fecha}" />
                        </p>
                    </div>
                </div>
            </body>

            </html>