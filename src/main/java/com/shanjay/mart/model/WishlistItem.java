package com.shanjay.mart.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class WishlistItem {
    public long id;
    public long buyerId;
    public long productId;
    public String productName;
    public String productDescription;
    public BigDecimal productPrice;
    public int stockQty;
    public String productCategory;
    public String productImageUrl;
    public Timestamp createdAt;

    public WishlistItem() {}

    public WishlistItem(long id, long buyerId, long productId, String productName,
                        String productDescription, BigDecimal productPrice, int stockQty,
                        String productCategory, String productImageUrl, Timestamp createdAt) {
        this.id = id;
        this.buyerId = buyerId;
        this.productId = productId;
        this.productName = productName;
        this.productDescription = productDescription;
        this.productPrice = productPrice;
        this.stockQty = stockQty;
        this.productCategory = productCategory;
        this.productImageUrl = productImageUrl;
        this.createdAt = createdAt;
    }
}
