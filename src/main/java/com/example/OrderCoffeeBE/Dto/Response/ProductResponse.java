package com.example.OrderCoffeeBE.Dto.Response;

import com.example.OrderCoffeeBE.Model.Product;
import lombok.Data;

@Data
public class ProductResponse {
    private int id;
    private String name;
    private String description;
    private int price;
    private int status;
    private int category_id;
    private String imageUrl;
    public ProductResponse(Product product) {
        this.id = product.getId();
        this.name = product.getName();
        this.description = product.getDescription();
        this.price = product.getPrice();
        this.status = product.getStatus();
        this.category_id = product.getCategory().getId();
        this.imageUrl = product.getImage();
    }
}