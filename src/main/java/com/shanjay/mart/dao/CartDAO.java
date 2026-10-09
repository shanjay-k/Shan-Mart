package com.shanjay.mart.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.shanjay.mart.model.CartItem;

public class CartDAO {
    private final DataSource ds;

    public CartDAO(DataSource ds) {
        this.ds = ds;
    }

    public List<CartItem> list(long buyerId) throws SQLException {
        List<CartItem> items = new ArrayList<>();
        String query = "SELECT c.id, c.product_id, p.seller_id, p.name, p.price, c.quantity " +
                       "FROM cart_items c JOIN products p ON p.id = c.product_id WHERE c.buyer_id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(query)) {
            p.setLong(1, buyerId);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    CartItem item = new CartItem();
                    item.id = r.getLong(1);
                    item.productId = r.getLong(2);
                    item.sellerId = r.getLong(3);
                    item.name = r.getString(4);
                    item.price = r.getBigDecimal(5);
                    item.quantity = r.getInt(6);
                    items.add(item);
                }
            }
        }
        return items;
    }

    public void add(long buyerId, long productId, int quantity) throws SQLException {
        String query = "MERGE INTO cart_items(buyer_id, product_id, quantity) KEY(buyer_id, product_id) " +
                       "VALUES(?, ?, COALESCE((SELECT quantity FROM cart_items WHERE buyer_id = ? AND product_id = ?), 0) + ?)";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(query)) {
            p.setLong(1, buyerId);
            p.setLong(2, productId);
            p.setLong(3, buyerId);
            p.setLong(4, productId);
            p.setInt(5, quantity);
            p.executeUpdate();
        }
    }

    public void remove(long buyerId, long productId) throws SQLException {
        String query = "DELETE FROM cart_items WHERE buyer_id = ? AND product_id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(query)) {
            p.setLong(1, buyerId);
            p.setLong(2, productId);
            p.executeUpdate();
        }
    }

    public void clear(long buyerId) throws SQLException {
        String query = "DELETE FROM cart_items WHERE buyer_id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement(query)) {
            p.setLong(1, buyerId);
            p.executeUpdate();
        }
    }
}
