package com.shanjay.mart.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.shanjay.mart.model.User;

public class UserDAO {
    private final DataSource ds;

    public UserDAO(DataSource ds) {
        this.ds = ds;
    }

    public User findByEmail(String email) throws SQLException {
        String query = "SELECT * FROM users WHERE email = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(query)) {
            p.setString(1, email);
            try (ResultSet r = p.executeQuery()) {
                if (r.next()) {
                    return map(r);
                }
            }
        }
        return null;
    }

    public User findById(long id) throws SQLException {
        String query = "SELECT * FROM users WHERE id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(query)) {
            p.setLong(1, id);
            try (ResultSet r = p.executeQuery()) {
                if (r.next()) {
                    return map(r);
                }
            }
        }
        return null;
    }

    public boolean emailExists(String email) throws SQLException {
        return findByEmail(email) != null;
    }

    public void create(String name, String email, String passwordHash, String role) throws SQLException {
        String query = "INSERT INTO users(name, email, password_hash, role) VALUES(?, ?, ?, ?)";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(query)) {
            p.setString(1, name);
            p.setString(2, email);
            p.setString(3, passwordHash);
            p.setString(4, role);
            p.executeUpdate();
        }
    }

    public void updateName(long id, String name) throws SQLException {
        String query = "UPDATE users SET name = ? WHERE id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(query)) {
            p.setString(1, name);
            p.setLong(2, id);
            p.executeUpdate();
        }
    }

    public void updatePassword(long id, String passwordHash) throws SQLException {
        String query = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(query)) {
            p.setString(1, passwordHash);
            p.setLong(2, id);
            p.executeUpdate();
        }
    }

    public List<User> all() throws SQLException {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users ORDER BY id";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(query);
             ResultSet r = p.executeQuery()) {
            while (r.next()) {
                users.add(map(r));
            }
        }
        return users;
    }

    private User map(ResultSet r) throws SQLException {
        Timestamp createdAt = null;
        try {
            createdAt = r.getTimestamp("created_at");
        } catch (SQLException ignored) {
        }
        return new User(
            r.getLong("id"),
            r.getString("name"),
            r.getString("email"),
            r.getString("password_hash"),
            r.getString("role"),
            createdAt
        );
    }
}
