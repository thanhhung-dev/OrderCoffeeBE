package com.example.OrderCoffeeBE.Controller;

import com.example.OrderCoffeeBE.Dto.Order.OrderItemDTO;
import com.example.OrderCoffeeBE.Model.OrderItem;
import com.example.OrderCoffeeBE.Service.impl.OrderItemServiceImpl;
import com.example.OrderCoffeeBE.Util.Anotation.ApiMessage;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orderItems")
@RequiredArgsConstructor
public class OrderItemController {
    private final OrderItemServiceImpl orderItemService;

    @GetMapping
    @ApiMessage("Fetch OrderItem")
    public ResponseEntity<List<OrderItem>> getAllOrderItems() {
        return ResponseEntity.status(HttpStatus.OK).body(this.orderItemService.findAll());
    }

    @GetMapping("/{id}")
    @ApiMessage("Fetch By Id OrderItem")
    public ResponseEntity<OrderItem> getOrderItemById(@Valid @PathVariable("id") Long id) {
        OrderItem orderDetail = orderItemService.getOrderDetail(id);
        return ResponseEntity.ok(orderDetail);
    }

    @PostMapping
    @ApiMessage("Create a OrderItem")
    public ResponseEntity<OrderItem> createOrderItem(@Valid @RequestBody OrderItemDTO orderItemDTO) {
        OrderItem newOrder = this.orderItemService.createOrderItem(orderItemDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(newOrder);
    }

    @PutMapping("/{id}")
    @ApiMessage("update OrderItem")
    public ResponseEntity<OrderItem> updateOrderItem(@Valid @RequestBody OrderItemDTO orderItemDTO,
                                                     @PathVariable("id") Long id) {
        OrderItem updatedOrderItem = orderItemService.updateOrderItem(id,orderItemDTO);
        return ResponseEntity.status(HttpStatus.OK).body(updatedOrderItem);
    }

    @DeleteMapping("/{id}")
    @ApiMessage("Delete a OrderItem")
    public ResponseEntity<Void> deleteOrderItem(@PathVariable("id") Long id) {
        orderItemService.deleteOrderItem(id);
        return ResponseEntity.ok(null);
    }
}