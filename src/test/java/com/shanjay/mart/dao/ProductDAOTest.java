package com.shanjay.mart.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.math.BigDecimal;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.shanjay.mart.model.Product;

public class ProductDAOTest extends BaseDAOTest {
    private ProductDAO productDAO;
    private UserDAO userDAO;

    @BeforeEach
    public void initDAO() throws Exception {
        productDAO = new ProductDAO(dataSource);
        userDAO = new UserDAO(dataSource);
        userDAO.create("Seller Demo", "seller.test@example.com", "hash", "SELLER");
    }

    @Test
    public void testAddAndSearchProduct() throws Exception {
        Product p = new Product();
        p.sellerId = 1;
        p.name = "Noise-Cancelling Headphones";
        p.description = "Deep sound and comfortable fit";
        p.price = new BigDecimal("4999.00");
        p.stockQty = 25;
        p.category = "Electronics";
        p.imageUrl = "https://images.unsplash.com/photo-1505740420928-5e560c06d30e";
        productDAO.add(p);

        List<Product> results = productDAO.search("Headphones", "Electronics");
        assertEquals(1, results.size());
        assertEquals("Noise-Cancelling Headphones", results.get(0).name);

        Product found = productDAO.findById(results.get(0).id);
        assertNotNull(found);
        assertEquals(25, found.stockQty);

        // Test update
        found.stockQty = 30;
        productDAO.update(found);
        Product updated = productDAO.findById(found.id);
        assertEquals(30, updated.stockQty);
    }
}
