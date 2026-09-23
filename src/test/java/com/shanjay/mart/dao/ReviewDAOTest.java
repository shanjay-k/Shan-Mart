package com.shanjay.mart.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.shanjay.mart.model.Product;
import com.shanjay.mart.model.Review;

public class ReviewDAOTest extends BaseDAOTest {
    private ReviewDAO reviewDAO;
    private ProductDAO productDAO;
    private UserDAO userDAO;
    private long buyerId;
    private long productId;

    @BeforeEach
    public void initDAO() throws Exception {
        reviewDAO = new ReviewDAO(dataSource);
        productDAO = new ProductDAO(dataSource);
        userDAO = new UserDAO(dataSource);

        userDAO.create("Seller Person", "seller.rev@example.com", "hash", "SELLER");
        userDAO.create("Buyer Person", "buyer.rev@example.com", "hash", "BUYER");
        buyerId = userDAO.findByEmail("buyer.rev@example.com").id;

        Product p = new Product();
        p.sellerId = 1;
        p.name = "Smart Fitness Band";
        p.price = new BigDecimal("1999.00");
        p.stockQty = 10;
        p.category = "Electronics";
        productDAO.add(p);
        productId = productDAO.search("Fitness", "").get(0).id;
    }

    @Test
    public void testAddAndCalculateAverageRating() throws Exception {
        Review r1 = new Review(buyerId, productId, 5, "Outstanding product, tracks heart rate accurately!");
        reviewDAO.add(r1);

        List<Review> reviews = reviewDAO.findByProduct(productId);
        assertEquals(1, reviews.size());
        assertEquals(5, reviews.get(0).rating);
        assertEquals("Buyer Person", reviews.get(0).buyerName);

        double avg = reviewDAO.getAverageRating(productId);
        assertEquals(5.0, avg);
        assertEquals(1, reviewDAO.getReviewCount(productId));
        assertTrue(reviewDAO.hasReviewed(buyerId, productId));
    }
}
