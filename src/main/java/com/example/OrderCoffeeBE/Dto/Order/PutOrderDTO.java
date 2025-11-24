package com.example.OrderCoffeeBE.Dto.Order;

import lombok.Data;

import java.util.List;
@Data
public class PutOrderDTO {
    private int table_id;
    private String status;
    private List<OrderItemDTO> items;
}
