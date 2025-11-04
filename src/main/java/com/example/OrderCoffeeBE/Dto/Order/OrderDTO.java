package com.example.OrderCoffeeBE.Dto.Order;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderDTO {
    private int id;
    @JsonProperty("table_id")
    private int table_id;
    private String status;
    private int totalAmount;
    private List<OrderItemDTO> items;
}
