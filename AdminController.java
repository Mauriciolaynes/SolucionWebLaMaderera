package com.lamaderera.controller;

import com.lamaderera.model.PedidoCompra;
import com.lamaderera.service.PedidoCompraService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private PedidoCompraService pedidoCompraService;

    @GetMapping("/pedidos")
    public String listarPedidosCompra(Model model) {
        List<PedidoCompra> listaPedidos = pedidoCompraService.listarTodosLosPedidos();
        model.addAttribute("pedidos", listaPedidos);
        return "admin/listado-pedidos"; // Nombre del archivo JSP
    }
}