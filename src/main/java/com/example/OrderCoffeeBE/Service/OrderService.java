package com.example.OrderCoffeeBE.Service;


import com.example.OrderCoffeeBE.Dto.Order.OrderDTO;
import com.example.OrderCoffeeBE.Dto.Order.PostOrderDTO;
import com.example.OrderCoffeeBE.Dto.Order.PutOrderDTO;
import com.example.OrderCoffeeBE.Model.Order;

import java.util.List;
public interface OrderService {
    List<Order> findAll();
    Order createOrder(PostOrderDTO orderDTO);
    Order updateOrder(Long id, PutOrderDTO orderDTO);
    void sortDeleteOrder(int id);
    Order findById(long id);

}
