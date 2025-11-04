package com.example.OrderCoffeeBE.Service.impl;

import com.example.OrderCoffeeBE.Dto.Order.OrderItemDTO;
import com.example.OrderCoffeeBE.Model.Order;
import com.example.OrderCoffeeBE.Model.OrderItem;
import com.example.OrderCoffeeBE.Model.Product;
import com.example.OrderCoffeeBE.Service.OrderItemService;
import com.example.OrderCoffeeBE.Util.Error.ResourceNotFoundException;
import com.example.OrderCoffeeBE.Util.Exception.DataNotFoundException;
import com.example.OrderCoffeeBE.Util.LocalizationUtils;
import com.example.OrderCoffeeBE.Util.MessageKeys;
import com.example.OrderCoffeeBE.repository.OrderItemRepository;
import com.example.OrderCoffeeBE.repository.OrdersRepository;
import com.example.OrderCoffeeBE.repository.ProductRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.aspectj.weaver.ast.Or;
import org.springframework.stereotype.Service;

import java.util.List;


@Service("OrderItemService")
@RequiredArgsConstructor
public class OrderItemServiceImpl implements OrderItemService {
    private final OrderItemRepository orderItemRepository;
    private final ProductRepository productRepository;
    private final OrdersRepository ordersRepository;
    private final LocalizationUtils localizationUtils;
    @Override
    public List<OrderItem> findAll() {
        return orderItemRepository.findAll();
    }

    @Override
    @Transactional
    public OrderItem createOrderItem(OrderItemDTO orderItemDTO) throws DataNotFoundException {
        // tìm xem orderId có tồn tại hay không
        Order order = ordersRepository.findById(orderItemDTO.getOrderId())
                .orElseThrow(() -> new DataNotFoundException(translate(MessageKeys.NOT_FOUND, orderItemDTO.getOrderId())));
        Product product = productRepository.findById(orderItemDTO.getProductId())
                .orElseThrow(() -> new DataNotFoundException(translate(MessageKeys.NOT_FOUND, orderItemDTO.getProductId())));

        OrderItem orderItem = OrderItem.builder()
                .order(order)
                .product(product)
                .subtotal(orderItemDTO.getSubtotal())
                .quantity(orderItemDTO.getQuantity())
                .notes(orderItemDTO.getNotes())
                .build();

        // lưu vào DB
        return orderItemRepository.save(orderItem);
    }

    @Override
    @Transactional
    public OrderItem updateOrderItem(Long id, OrderItemDTO orderItemDTO) {
        // tìm xem orderDetail có tồn tại hay không
        OrderItem existsOrderDetail = getOrderDetail(id);
        Order existsOrder = ordersRepository.findById(orderItemDTO.getOrderId())
                .orElseThrow(() -> new DataNotFoundException(translate(MessageKeys.NOT_FOUND, orderItemDTO.getOrderId())));
        Product existsProduct = productRepository.findById(orderItemDTO.getProductId())
                .orElseThrow(() -> new DataNotFoundException(translate(MessageKeys.NOT_FOUND, orderItemDTO.getProductId())));

        existsOrderDetail.setProduct(existsProduct);
        existsOrderDetail.setSubtotal(orderItemDTO.getSubtotal());
        existsOrderDetail.setQuantity(orderItemDTO.getQuantity());
        existsOrderDetail.setNotes(orderItemDTO.getNotes());
        existsOrderDetail.setId(id);
        existsOrderDetail.setOrder(existsOrder);
        return orderItemRepository.save(existsOrderDetail);
    }

    @Override
    @Transactional
    public void deleteOrderItem(long id) {
        orderItemRepository.deleteById(id);
    }

    @Override
    public OrderItem getOrderDetail(Long id) throws DataNotFoundException {
        return orderItemRepository.findById(id)
                .orElseThrow(() -> new DataNotFoundException(translate(MessageKeys.NOT_FOUND, id)));
    }
    @Override
    public List<OrderItem> findByOrderId(Long orderId) {
        return orderItemRepository.findByOrderId(orderId);
    }
    private String translate(String message, Object... listMessages) {
        return localizationUtils.getLocalizedMessage(message, listMessages);
    }
}
