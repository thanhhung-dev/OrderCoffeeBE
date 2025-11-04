package com.example.OrderCoffeeBE.Service.impl;
import com.example.OrderCoffeeBE.Dto.Product.PostProductDTO;
import com.example.OrderCoffeeBE.Dto.Product.ProductDTO;
import com.example.OrderCoffeeBE.Model.Category;
import com.example.OrderCoffeeBE.Model.Product;
import com.example.OrderCoffeeBE.Service.ProductService;
import com.example.OrderCoffeeBE.Util.Error.ResourceNotFoundException;
import com.example.OrderCoffeeBE.repository.CategoryRepository;
import com.example.OrderCoffeeBE.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.NoSuchElementException;

@RequiredArgsConstructor
@Service("productService")
public class ProductServiceImpl implements ProductService {
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final ModelMapper modelMapper;
    public static String uploadDirectory = System.getProperty("user.dir") + "/access/products";
    @Override
    public List<Product> findAll() {
        return productRepository.findAll();
    }

    @Override
    public Product findById(long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Product not found with id: " + id));
    }

    @Override
    public Product createProduct(PostProductDTO request ,MultipartFile image) throws IOException {
        Category category = categoryRepository.findById(request.getCategory_id())
                .orElseThrow(() -> new ResourceNotFoundException("Category not found"));
        String originalFilename = image.getOriginalFilename();
        Path path = Paths.get(uploadDirectory, originalFilename);
        Files.write(path, image.getBytes());
        // 2. Map DTO -> Entity
        Product product = new Product();
        product.setName(request.getName());
        product.setDescription(request.getDescription());
        product.setPrice(request.getPrice());
        product.setStatus(request.getStatus());
        product.setCategory(category);
        product.setImage(originalFilename);
        // 3. Save DB
        return productRepository.save(product);
    }

    @Override
    public Product updateProduct(Long id, ProductDTO productDTO, MultipartFile image) throws IOException {
        if(productDTO == null)
        {
            throw new ResourceNotFoundException("Product is required");
        }
        Category exitsCategory = categoryRepository.findById(productDTO.getCategory_id())
                .orElseThrow(() -> new ResourceNotFoundException("Category not found"));
        var dbProduct  = productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product Not Found"));
        //update Product
        if (image != null && !image.isEmpty()) {
            try {
                String fileName = image.getOriginalFilename();
                Path path = Paths.get(uploadDirectory, fileName);
                Files.write(path, image.getBytes());
                dbProduct.setImage(fileName);
            } catch (IOException e) {
                throw new ResourceNotFoundException("Error Save Image: " + e.getMessage());
            }
        }
        dbProduct.setName(productDTO.getName());
        dbProduct.setDescription(productDTO.getDescription());
        dbProduct.setPrice(productDTO.getPrice());
        dbProduct.setStatus(productDTO.getStatus());
        dbProduct.setCategory(exitsCategory);
        //convert to dto
        modelMapper.typeMap(ProductDTO.class, Product.class)
                .addMappings(mapper -> mapper.skip(Product::setId));
        modelMapper.map(productDTO, dbProduct);
        return productRepository.save(dbProduct);
    }

    @Override
    public void deleteProduct(long id) {
        var category = productRepository.findById(id).orElse(null);
        if (category == null) {
            throw new ResourceNotFoundException("Product not found");
        }
        this.productRepository.deleteById(id);
    }
}
