package com.shanjay.mart.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.shanjay.mart.model.Product;

public class ProductDAO {
    private final DataSource ds;

    public ProductDAO(DataSource ds) {
        this.ds = ds;
    }

    public List<Product> search(String q, String cat) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE (?='' OR LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)) AND (?='' OR category=?) ORDER BY id DESC";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            String x = q == null ? "" : q.trim();
            String like = "%" + x + "%";
            String cc = cat == null ? "" : cat.trim();
            p.setString(1, x);
            p.setString(2, like);
            p.setString(3, like);
            p.setString(4, cc);
            p.setString(5, cc);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    list.add(map(r));
                }
            }
        }
        return list;
    }

    public Product findById(long id) throws SQLException {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, id);
            try (ResultSet r = p.executeQuery()) {
                if (r.next()) return map(r);
            }
        }
        return null;
    }

    public List<Product> findBySeller(long sellerId) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE seller_id = ? ORDER BY id DESC";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, sellerId);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    list.add(map(r));
                }
            }
        }
        return list;
    }

    public List<Product> getRelated(String category, long excludeId, int limit) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category = ? AND id <> ? ORDER BY id DESC LIMIT ?";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, category != null ? category : "");
            p.setLong(2, excludeId);
            p.setInt(3, limit > 0 ? limit : 4);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    list.add(map(r));
                }
            }
        }
        return list;
    }

    public List<Product> all() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id DESC";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet r = p.executeQuery()) {
            while (r.next()) {
                list.add(map(r));
            }
        }
        return list;
    }

    public void add(Product x) throws SQLException {
        String sql = "INSERT INTO products(seller_id,name,description,price,stock_qty,category,image_url) VALUES(?,?,?,?,?,?,?)";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, x.sellerId);
            p.setString(2, x.name);
            p.setString(3, x.description);
            p.setBigDecimal(4, x.price);
            p.setInt(5, x.stockQty);
            p.setString(6, x.category);
            p.setString(7, x.imageUrl);
            p.executeUpdate();
        }
    }

    public void update(Product x) throws SQLException {
        String sql = "UPDATE products SET name=?, description=?, price=?, stock_qty=?, category=?, image_url=? WHERE id=? AND seller_id=?";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, x.name);
            p.setString(2, x.description);
            p.setBigDecimal(3, x.price);
            p.setInt(4, x.stockQty);
            p.setString(5, x.category);
            p.setString(6, x.imageUrl);
            p.setLong(7, x.id);
            p.setLong(8, x.sellerId);
            p.executeUpdate();
        }
    }

    public void delete(long id, long sellerId) throws SQLException {
        String sql = "DELETE FROM products WHERE id=? AND seller_id=?";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, id);
            p.setLong(2, sellerId);
            p.executeUpdate();
        }
    }

    public void adminDelete(long id) throws SQLException {
        String sql = "DELETE FROM products WHERE id=?";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, id);
            p.executeUpdate();
        }
    }

    private Product map(ResultSet r) throws SQLException {
        Product x = new Product();
        x.id = r.getLong("id");
        x.sellerId = r.getLong("seller_id");
        x.name = r.getString("name");
        x.description = r.getString("description");
        x.price = r.getBigDecimal("price");
        x.stockQty = r.getInt("stock_qty");
        x.category = r.getString("category");
        x.imageUrl = r.getString("image_url");
        return x;
    }
}
