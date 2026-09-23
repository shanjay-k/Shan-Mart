package com.shanjay.mart.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.shanjay.mart.dao.BaseDAOTest;
import com.shanjay.mart.dao.CartDAO;
import com.shanjay.mart.dao.OrderDAO;
import com.shanjay.mart.dao.ProductDAO;
import com.shanjay.mart.dao.ReviewDAO;
import com.shanjay.mart.dao.UserDAO;
import com.shanjay.mart.model.Order;
import com.shanjay.mart.model.Product;

public class ShopServiceTest extends BaseDAOTest {
    private ShopService shopService;
    private ProductDAO productDAO;
    private CartDAO cartDAO;
    private OrderDAO orderDAO;
    private ReviewDAO reviewDAO;
    private UserDAO userDAO;

    private long buyerId;
    private long productId;

    @BeforeEach
    public void setup() throws Exception {
        productDAO = new ProductDAO(dataSource);
        cartDAO = new CartDAO(dataSource);
        orderDAO = new OrderDAO(dataSource);
        reviewDAO = new ReviewDAO(dataSource);
        userDAO = new UserDAO(dataSource);

        shopService = new ShopService(productDAO, cartDAO, orderDAO, reviewDAO);

        userDAO.create("Demo Seller", "seller@test.com", "hash", "SELLER");
        userDAO.create("Demo Buyer", "buyer@test.com", "hash", "BUYER");
        buyerId = userDAO.findByEmail("buyer@test.com").id;

        Product p = new Product();
        p.sellerId = 1;
        p.name = "Ergonomic Office Chair";
        p.description = "Adjustable lumbar support";
        p.price = new BigDecimal("8500.00");
        p.stockQty = 20;
        p.category = "Home & Kitchen";
        p.imageUrl = "https://images.unsplash.com/photo-1580481077195-c3a821a5060f";
        productDAO.add(p);
        productId = productDAO.search("Chair", "").get(0).id;
    }

    @Test
    public void testCheckoutWithShippingAndPaymentMethods() throws Exception {
        // 1. Add to cart
        shopService.addCart(buyerId, productId, 2);
        var cartItems = shopService.getCart(buyerId);
        assertEquals(1, cartItems.size());
        assertEquals(new BigDecimal("17000.00"), shopService.total(cartItems));

        // 2. Perform checkout with full order details and payment method
        long orderId = shopService.checkout(
            buyerId,
            "Demo Buyer",
            "9876543210",
            "123 Tech Park, GST Road",
            "Chennai",
            "600025",
            "UPI"
        );
        assertTrue(orderId > 0);

        // 3. Verify cart was cleared
        assertTrue(shopService.getCart(buyerId).isEmpty());

        // 4. Verify order stored correctly with shipping and payment info
        List<Order> buyerOrders = shopService.buyerOrders(buyerId);
        assertEquals(1, buyerOrders.size());
        Order placed = buyerOrders.get(0);
        assertEquals("Demo Buyer", placed.shippingName);
        assertEquals("9876543210", placed.shippingPhone);
        assertEquals("UPI", placed.paymentMethod);
        assertEquals("CONFIRMED", placed.status);
        assertNotNull(placed.items);
        assertEquals(1, placed.items.size());
        assertEquals("Ergonomic Office Chair", placed.items.get(0).productName);
        assertEquals(2, placed.items.get(0).quantity);

        // 5. Verify stock was reduced
        Product refreshed = productDAO.findById(productId);
        assertEquals(18, refreshed.stockQty);
    }

    @Test
    public void testCheckoutValidationEmptyCart() {
        assertThrows(IllegalArgumentException.class, () -> {
            shopService.checkout(buyerId, "Demo", "9876543210", "Address", "City", "600025", "CARD");
        });
    }

    @Test
    public void testReviewRatingValidation() {
        assertThrows(IllegalArgumentException.class, () -> {
            shopService.addReview(buyerId, productId, 6, "Invalid 6 stars");
        });
        assertThrows(IllegalArgumentException.class, () -> {
            shopService.addReview(buyerId, productId, 0, "Invalid 0 stars");
        });
    }
}
