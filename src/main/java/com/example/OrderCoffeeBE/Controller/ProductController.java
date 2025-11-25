package com.example.OrderCoffeeBE.Controller;

import com.example.OrderCoffeeBE.Dto.Product.PostProductDTO;
import com.example.OrderCoffeeBE.Dto.Product.ProductDTO;
import com.example.OrderCoffeeBE.Model.Product;
import com.example.OrderCoffeeBE.Dto.Response.ProductResponse;
import com.example.OrderCoffeeBE.Service.impl.ProductServiceImpl;
import com.example.OrderCoffeeBE.Util.Anotation.ApiMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {
    private final ProductServiceImpl productService;

    @GetMapping
    @ApiMessage("Fetch Product")
    public ResponseEntity<List<Product>> getAllProducts() {
        return ResponseEntity.status(HttpStatus.OK).body(this.productService.findAll());
    }

    @GetMapping("/{id}")
    @ApiMessage("Fetch By Id Product")
    public ResponseEntity<Product> getProductById(@PathVariable Integer id) {
        Product findProduct = this.productService.findById(id);
        return ResponseEntity.ok(findProduct);
    }

    @PostMapping
    @ApiMessage("Create Product")
    public ResponseEntity<ProductResponse> createProduct(
            @ModelAttribute PostProductDTO requestProduct,
            @RequestParam(value = "image", required = false) MultipartFile image
    ) throws IOException {
        Product savedProduct = productService.createProduct(requestProduct, image);
        ProductResponse response = new ProductResponse(savedProduct);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PatchMapping("/{id}")
    @ApiMessage("Update Product")
    public ResponseEntity<ProductResponse> updateProduct(
            @PathVariable long id,
            @ModelAttribute ProductDTO updateProductDTO,
            @RequestParam(value = "image", required = false) MultipartFile image
    ) throws IOException {
        Product updatedProduct = productService.updateProduct(id, updateProductDTO, image);
        ProductResponse response = new ProductResponse(updatedProduct);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @DeleteMapping("/{id}")
    @ApiMessage("Delete Product")
    public ResponseEntity<Void> deleteProduct(@PathVariable int id) {
       this.productService.deleteProduct(id);
       return ResponseEntity.ok(null);
    }
}