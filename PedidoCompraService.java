package com.lamaderera.service;

import com.lamaderera.model.PedidoCompra;
import com.lamaderera.repository.PedidoCompraRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class PedidoCompraService {

    @Autowired
    private PedidoCompraRepository pedidoCompraRepository;

    public List<PedidoCompra> listarTodosLosPedidos() {
        return pedidoCompraRepository.findAll();
    }
}