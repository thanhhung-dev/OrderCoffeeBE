package com.example.OrderCoffeeBE.Service;

import com.example.OrderCoffeeBE.Dto.Request.ChangePasswordRequest;
import com.example.OrderCoffeeBE.Dto.Request.UpdateProfileRequest;
import com.example.OrderCoffeeBE.Dto.Response.MessageResponse;
import com.example.OrderCoffeeBE.Dto.Response.UserProfileResponse;
import com.example.OrderCoffeeBE.Dto.User.PostUserDTO;
import com.example.OrderCoffeeBE.Dto.User.UpdateUserDTO;
import com.example.OrderCoffeeBE.Model.User;

import java.util.List;
import java.util.UUID;

public interface UserService {
    User findByUsername(String username);
    User findById(int id);
    UserProfileResponse getUserProfile(String username);
    UserProfileResponse updateProfile(String username, UpdateProfileRequest request);
    MessageResponse changePassword(String username, ChangePasswordRequest request);
    MessageResponse updateAvatar(String username, String avatarUrl);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
}
