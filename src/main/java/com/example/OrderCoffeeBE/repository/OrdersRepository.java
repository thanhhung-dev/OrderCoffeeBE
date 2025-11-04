package com.example.OrderCoffeeBE.repository;

import com.example.OrderCoffeeBE.Model.Order;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface OrdersRepository extends JpaRepository<Order, Long> {
    @Modifying
    @Transactional
    @Query("UPDATE Order o SET o.deleted = 1 WHERE o.id = :orderId")
    void softDeleteById(int orderId);

    // Fetch all active orders (not deleted)
    @Query("SELECT o FROM Order o WHERE o.deleted = 0")
    List<Order> findAllNotDeleted();

    // Fetch all soft-deleted orders
    @Query("SELECT o FROM Order o WHERE o.deleted = 1")
    List<Order> findAllDeleted();
}
