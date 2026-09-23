package com.shanjay.mart.listener;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.shanjay.mart.util.Password;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class AppListener implements ServletContextListener {
    private HikariDataSource ds;

    @Override
    public void contextInitialized(ServletContextEvent e) {
        try {
            HikariConfig c = new HikariConfig();
            c.setDriverClassName("org.h2.Driver");
            c.setJdbcUrl("jdbc:h2:~/shan_mart_v7;MODE=MySQL");
            c.setUsername("sa");
            c.setPassword("");
            c.setMaximumPoolSize(10);
            ds = new HikariDataSource(c);
            e.getServletContext().setAttribute("ds", ds);
            runSchema();
            migrateSchema();
            seed();
            syncCatalog();
            seedReviews();
        } catch (Exception x) {
            throw new RuntimeException(x);
        }
    }

    private void runSchema() throws Exception {
        try (Connection cn = ds.getConnection();
             Statement st = cn.createStatement();
             InputStream in = getClass().getClassLoader().getResourceAsStream("schema.sql")) {
            if (in == null) throw new FileNotFoundException("schema.sql");
            String s = new String(in.readAllBytes(), StandardCharsets.UTF_8);
            for (String q : s.split(";")) {
                if (!q.trim().isEmpty()) st.execute(q);
            }
        }
    }

    private void migrateSchema() {
        // Safe schema migrations for existing databases
        String[] alterSqls = {
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS shipping_name VARCHAR(100)",
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS shipping_phone VARCHAR(20)",
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS shipping_address VARCHAR(300)",
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS shipping_city VARCHAR(100)",
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS shipping_pincode VARCHAR(20)",
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS payment_method VARCHAR(50) DEFAULT 'CARD'",
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS payment_status VARCHAR(20) DEFAULT 'COMPLETED'"
        };

        try (Connection c = ds.getConnection(); Statement st = c.createStatement()) {
            for (String sql : alterSqls) {
                try {
                    st.execute(sql);
                } catch (Exception ignored) {
                }
            }
        } catch (Exception ignored) {
        }
    }

    private static final String[] CATALOG_NAMES = {
        // Electronics
        "Smartphone Pro Max", "Wireless Noise-Cancelling Earbuds", "55-inch 4K Smart TV", "Gaming Laptop", "Smartwatch Series X",
        // Fashion
        "Men's Casual Oxford Shirt", "Breathable Running Shoes", "Travel Backpack", "Aviator Sunglasses", "Classic Leather Wallet",
        // Home & Kitchen
        "Programmable Coffee Maker", "Non-Stick Cookware Set", "Minimalist LED Desk Lamp", "High-Speed Digital Blender", "Premium Cotton Bedsheet",
        // Books
        "Java Programming Masterclass", "Atomic Habits", "Clean Code", "Design Patterns", "Professional Notebook Set",
        // Sports & Fitness
        "Adjustable Dumbbell Set", "Non-Slip Yoga Mat", "Whey Protein Isolate", "Speed Jump Rope", "Insulated Water Bottle"
    };

    private static final String[] CATALOG_CATEGORIES = {
        "Electronics", "Electronics", "Electronics", "Electronics", "Electronics",
        "Fashion", "Fashion", "Fashion", "Fashion", "Fashion",
        "Home & Kitchen", "Home & Kitchen", "Home & Kitchen", "Home & Kitchen", "Home & Kitchen",
        "Books", "Books", "Books", "Books", "Books",
        "Sports", "Sports", "Sports", "Sports", "Sports"
    };

    private static final double[] CATALOG_PRICES = {
        65000.00, 12999.00, 45000.00, 85000.00, 19999.00,
        1499.00, 3499.00, 2499.00, 999.00, 799.00,
        4999.00, 3999.00, 899.00, 5499.00, 1299.00,
        650.00, 450.00, 550.00, 700.00, 350.00,
        4500.00, 899.00, 2999.00, 299.00, 699.00
    };

    private static final String[] CATALOG_IMAGES = {
        // Electronics
        "https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=600",
        "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600",
        "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=600",
        "https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=600",
        "https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600",
        // Fashion
        "https://images.unsplash.com/photo-1596755094514-f87e32f6b717?w=600",
        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600",
        "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600",
        "https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=600",
        "https://images.unsplash.com/photo-1627123424574-724758594e93?w=600",
        // Home & Kitchen
        "https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=600",
        "https://images.unsplash.com/photo-1584990347449-a618236eee71?w=600",
        "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=600",
        "https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=600",
        "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=600",
        // Books
        "https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=600",
        "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600",
        "https://images.unsplash.com/photo-1512820790803-83ca734da794?w=600",
        "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=600",
        "https://images.unsplash.com/photo-1531346878377-a54bea8a2e10?w=600",
        // Sports
        "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=600",
        "https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=600",
        "https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=600",
        "https://images.unsplash.com/photo-1434596922112-19c563067271?w=600",
        "https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600"
    };

    private void seed() throws Exception {
        try (Connection c = ds.getConnection()) {
            if (count(c, "users") == 0) {
                addUser(c, "Demo Buyer", "buyer@shanjaymart.local", "1234", "BUYER");
                addUser(c, "Demo Seller", "seller@shanjaymart.local", "1234", "SELLER");
                addUser(c, "Administrator", "admin@shanjaymart.local", "1234", "ADMIN");
            }

            if (count(c, "products") == 0) {
                try (PreparedStatement p = c.prepareStatement(
                    "INSERT INTO products(seller_id,name,description,price,stock_qty,category,image_url) VALUES(?,?,?,?,?,?,?)")) {
                    for (int i = 0; i < CATALOG_NAMES.length; i++) {
                        p.setLong(1, 2); // Demo Seller ID
                        p.setString(2, CATALOG_NAMES[i]);
                        p.setString(3, "High quality authentic " + CATALOG_NAMES[i] + " with manufacturer warranty.");
                        p.setBigDecimal(4, BigDecimal.valueOf(CATALOG_PRICES[i]));
                        p.setInt(5, 50);
                        p.setString(6, CATALOG_CATEGORIES[i]);
                        p.setString(7, CATALOG_IMAGES[i]);
                        p.executeUpdate();
                    }
                }
            }
        }
    }

    private void syncCatalog() {
        // Guarantee that existing database records also get the exact matching images
        try (Connection c = ds.getConnection();
             PreparedStatement p = c.prepareStatement("UPDATE products SET image_url = ?, description = ? WHERE name = ?")) {
            for (int i = 0; i < CATALOG_NAMES.length; i++) {
                p.setString(1, CATALOG_IMAGES[i]);
                p.setString(2, "High quality authentic " + CATALOG_NAMES[i] + " with manufacturer warranty.");
                p.setString(3, CATALOG_NAMES[i]);
                p.executeUpdate();
            }
        } catch (Exception ignored) {
        }
    }

    private void seedReviews() {
        try (Connection c = ds.getConnection()) {
            if (count(c, "reviews") > 0) return;

            // Seed realistic reviews for items from Buyer (id=1)
            String[] reviewQueries = {
                "INSERT INTO reviews(buyer_id, product_id, rating, comment) SELECT 1, id, 5, 'Superb build quality! Exactly as described and delivered fast.' FROM products WHERE name = 'Smartphone Pro Max'",
                "INSERT INTO reviews(buyer_id, product_id, rating, comment) SELECT 1, id, 4, 'Great noise cancellation and deep bass. Very comfortable for long calls.' FROM products WHERE name = 'Wireless Noise-Cancelling Earbuds'",
                "INSERT INTO reviews(buyer_id, product_id, rating, comment) SELECT 1, id, 5, 'Vibrant 4K panel, smooth smart apps and great sound output.' FROM products WHERE name = '55-inch 4K Smart TV'",
                "INSERT INTO reviews(buyer_id, product_id, rating, comment) SELECT 1, id, 5, 'Top notch running shoes, perfectly cushioned and breathable fabric.' FROM products WHERE name = 'Breathable Running Shoes'",
                "INSERT INTO reviews(buyer_id, product_id, rating, comment) SELECT 1, id, 5, 'Must read for every developer. Clean Code completely reshapes your approach.' FROM products WHERE name = 'Clean Code'",
                "INSERT INTO reviews(buyer_id, product_id, rating, comment) SELECT 1, id, 4, 'Brews hot and aromatic coffee in minutes. Very easy to program and clean.' FROM products WHERE name = 'Programmable Coffee Maker'",
                "INSERT INTO reviews(buyer_id, product_id, rating, comment) SELECT 1, id, 5, 'Solid weights, good grip, and easy to adjust for daily workouts.' FROM products WHERE name = 'Adjustable Dumbbell Set'"
            };

            try (Statement st = c.createStatement()) {
                for (String q : reviewQueries) {
                    try {
                        st.execute(q);
                    } catch (Exception ignored) {
                    }
                }
            }
        } catch (Exception ignored) {
        }
    }

    private int count(Connection c, String t) throws Exception {
        try (PreparedStatement p = c.prepareStatement("SELECT COUNT(*) FROM " + t);
             ResultSet r = p.executeQuery()) {
            r.next();
            return r.getInt(1);
        }
    }

    private void addUser(Connection c, String n, String em, String pw, String role) throws Exception {
        try (PreparedStatement p = c.prepareStatement("INSERT INTO users(name,email,password_hash,role) VALUES(?,?,?,?)")) {
            p.setString(1, n);
            p.setString(2, em);
            p.setString(3, Password.hash(pw));
            p.setString(4, role);
            p.executeUpdate();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent e) {
        if (ds != null) ds.close();
    }
}