package com.example.OrderCoffeeBE.Dto.Order;
import com.example.OrderCoffeeBE.Util.MessageKeys;
import jakarta.validation.constraints.Min;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class OrderItemDTO {
    @JsonProperty("order_id")
    @Min(value = 1, message = MessageKeys.ORDER_ID_REQUIRED)
    private Long orderId;
    @JsonProperty("product_id")
    @Min(value = 1, message = MessageKeys.PRODUCT_ID_REQUIRED)
    private Long productId;
    private int quantity;
    private int subtotal;
    private String notes;
}
