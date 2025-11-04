package com.example.OrderCoffeeBE.Dto.Order;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

@Data
public class PostOrderDTO {
    @JsonProperty("table_id")
    private int table_id;
    private String status;
    private int totalAmount;
    private List<OrderItemDTO> items;
}
