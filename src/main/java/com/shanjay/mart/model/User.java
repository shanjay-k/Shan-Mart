package com.shanjay.mart.model;

import java.sql.Timestamp;

public class User {
    public long id;
    public String name;
    public String email;
    public String passwordHash;
    public String role;
    public Timestamp createdAt;

    public User() {}

    public User(long id, String name, String email, String passwordHash, String role) {
        this(id, name, email, passwordHash, role, null);
    }

    public User(long id, String name, String email, String passwordHash, String role, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.createdAt = createdAt;
    }
}
