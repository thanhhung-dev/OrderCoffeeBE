package com.example.OrderCoffeeBE.Service.impl;

import com.example.OrderCoffeeBE.Dto.Order.OrderDTO;
import com.example.OrderCoffeeBE.Dto.Order.PostOrderDTO;
import com.example.OrderCoffeeBE.Model.Product;
import com.example.OrderCoffeeBE.Dto.Order.OrderItemDTO;
import com.example.OrderCoffeeBE.Model.Order;
import com.example.OrderCoffeeBE.Model.OrderItem;
import com.example.OrderCoffeeBE.Model.Tables;
import com.example.OrderCoffeeBE.Service.OrderService;
import com.example.OrderCoffeeBE.Util.Error.ResourceNotFoundException;
import com.example.OrderCoffeeBE.repository.OrderItemRepository;
import com.example.OrderCoffeeBE.repository.OrdersRepository;
import com.example.OrderCoffeeBE.repository.ProductRepository;
import com.example.OrderCoffeeBE.repository.TableRepository;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service("orderService")
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {
    private final OrdersRepository ordersRepository;
    private final OrderItemRepository orderItemRepository;
    private final TableRepository tableRepository;
    private final ProductRepository productRepository;
    private final ModelMapper modelMapper;
    @Override
    public List<Order> findAll() {
        return ordersRepository.findAllNotDeleted();
    }

    @Override
    public Order createOrder(PostOrderDTO orderDTO) {
        // Validate input
        if(orderDTO == null)
        {
            throw new ResourceNotFoundException("Order Is Required");
        }
        //convertDTO -> Order
        //using ModelMapper
        modelMapper.typeMap(PostOrderDTO.class, Order.class)
                .addMappings(mapper -> mapper.skip(Order::setId));
        Order order = new Order();
        Tables tables = tableRepository.findById(orderDTO.getTable_id())
                .orElseThrow(() -> new ResourceNotFoundException("Table Not Found"));
        order.setTable(tables);
        order.setStatus("Pending");
        order.setDeleted(0);
        int calculatedTotal = orderDTO.getItems().stream()
                .mapToInt(OrderItemDTO::getSubtotal)
                .sum();
        order.setTotal_amount(calculatedTotal);
        Order savedOrder = ordersRepository.save(order);
        List<OrderItem> orderItemsList = new ArrayList<>();
        for (OrderItemDTO itemDTO : orderDTO.getItems()) {
            OrderItem item = new OrderItem();
            item.setOrder(savedOrder);
            //Lay Thong Tin San Pham Tu Co So Du Lieu
            Product product = productRepository.findById(itemDTO.getProductId())
                            .orElseThrow(() -> new ResourceNotFoundException("Product not found with id: " + itemDTO.getProductId()));
            item.setProduct(product);
            item.setQuantity(itemDTO.getQuantity());
            item.setSubtotal(itemDTO.getSubtotal());
            item.setNotes(itemDTO.getNotes());
            orderItemsList.add(item);
        }
        // Lưu các items của đơn hàng
        orderItemRepository.saveAll(orderItemsList);
        // Gán items vào đơn hàng và trả về
        savedOrder.setItems(orderItemsList);
        return savedOrder;
    }
    @Override
    public Order updateOrder(Long id, OrderDTO orderDTO) {
        Order order = ordersRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Order Not Found"));
        modelMapper.typeMap(OrderDTO.class,Order.class)
                .addMappings(mapper -> mapper.skip(Order::setId));
        modelMapper.map(orderDTO, order);
        return ordersRepository.save(order);
    }

    @Override
    public void sortDeleteOrder(int id) {
        Order order = findById(id);
        ordersRepository.softDeleteById(id);
    }

    @Override
    public Order findById(long id) {
        return ordersRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found with ID: " + id));
    }
}
