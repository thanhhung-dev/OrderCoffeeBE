package com.example.OrderCoffeeBE.Controller;

import com.example.OrderCoffeeBE.Dto.Request.ChangePasswordRequest;
import com.example.OrderCoffeeBE.Dto.Request.UpdateProfileRequest;
import com.example.OrderCoffeeBE.Dto.Response.MessageResponse;
import com.example.OrderCoffeeBE.Dto.Response.UserProfileResponse;
import com.example.OrderCoffeeBE.Dto.User.PostUserDTO;
import com.example.OrderCoffeeBE.Dto.User.UpdateUserDTO;
import com.example.OrderCoffeeBE.Model.User;
import com.example.OrderCoffeeBE.Service.UserService;
import com.example.OrderCoffeeBE.Service.impl.UserServiceImpl;
import com.example.OrderCoffeeBE.Util.Anotation.ApiMessage;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.service.spi.ServiceException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/users/profile")
@RequiredArgsConstructor
public class UserProfileController {

    private final UserService userService;

    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUserProfile(Authentication authentication) {
        try {
            String username = authentication.getName();
            log.info("Getting profile for authenticated user: {}", username);
            UserProfileResponse profile = userService.getUserProfile(username);
            return ResponseEntity.ok(profile);
        } catch (ServiceException e) {
            log.error("Error retrieving user profile: {}", e.getMessage());
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new MessageResponse(e.getMessage(), false));
        } catch (Exception e) {
            log.error("Unexpected error retrieving user profile", e);
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("An unexpected error occurred", false));
        }
    }

    @PutMapping("/me")
    public ResponseEntity<?> updateProfile(
            Authentication authentication,
            @Valid @RequestBody UpdateProfileRequest request) {
        try {
            String username = authentication.getName();
            log.info("Updating profile for user: {}", username);
            UserProfileResponse updatedProfile = userService.updateProfile(username, request);
            return ResponseEntity.ok(updatedProfile);
        } catch (ServiceException e) {
            log.error("Error updating user profile: {}", e.getMessage());
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new MessageResponse(e.getMessage(), false));
        } catch (Exception e) {
            log.error("Unexpected error updating user profile", e);
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("An unexpected error occurred", false));
        }
    }

    @PostMapping("/change-password")

    public ResponseEntity<?> changePassword(
            Authentication authentication,
            @Valid @RequestBody ChangePasswordRequest request) {
        try {
            String username = authentication.getName();
            log.info("Changing password for user: {}", username);
            MessageResponse response = userService.changePassword(username, request);
            return ResponseEntity.ok(response);
        } catch (ServiceException e) {
            log.error("Error changing password: {}", e.getMessage());
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new MessageResponse(e.getMessage(), false));
        } catch (Exception e) {
            log.error("Unexpected error changing password", e);
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("An unexpected error occurred", false));
        }
    }

    @PutMapping("/avatar")
    public ResponseEntity<?> updateAvatar(
            Authentication authentication,
            @RequestBody String avatarUrl) {
        try {
            String username = authentication.getName();
            log.info("Updating avatar for user: {}", username);
            MessageResponse response = userService.updateAvatar(username, avatarUrl);
            return ResponseEntity.ok(response);
        } catch (ServiceException e) {
            log.error("Error updating avatar: {}", e.getMessage());
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(new MessageResponse(e.getMessage(), false));
        } catch (Exception e) {
            log.error("Unexpected error updating avatar", e);
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("An unexpected error occurred", false));
        }
    }
}
