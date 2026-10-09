-- Seed data script for SHAN MART
-- Pre-populates realistic demo users, catalog products, and initial reviews

INSERT INTO users (name, email, password_hash, role) VALUES
('Demo Buyer', 'buyer@shanjaymart.local', '$2a$10$wT0lD6d1k4X7w4mH4Yv5E.WnFv9hV0v0a7u0d0u0d0u0d0u0d0u0d', 'BUYER'),
('Demo Seller', 'seller@shanjaymart.local', '$2a$10$wT0lD6d1k4X7w4mH4Yv5E.WnFv9hV0v0a7u0d0u0d0u0d0u0d0u0d', 'SELLER'),
('Administrator', 'admin@shanjaymart.local', '$2a$10$wT0lD6d1k4X7w4mH4Yv5E.WnFv9hV0v0a7u0d0u0d0u0d0u0d0u0d', 'ADMIN');

INSERT INTO products (seller_id, name, description, price, stock_qty, category, image_url) VALUES
(2, 'Smartphone Pro Max', 'High quality authentic Smartphone Pro Max with manufacturer warranty.', 65000.00, 50, 'Electronics', 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=600'),
(2, 'Wireless Noise-Cancelling Earbuds', 'High quality authentic Wireless Noise-Cancelling Earbuds with manufacturer warranty.', 12999.00, 50, 'Electronics', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600'),
(2, '55-inch 4K Smart TV', 'High quality authentic 55-inch 4K Smart TV with manufacturer warranty.', 45000.00, 50, 'Electronics', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=600'),
(2, 'Gaming Laptop', 'High quality authentic Gaming Laptop with manufacturer warranty.', 85000.00, 50, 'Electronics', 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=600'),
(2, 'Smartwatch Series X', 'High quality authentic Smartwatch Series X with manufacturer warranty.', 19999.00, 50, 'Electronics', 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600'),
(2, 'Men''s Casual Oxford Shirt', 'High quality authentic Men''s Casual Oxford Shirt with manufacturer warranty.', 1499.00, 50, 'Fashion', 'https://images.unsplash.com/photo-1596755094514-f87e32f6b717?w=600'),
(2, 'Breathable Running Shoes', 'High quality authentic Breathable Running Shoes with manufacturer warranty.', 3499.00, 50, 'Fashion', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600'),
(2, 'Travel Backpack', 'High quality authentic Travel Backpack with manufacturer warranty.', 2499.00, 50, 'Fashion', 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600'),
(2, 'Aviator Sunglasses', 'High quality authentic Aviator Sunglasses with manufacturer warranty.', 999.00, 50, 'Fashion', 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=600'),
(2, 'Classic Leather Wallet', 'High quality authentic Classic Leather Wallet with manufacturer warranty.', 799.00, 50, 'Fashion', 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600');

INSERT INTO wishlist_items (buyer_id, product_id) VALUES
(1, 4),
(1, 5),
(1, 6);

