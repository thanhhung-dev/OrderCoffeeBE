package com.example.OrderCoffeeBE.Controller;

import com.example.OrderCoffeeBE.Dto.Order.OrderDTO;
import com.example.OrderCoffeeBE.Dto.Order.PostOrderDTO;
import com.example.OrderCoffeeBE.Dto.Order.PutOrderDTO;
import com.example.OrderCoffeeBE.Model.Order;
import com.example.OrderCoffeeBE.Service.impl.OrderServiceImpl;
import com.example.OrderCoffeeBE.Util.Anotation.ApiMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/order")
@RequiredArgsConstructor
public class OrderController {
    private final OrderServiceImpl orderService;

    @GetMapping
    @ApiMessage("Fetch All Order")
    public ResponseEntity<List<Order>> getAllOrder() {
        return ResponseEntity.status(HttpStatus.OK).body(this.orderService.findAll());
    }

    @GetMapping("/{id}")
    @ApiMessage("Fetch By Id")
    public ResponseEntity<Order> getOrderById(@PathVariable int id) {
       Order findOrder = this.orderService.findById(id);
       return ResponseEntity.ok(findOrder);
    }


    @PostMapping
    @ApiMessage("Create a Order")
    public ResponseEntity<Order> createOrder(@RequestBody PostOrderDTO order) {
        Order newOrder = this.orderService.createOrder(order);
        return ResponseEntity.status(HttpStatus.CREATED).body(newOrder);
    }

    @PutMapping("/{id}")
    @ApiMessage("Update a Order")
    public ResponseEntity<Order> updateOrder(@PathVariable Long id, @RequestBody PutOrderDTO order) {
        Order updateOrder = this.orderService.updateOrder(id, order);
        return ResponseEntity.status(HttpStatus.OK).body(updateOrder);
    }

    @DeleteMapping("/{id}")
    @ApiMessage("Delete a Order")
    public ResponseEntity<Order> deleteOrder(@PathVariable int id) {
        this.orderService.sortDeleteOrder(id);
        return ResponseEntity.ok(null);
    }
}
