package com.example.OrderCoffeeBE.Model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.DynamicUpdate;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@Table(name = "orders")
@DynamicUpdate
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @JoinColumn(name = "table_id", nullable = false)
    @ManyToOne
    private Tables table;
    private String status;
    @Column(name = "total_amount", nullable = false)
    private int total_amount;
    @CreationTimestamp
    private LocalDateTime createdAt;
    @Column(nullable = false, columnDefinition = "INT DEFAULT 0")
    private int deleted;
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<OrderItem> items;
}
