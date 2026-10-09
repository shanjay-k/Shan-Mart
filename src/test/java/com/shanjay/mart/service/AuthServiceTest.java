package com.shanjay.mart.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.shanjay.mart.dao.UserDAO;
import com.shanjay.mart.model.User;
import com.shanjay.mart.util.Password;

public class AuthServiceTest {
    private UserDAO mockUserDAO;
    private AuthService authService;

    @BeforeEach
    void setUp() {
        mockUserDAO = mock(UserDAO.class);
        authService = new AuthService(mockUserDAO);
    }

    @Test
    void testLogin_Success() throws Exception {
        String hashedPw = Password.hash("secret123");
        User dummyUser = new User(1L, "Alice", "alice@example.com", hashedPw, "BUYER");

        when(mockUserDAO.findByEmail("alice@example.com")).thenReturn(dummyUser);

        User loggedIn = authService.login("alice@example.com", "secret123");
        assertNotNull(loggedIn);
        assertEquals("Alice", loggedIn.name);
        assertEquals("BUYER", loggedIn.role);
    }

    @Test
    void testLogin_InvalidPassword() throws Exception {
        String hashedPw = Password.hash("secret123");
        User dummyUser = new User(1L, "Alice", "alice@example.com", hashedPw, "BUYER");

        when(mockUserDAO.findByEmail("alice@example.com")).thenReturn(dummyUser);

        User loggedIn = authService.login("alice@example.com", "wrongpassword");
        assertNull(loggedIn);
    }

    @Test
    void testRegister_Success() throws Exception {
        when(mockUserDAO.emailExists("bob@example.com")).thenReturn(false);

        authService.register("Bob Smith", "bob@example.com", "password123", "SELLER");
        verify(mockUserDAO).create(anyString(), anyString(), anyString(), anyString());
    }

    @Test
    void testRegister_DuplicateEmail() throws Exception {
        when(mockUserDAO.emailExists("existing@example.com")).thenReturn(true);

        Exception ex = assertThrows(IllegalArgumentException.class, () -> {
            authService.register("Existing User", "existing@example.com", "password123", "BUYER");
        });

        assertTrue(ex.getMessage().contains("already registered"));
    }

    @Test
    void testUpdateProfile_Success() throws Exception {
        authService.updateProfile(1L, "Alice Updated");
        verify(mockUserDAO).updateName(1L, "Alice Updated");
    }

    @Test
    void testChangePassword_Success() throws Exception {
        String oldHash = Password.hash("oldPassword123");
        User user = new User(1L, "Alice", "alice@example.com", oldHash, "BUYER");
        when(mockUserDAO.findById(1L)).thenReturn(user);

        authService.changePassword(1L, "oldPassword123", "newPassword456");
        verify(mockUserDAO).updatePassword(org.mockito.ArgumentMatchers.eq(1L), anyString());
    }

    @Test
    void testChangePassword_WrongCurrentPassword() throws Exception {
        String oldHash = Password.hash("oldPassword123");
        User user = new User(1L, "Alice", "alice@example.com", oldHash, "BUYER");
        when(mockUserDAO.findById(1L)).thenReturn(user);

        assertThrows(IllegalArgumentException.class, () -> {
            authService.changePassword(1L, "wrongOldPassword", "newPassword456");
        });
    }
}

