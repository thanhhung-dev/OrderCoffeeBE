package com.example.OrderCoffeeBE.Service;

import com.example.OrderCoffeeBE.Dto.Product.PostProductDTO;
import com.example.OrderCoffeeBE.Dto.Product.ProductDTO;
import com.example.OrderCoffeeBE.Model.Product;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
public interface ProductService {
    List<Product> findAll();
    Product findById(long id);
    Product createProduct(PostProductDTO request ,MultipartFile image) throws IOException;
    Product updateProduct(Long id, ProductDTO product, MultipartFile image) throws IOException;
    void deleteProduct(long id);
}
