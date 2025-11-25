package com.example.OrderCoffeeBE.Service;


import com.example.OrderCoffeeBE.security.UserDetailsImpl;
import org.springframework.security.core.Authentication;

public interface TokenService {
    String generateAccessToken(UserDetailsImpl userPrincipal);
    String generateRefreshToken(UserDetailsImpl userPrincipal);
    String getUsernameFromToken(String token);
    boolean validateToken(String token);
    Authentication getAuthentication(String token);
}
