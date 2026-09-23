package com.shanjay.mart.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.shanjay.mart.model.Order;
import com.shanjay.mart.model.OrderItem;

public class OrderDAO {
    private final DataSource ds;

    public OrderDAO(DataSource ds) {
        this.ds = ds;
    }

    public long create(long buyer, BigDecimal total,
                       String shipName, String shipPhone, String shipAddress, String shipCity, String shipPincode,
                       String paymentMethod, String paymentStatus,
                       List<Long> pids, List<Integer> qtys, List<BigDecimal> prices, List<Long> sellers) throws SQLException {
        try (Connection c = ds.getConnection()) {
            c.setAutoCommit(false);
            try {
                long orderId;
                String orderSql = "INSERT INTO orders(buyer_id, total, status, shipping_name, shipping_phone, shipping_address, shipping_city, shipping_pincode, payment_method, payment_status) " +
                                  "VALUES(?, ?, 'CONFIRMED', ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement p = c.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                    p.setLong(1, buyer);
                    p.setBigDecimal(2, total);
                    p.setString(3, shipName != null ? shipName.trim() : "");
                    p.setString(4, shipPhone != null ? shipPhone.trim() : "");
                    p.setString(5, shipAddress != null ? shipAddress.trim() : "");
                    p.setString(6, shipCity != null ? shipCity.trim() : "");
                    p.setString(7, shipPincode != null ? shipPincode.trim() : "");
                    p.setString(8, paymentMethod != null ? paymentMethod : "CARD");
                    p.setString(9, paymentStatus != null ? paymentStatus : "COMPLETED");
                    p.executeUpdate();
                    try (ResultSet r = p.getGeneratedKeys()) {
                        r.next();
                        orderId = r.getLong(1);
                    }
                }

                // Insert items and decrease stock
                String itemSql = "INSERT INTO order_items(order_id, product_id, seller_id, quantity, unit_price) VALUES(?,?,?,?,?)";
                String stockSql = "UPDATE products SET stock_qty = GREATEST(0, stock_qty - ?) WHERE id = ?";

                try (PreparedStatement itemStmt = c.prepareStatement(itemSql);
                     PreparedStatement stockStmt = c.prepareStatement(stockSql)) {
                    for (int n = 0; n < pids.size(); n++) {
                        itemStmt.setLong(1, orderId);
                        itemStmt.setLong(2, pids.get(n));
                        itemStmt.setLong(3, sellers.get(n));
                        itemStmt.setInt(4, qtys.get(n));
                        itemStmt.setBigDecimal(5, prices.get(n));
                        itemStmt.addBatch();

                        stockStmt.setInt(1, qtys.get(n));
                        stockStmt.setLong(2, pids.get(n));
                        stockStmt.addBatch();
                    }
                    itemStmt.executeBatch();
                    stockStmt.executeBatch();
                }

                c.commit();
                return orderId;
            } catch (Exception e) {
                c.rollback();
                throw e;
            }
        }
    }

    public long create(long buyer, BigDecimal total, List<Long> pids, List<Integer> qtys, List<BigDecimal> prices, List<Long> sellers) throws SQLException {
        return create(buyer, total, "Customer", "N/A", "Standard Delivery", "N/A", "N/A", "CARD", "COMPLETED", pids, qtys, prices, sellers);
    }

    public List<Order> buyerOrders(long buyerId) throws SQLException {
        List<Order> list = findOrders("SELECT * FROM orders WHERE buyer_id = ? ORDER BY id DESC", buyerId);
        populateItems(list);
        return list;
    }

    public List<Order> sellerOrders(long sellerId) throws SQLException {
        String sql = "SELECT DISTINCT o.* FROM orders o " +
                     "JOIN order_items oi ON o.id = oi.order_id " +
                     "WHERE oi.seller_id = ? ORDER BY o.id DESC";
        List<Order> list = findOrders(sql, sellerId);
        populateItems(list);
        return list;
    }

    public List<Order> all() throws SQLException {
        List<Order> list = findOrders("SELECT * FROM orders ORDER BY id DESC");
        populateItems(list);
        return list;
    }

    public void updateStatus(long orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, status);
            p.setLong(2, orderId);
            p.executeUpdate();
        }
    }

    private List<Order> findOrders(String q, Object... args) throws SQLException {
        List<Order> list = new ArrayList<>();
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(q)) {
            for (int i = 0; i < args.length; i++) {
                p.setObject(i + 1, args[i]);
            }
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    Order o = new Order();
                    o.id = r.getLong("id");
                    o.buyerId = r.getLong("buyer_id");
                    o.total = r.getBigDecimal("total");
                    o.status = r.getString("status");
                    o.shippingName = getColStringSafe(r, "shipping_name");
                    o.shippingPhone = getColStringSafe(r, "shipping_phone");
                    o.shippingAddress = getColStringSafe(r, "shipping_address");
                    o.shippingCity = getColStringSafe(r, "shipping_city");
                    o.shippingPincode = getColStringSafe(r, "shipping_pincode");
                    o.paymentMethod = getColStringSafe(r, "payment_method");
                    o.paymentStatus = getColStringSafe(r, "payment_status");
                    o.createdAt = r.getTimestamp("created_at");
                    list.add(o);
                }
            }
        }
        return list;
    }

    private String getColStringSafe(ResultSet r, String col) {
        try {
            return r.getString(col);
        } catch (SQLException e) {
            return null;
        }
    }

    private void populateItems(List<Order> orders) throws SQLException {
        if (orders.isEmpty()) return;
        String sql = "SELECT oi.*, p.name as product_name, p.image_url " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.id " +
                     "WHERE oi.order_id = ?";
        try (Connection c = ds.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            for (Order o : orders) {
                p.setLong(1, o.id);
                try (ResultSet r = p.executeQuery()) {
                    while (r.next()) {
                        OrderItem item = new OrderItem();
                        item.id = r.getLong("id");
                        item.orderId = r.getLong("order_id");
                        item.productId = r.getLong("product_id");
                        item.sellerId = r.getLong("seller_id");
                        item.productName = r.getString("product_name");
                        item.productImageUrl = r.getString("image_url");
                        item.quantity = r.getInt("quantity");
                        item.unitPrice = r.getBigDecimal("unit_price");
                        o.items.add(item);
                    }
                }
            }
        }
    }
}
