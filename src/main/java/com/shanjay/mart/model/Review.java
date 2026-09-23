package com.shanjay.mart.model;

import java.sql.Timestamp;

public class Review {
    public long id;
    public long buyerId;
    public String buyerName;
    public long productId;
    public String productName;
    public int rating; // 1 to 5
    public String comment;
    public Timestamp createdAt;

    public Review() {}

    public Review(long buyerId, long productId, int rating, String comment) {
        this.buyerId = buyerId;
        this.productId = productId;
        this.rating = rating;
        this.comment = comment;
    }
}
