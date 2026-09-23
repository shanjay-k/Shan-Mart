package com.shanjay.mart.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {
    public long id;
    public long buyerId;
    public BigDecimal total;
    public String status; // PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED
    public String shippingName;
    public String shippingPhone;
    public String shippingAddress;
    public String shippingCity;
    public String shippingPincode;
    public String paymentMethod; // CARD, UPI, NET_BANKING, COD
    public String paymentStatus; // COMPLETED, PENDING
    public Timestamp createdAt;
    public List<OrderItem> items = new ArrayList<>();
}
