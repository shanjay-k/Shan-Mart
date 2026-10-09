package com.shanjay.mart.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.shanjay.mart.model.Product;
import com.shanjay.mart.model.WishlistItem;

public class WishlistDAOTest extends BaseDAOTest {
    private WishlistDAO wishlistDAO;
    private ProductDAO productDAO;
    private UserDAO userDAO;

    private long buyerId;
    private long productId;

    @BeforeEach
    public void setup() throws Exception {
        wishlistDAO = new WishlistDAO(dataSource);
        productDAO = new ProductDAO(dataSource);
        userDAO = new UserDAO(dataSource);

        userDAO.create("Seller 1", "seller@test.com", "hash", "SELLER");
        userDAO.create("Buyer 1", "buyer@test.com", "hash", "BUYER");
        buyerId = userDAO.findByEmail("buyer@test.com").id;

        Product p = new Product();
        p.sellerId = 1;
        p.name = "Wireless Keyboard";
        p.description = "Mechanical tactile switches";
        p.price = new BigDecimal("2499.00");
        p.stockQty = 15;
        p.category = "Electronics";
        p.imageUrl = "https://images.unsplash.com/photo-1587829741301-dc798b83add3";
        productDAO.add(p);
        productId = productDAO.search("Keyboard", "").get(0).id;
    }

    @Test
    public void testAddAndListWishlist() throws Exception {
        assertFalse(wishlistDAO.isWishlisted(buyerId, productId));
        assertEquals(0, wishlistDAO.count(buyerId));

        wishlistDAO.add(buyerId, productId);
        assertTrue(wishlistDAO.isWishlisted(buyerId, productId));
        assertEquals(1, wishlistDAO.count(buyerId));

        List<WishlistItem> list = wishlistDAO.list(buyerId);
        assertEquals(1, list.size());
        assertEquals("Wireless Keyboard", list.get(0).productName);
        assertEquals(new BigDecimal("2499.00"), list.get(0).productPrice);
    }

    @Test
    public void testRemoveFromWishlist() throws Exception {
        wishlistDAO.add(buyerId, productId);
        assertTrue(wishlistDAO.isWishlisted(buyerId, productId));

        wishlistDAO.remove(buyerId, productId);
        assertFalse(wishlistDAO.isWishlisted(buyerId, productId));
        assertEquals(0, wishlistDAO.count(buyerId));
    }
}
