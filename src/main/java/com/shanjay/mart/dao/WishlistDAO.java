package com.shanjay.mart.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.shanjay.mart.model.WishlistItem;

public class WishlistDAO {
    private final DataSource ds;

    public WishlistDAO(DataSource ds) {
        this.ds = ds;
    }

    public void add(long buyerId, long productId) throws SQLException {
        if (isWishlisted(buyerId, productId)) {
            return;
        }
        String sql = "INSERT INTO wishlist_items(buyer_id, product_id) VALUES(?, ?)";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, buyerId);
            p.setLong(2, productId);
            p.executeUpdate();
        }
    }

    public void remove(long buyerId, long productId) throws SQLException {
        String sql = "DELETE FROM wishlist_items WHERE buyer_id = ? AND product_id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, buyerId);
            p.setLong(2, productId);
            p.executeUpdate();
        }
    }

    public boolean isWishlisted(long buyerId, long productId) throws SQLException {
        String sql = "SELECT 1 FROM wishlist_items WHERE buyer_id = ? AND product_id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, buyerId);
            p.setLong(2, productId);
            try (ResultSet r = p.executeQuery()) {
                return r.next();
            }
        }
    }

    public int count(long buyerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM wishlist_items WHERE buyer_id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, buyerId);
            try (ResultSet r = p.executeQuery()) {
                if (r.next()) {
                    return r.getInt(1);
                }
            }
        }
        return 0;
    }

    public List<WishlistItem> list(long buyerId) throws SQLException {
        List<WishlistItem> list = new ArrayList<>();
        String sql = "SELECT w.id, w.buyer_id, w.product_id, w.created_at, " +
                     "p.name AS product_name, p.description AS product_desc, " +
                     "p.price AS product_price, p.stock_qty, p.category, p.image_url " +
                     "FROM wishlist_items w " +
                     "JOIN products p ON w.product_id = p.id " +
                     "WHERE w.buyer_id = ? " +
                     "ORDER BY w.id DESC";

        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, buyerId);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    WishlistItem item = new WishlistItem(
                        r.getLong("id"),
                        r.getLong("buyer_id"),
                        r.getLong("product_id"),
                        r.getString("product_name"),
                        r.getString("product_desc"),
                        r.getBigDecimal("product_price"),
                        r.getInt("stock_qty"),
                        r.getString("category"),
                        r.getString("image_url"),
                        r.getTimestamp("created_at")
                    );
                    list.add(item);
                }
            }
        }
        return list;
    }

    public void clear(long buyerId) throws SQLException {
        String sql = "DELETE FROM wishlist_items WHERE buyer_id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, buyerId);
            p.executeUpdate();
        }
    }
}
