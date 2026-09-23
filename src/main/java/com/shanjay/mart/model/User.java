package com.shanjay.mart.model;
public class User { public long id; public String name,email,passwordHash,role; public User(){} public User(long id,String name,String email,String passwordHash,String role){this.id=id;this.name=name;this.email=email;this.passwordHash=passwordHash;this.role=role;} }
