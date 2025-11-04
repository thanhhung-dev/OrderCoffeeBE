package com.example.OrderCoffeeBE.Model;

import com.example.OrderCoffeeBE.Util.Contant.GenderEnum;
import jakarta.persistence.*;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Entity
@Data
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @Column(name = "username", length = 100, nullable = false)
    private String username;
    @Column(name = "password", length = 255, nullable = false)
    private String password;
    @Column(name = "email", nullable = false, length = 50)
    private String email;
    @Column(name = "age", length = 3)
    private Integer age;
    @Column(name = "gender")
    @Enumerated(EnumType.ORDINAL) // MALE = 0 , FEMALE 1
    private GenderEnum gender;
    private boolean isActive = true;
    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;
    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', email='" + email + "'}";
    }
}
