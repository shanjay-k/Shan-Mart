package com.shanjay.mart.service;

import com.shanjay.mart.dao.UserDAO;
import com.shanjay.mart.model.User;
import com.shanjay.mart.util.Password;

public class AuthService {
    private final UserDAO dao;

    public AuthService(UserDAO d) {
        this.dao = d;
    }

    public User login(String email, String password) throws Exception {
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            return null;
        }
        User u = dao.findByEmail(email.trim());
        return (u != null && Password.matches(password, u.passwordHash)) ? u : null;
    }

    public void register(String name, String email, String password, String role) throws Exception {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("Full name is required.");
        }
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("Email address is required.");
        }
        if (password == null || password.length() < 4) {
            throw new IllegalArgumentException("Password must be at least 4 characters.");
        }
        String cleanRole = role != null ? role.trim().toUpperCase() : "";
        if (!"BUYER".equals(cleanRole) && !"SELLER".equals(cleanRole)) {
            throw new IllegalArgumentException("Role must be either BUYER or SELLER.");
        }
        if (dao.emailExists(email.trim())) {
            throw new IllegalArgumentException("Email address is already registered.");
        }
        dao.create(name.trim(), email.trim(), Password.hash(password), cleanRole);
    }

    public User getUser(long id) throws Exception {
        return dao.findById(id);
    }

    public void updateProfile(long id, String newName) throws Exception {
        if (newName == null || newName.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be empty.");
        }
        dao.updateName(id, newName.trim());
    }

    public void changePassword(long id, String currentPassword, String newPassword) throws Exception {
        if (currentPassword == null || currentPassword.isEmpty()) {
            throw new IllegalArgumentException("Current password is required.");
        }
        if (newPassword == null || newPassword.length() < 4) {
            throw new IllegalArgumentException("New password must be at least 4 characters long.");
        }
        User u = dao.findById(id);
        if (u == null) {
            throw new IllegalArgumentException("User account not found.");
        }
        if (!Password.matches(currentPassword, u.passwordHash)) {
            throw new IllegalArgumentException("Current password does not match.");
        }
        dao.updatePassword(id, Password.hash(newPassword));
    }
}
