package com.example.OrderCoffeeBE.Service.impl;

import com.example.OrderCoffeeBE.Dto.Order.OrderDTO;
import com.example.OrderCoffeeBE.Dto.Order.PostOrderDTO;
import com.example.OrderCoffeeBE.Dto.Order.PutOrderDTO;
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
import jakarta.transaction.Transactional;
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
    @Transactional
    public Order createOrder(PostOrderDTO orderDTO) {
        // 1. Validate input
        if(orderDTO == null || orderDTO.getItems() == null || orderDTO.getItems().isEmpty()) {
            throw new ResourceNotFoundException("Order and items are required");
        }

        // 2. Validate table
        Tables tables = tableRepository.findById(orderDTO.getTable_id())
                .orElseThrow(() -> new ResourceNotFoundException("Table Not Found"));

        // 3. Create order
        Order order = new Order();
        order.setTable(tables);
        order.setStatus("Pending");
        order.setDeleted(0);

        // 4. Create order items và TÍNH LẠI subtotal từ database
        List<OrderItem> orderItemsList = new ArrayList<>();
        int calculatedTotal = 0;

        for (OrderItemDTO itemDTO : orderDTO.getItems()) {
            // Validate quantity
            if(itemDTO.getQuantity() <= 0) {
                throw new IllegalArgumentException("Quantity must be greater than 0");
            }

            // Lấy thông tin sản phẩm từ database
            Product product = productRepository.findById(itemDTO.getProductId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "Product not found with id: " + itemDTO.getProductId()));

            // ✅ TÍNH LẠI subtotal từ giá trong database
            int subtotal = product.getPrice() * itemDTO.getQuantity();
            calculatedTotal += subtotal;

            OrderItem item = new OrderItem();
            item.setOrder(order); // Sẽ set lại sau khi save
            item.setProduct(product);
            item.setQuantity(itemDTO.getQuantity());
            item.setSubtotal(subtotal); // Dùng subtotal đã tính
            item.setNotes(itemDTO.getNotes());
            orderItemsList.add(item);
        }

        // 5. Set total và save order
        order.setTotal_amount(calculatedTotal);
        Order savedOrder = ordersRepository.save(order);

        // 6. Update order reference và save items
        orderItemsList.forEach(item -> item.setOrder(savedOrder));
        orderItemRepository.saveAll(orderItemsList);

        savedOrder.setItems(orderItemsList);
        return savedOrder;
    }
    @Override
    @Transactional
    public Order updateOrder(Long id, PutOrderDTO orderDTO) {
        // ===== VALIDATE =====
        if (orderDTO == null || orderDTO.getItems() == null || orderDTO.getItems().isEmpty()) {
            throw new IllegalArgumentException("Invalid order data");
        }

        // ===== TÌM ORDER =====
        Order order = ordersRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Order Not Found"));

        // ===== VALIDATE STATUS =====
        if ("Completed".equals(order.getStatus()) || "Cancelled".equals(order.getStatus())) {
            throw new IllegalStateException("Cannot update " + order.getStatus() + " order");
        }

        // ===== UPDATE BASI C FIELDS (Có thể dùng ModelMapper cho phần này) =====

        if (orderDTO.getStatus() != null) {
            order.setStatus(orderDTO.getStatus());
        }

        // ===== XỬ LÝ ITEMS (KHÔNG DÙNG ModelMapper) =====
        // Xóa items cũ
        orderItemRepository.deleteByOrderId(id);
        order.getItems().clear();

        // Tạo items mới và TÍNH GIÁ TỪ DATABASE
        List<OrderItem> newItems = new ArrayList<>();
        int calculatedTotal = 0;

        for (OrderItemDTO itemDTO : orderDTO.getItems()) {
            // Validate
            if (itemDTO.getQuantity() <= 0) {
                throw new IllegalArgumentException("Quantity must be > 0");
            }

            // Lấy product từ DB
            Product product = productRepository.findById(itemDTO.getProductId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "Product not found: " + itemDTO.getProductId()));

            // ✅ TÍNH GIÁ TỪ DATABASE - QUAN TRỌNG NHẤT!
            int subtotal = product.getPrice() * itemDTO.getQuantity();
            calculatedTotal += subtotal;

            // Tạo item
            OrderItem item = new OrderItem();
            item.setOrder(order);
            item.setProduct(product);
            item.setQuantity(itemDTO.getQuantity());
            item.setSubtotal(subtotal);
            item.setNotes(itemDTO.getNotes());

            newItems.add(item);
        }

        // Lưu items
        orderItemRepository.saveAll(newItems);

        // Update order
        order.setTotal_amount(calculatedTotal);
        order.setItems(newItems);

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
