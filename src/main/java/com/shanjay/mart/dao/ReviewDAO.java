package com.shanjay.mart.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import com.shanjay.mart.model.Review;

public class ReviewDAO {
    private final DataSource ds;

    public ReviewDAO(DataSource ds) {
        this.ds = ds;
    }

    public void add(Review r) throws SQLException {
        String sql = "INSERT INTO reviews(buyer_id, product_id, rating, comment) VALUES(?,?,?,?)";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, r.buyerId);
            p.setLong(2, r.productId);
            p.setInt(3, r.rating);
            p.setString(4, r.comment);
            p.executeUpdate();
        }
    }

    public List<Review> findByProduct(long productId) throws SQLException {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.name as buyer_name, p.name as product_name " +
                     "FROM reviews r " +
                     "JOIN users u ON r.buyer_id = u.id " +
                     "JOIN products p ON r.product_id = p.id " +
                     "WHERE r.product_id = ? " +
                     "ORDER BY r.id DESC";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, productId);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.id = rs.getLong("id");
                    r.buyerId = rs.getLong("buyer_id");
                    r.buyerName = rs.getString("buyer_name");
                    r.productId = rs.getLong("product_id");
                    r.productName = rs.getString("product_name");
                    r.rating = rs.getInt("rating");
                    r.comment = rs.getString("comment");
                    r.createdAt = rs.getTimestamp("created_at");
                    list.add(r);
                }
            }
        }
        return list;
    }

    public double getAverageRating(long productId) throws SQLException {
        String sql = "SELECT AVG(CAST(rating AS DOUBLE)) FROM reviews WHERE product_id = ?";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, productId);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    double avg = rs.getDouble(1);
                    return rs.wasNull() ? 0.0 : Math.round(avg * 10.0) / 10.0;
                }
            }
        }
        return 0.0;
    }

    public int getReviewCount(long productId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reviews WHERE product_id = ?";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, productId);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public boolean hasReviewed(long buyerId, long productId) throws SQLException {
        String sql = "SELECT 1 FROM reviews WHERE buyer_id = ? AND product_id = ?";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setLong(1, buyerId);
            p.setLong(2, productId);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next();
            }
        }
    }

    public Map<Long, Double> getAllProductRatings() throws SQLException {
        Map<Long, Double> map = new HashMap<>();
        String sql = "SELECT product_id, AVG(CAST(rating AS DOUBLE)) as avg_rating FROM reviews GROUP BY product_id";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                double avg = Math.round(rs.getDouble("avg_rating") * 10.0) / 10.0;
                map.put(rs.getLong("product_id"), avg);
            }
        }
        return map;
    }

    public Map<Long, Integer> getAllProductReviewCounts() throws SQLException {
        Map<Long, Integer> map = new HashMap<>();
        String sql = "SELECT product_id, COUNT(*) as cnt FROM reviews GROUP BY product_id";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getLong("product_id"), rs.getInt("cnt"));
            }
        }
        return map;
    }
}
