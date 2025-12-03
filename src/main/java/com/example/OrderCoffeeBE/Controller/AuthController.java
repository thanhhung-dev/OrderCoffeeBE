package com.example.OrderCoffeeBE.Controller;

import com.example.OrderCoffeeBE.Dto.Request.*;
import com.example.OrderCoffeeBE.Dto.Response.JwtResponse;
import com.example.OrderCoffeeBE.Dto.Response.MessageResponse;
import com.example.OrderCoffeeBE.Service.AuthService;
import com.example.OrderCoffeeBE.Util.Exception.AccountDeactivatedException;
import com.example.OrderCoffeeBE.Util.Exception.TokenRefreshException;
import com.example.OrderCoffeeBE.events.AuthenticationEvent;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
//http:localhost:8080/api/auth/login
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final ApplicationEventPublisher eventPublisher;

    @PostMapping("/login")
    public ResponseEntity<JwtResponse> login(
            @Valid @RequestBody LoginRequest loginRequest,
            HttpServletRequest request) {
        try {
            JwtResponse jwtResponse = authService.authenticateUser(loginRequest);
            // Publish successful login event
            eventPublisher.publishEvent(new AuthenticationEvent(
                    this,
                    loginRequest.getUsername(),
                    AuthenticationEvent.AuthEventType.LOGIN_SUCCESS,
                    "Login successful",
                    getClientIp(request)
            ));
            return ResponseEntity.ok(jwtResponse);
        } catch (AccountDeactivatedException e) {
            // Publish failed login event with specific reason
            eventPublisher.publishEvent(new AuthenticationEvent(
                    this,
                    loginRequest.getUsername(),
                    AuthenticationEvent.AuthEventType.LOGIN_FAILED,
                    "Account deactivated",
                    getClientIp(request)
            ));
            throw e;
        } catch (BadCredentialsException e) {
            // Publish failed login event
            eventPublisher.publishEvent(new AuthenticationEvent(
                    this,
                    loginRequest.getUsername(),
                    AuthenticationEvent.AuthEventType.LOGIN_FAILED,
                    "Invalid credentials",
                    getClientIp(request)
            ));
            throw e;
        }
    }

    @PostMapping("/register")
    public ResponseEntity<MessageResponse> register(
            @Valid @RequestBody RegisterRequest registerRequest,
            HttpServletRequest request) {
        MessageResponse response = authService.registerUser(registerRequest);

        if (response.isSuccess()) {
            eventPublisher.publishEvent(new AuthenticationEvent(
                    this,
                    registerRequest.getUsername(),
                    AuthenticationEvent.AuthEventType.REGISTER_SUCCESS,
                    "Registration successful",
                    getClientIp(request)
            ));
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/refresh")

    public ResponseEntity<JwtResponse> refreshToken(
            @Valid @RequestBody RefreshTokenRequest request,
            HttpServletRequest httpRequest) {
        try {
            JwtResponse response = authService.refreshToken(request);

            eventPublisher.publishEvent(new AuthenticationEvent(
                    this,
                    response.getUsername(),
                    AuthenticationEvent.AuthEventType.REFRESH_TOKEN,
                    "Token refreshed",
                    getClientIp(httpRequest)
            ));

            return ResponseEntity.ok(response);
        } catch (TokenRefreshException e) {
            eventPublisher.publishEvent(new AuthenticationEvent(
                    this,
                    "unknown",
                    AuthenticationEvent.AuthEventType.INVALID_TOKEN,
                    e.getMessage(),
                    getClientIp(httpRequest)
            ));
            throw e;
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<MessageResponse> logout(
            @RequestBody(required = false) LogoutRequest logoutRequest,
            HttpServletRequest request) {
        MessageResponse response = authService.logoutUser(logoutRequest);

        if (logoutRequest != null && logoutRequest.getUsername() != null) {
            eventPublisher.publishEvent(new AuthenticationEvent(
                    this,
                    logoutRequest.getUsername(),
                    AuthenticationEvent.AuthEventType.LOGOUT,
                    "User logged out",
                    getClientIp(request)
            ));
        }

        return ResponseEntity.ok(response);
    }

    @PostMapping("/revoke")
    public ResponseEntity<MessageResponse> revokeToken(
            @Valid @RequestBody RevokeTokenRequest request,
            HttpServletRequest httpRequest) {
        log.info("Token revocation request received");

        MessageResponse response = authService.revokeToken(request.getToken(), request.getReason());

        if (response.isSuccess()) {
            eventPublisher.publishEvent(new AuthenticationEvent(
                    this,
                    "token-user", // We don't expose the username for security reasons
                    AuthenticationEvent.AuthEventType.INVALID_TOKEN,
                    "Token revoked: " + (request.getReason() != null ? request.getReason() : "No reason provided"),
                    getClientIp(httpRequest)
            ));
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Helper method to get client IP address
    private String getClientIp(HttpServletRequest request) {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null) {
            return request.getRemoteAddr();
        }
        return xfHeader.split(",")[0];
    }
}
