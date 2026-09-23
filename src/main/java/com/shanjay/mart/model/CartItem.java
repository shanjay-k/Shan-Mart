package com.shanjay.mart.model;
import java.math.BigDecimal;
public class CartItem { public long id,productId,sellerId; public String name; public BigDecimal price; public int quantity; public BigDecimal total(){return price.multiply(BigDecimal.valueOf(quantity));} }
