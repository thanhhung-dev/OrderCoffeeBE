package com.example.OrderCoffeeBE.Service;


import com.example.OrderCoffeeBE.Dto.Request.LoginRequest;
import com.example.OrderCoffeeBE.Dto.Request.LogoutRequest;
import com.example.OrderCoffeeBE.Dto.Request.RefreshTokenRequest;
import com.example.OrderCoffeeBE.Dto.Request.RegisterRequest;
import com.example.OrderCoffeeBE.Dto.Response.JwtResponse;
import com.example.OrderCoffeeBE.Dto.Response.MessageResponse;

public interface AuthService {
    JwtResponse authenticateUser(LoginRequest loginRequest);
    JwtResponse refreshToken(RefreshTokenRequest refreshTokenRequest);
    MessageResponse registerUser(RegisterRequest registerRequest);
    MessageResponse logoutUser(LogoutRequest logoutRequest);
    MessageResponse revokeToken(String token, String reason);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
}
