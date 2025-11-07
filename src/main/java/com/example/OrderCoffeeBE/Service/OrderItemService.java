package com.example.OrderCoffeeBE.Service;

import com.example.OrderCoffeeBE.Dto.Order.OrderItemDTO;
import com.example.OrderCoffeeBE.Model.OrderItem;

import java.util.List;

public interface OrderItemService {
    List<OrderItem> findAll();
    OrderItem createOrderItem(OrderItemDTO orderItemDTO);
    OrderItem updateOrderItem(Long id,OrderItemDTO orderItemDTO);
    void deleteOrderItem(Long id);
    OrderItem getOrderDetail(Long id);
    List<OrderItem> findByOrderId(Long orderId);
}
