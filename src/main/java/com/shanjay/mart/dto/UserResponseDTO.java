package com.shanjay.mart.dto;

import com.shanjay.mart.model.User;

public class UserResponseDTO {
    public long id;
    public String name;
    public String email;
    public String role;

    public UserResponseDTO() {}

    public UserResponseDTO(long id, String name, String email, String role) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.role = role;
    }

    public static UserResponseDTO from(User user) {
        if (user == null) return null;
        return new UserResponseDTO(user.id, user.name, user.email, user.role);
    }
}
