package com.shanjay.mart.model;

import java.math.BigDecimal;

public class OrderItem {
    public long id;
    public long orderId;
    public long productId;
    public long sellerId;
    public String productName;
    public String productImageUrl;
    public int quantity;
    public BigDecimal unitPrice;

    public BigDecimal getSubtotal() {
        return unitPrice != null ? unitPrice.multiply(BigDecimal.valueOf(quantity)) : BigDecimal.ZERO;
    }
}
