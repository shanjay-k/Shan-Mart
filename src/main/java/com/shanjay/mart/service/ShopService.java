package com.shanjay.mart.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.shanjay.mart.dao.CartDAO;
import com.shanjay.mart.dao.OrderDAO;
import com.shanjay.mart.dao.ProductDAO;
import com.shanjay.mart.dao.ReviewDAO;
import com.shanjay.mart.dao.WishlistDAO;
import com.shanjay.mart.model.CartItem;
import com.shanjay.mart.model.Order;
import com.shanjay.mart.model.OrderItem;
import com.shanjay.mart.model.Product;
import com.shanjay.mart.model.Review;
import com.shanjay.mart.model.WishlistItem;

public class ShopService {
    private final ProductDAO products;
    private final CartDAO cart;
    private final OrderDAO orders;
    private final ReviewDAO reviews;
    private final WishlistDAO wishlist;

    public ShopService(ProductDAO p, CartDAO c, OrderDAO o) {
        this(p, c, o, null, null);
    }

    public ShopService(ProductDAO p, CartDAO c, OrderDAO o, ReviewDAO r) {
        this(p, c, o, r, null);
    }

    public ShopService(ProductDAO p, CartDAO c, OrderDAO o, ReviewDAO r, WishlistDAO w) {
        this.products = p;
        this.cart = c;
        this.orders = o;
        this.reviews = r;
        this.wishlist = w;
    }

    // --- Product Methods ---
    public List<Product> search(String q, String cat) throws Exception {
        return products.search(q, cat);
    }

    public Product getProduct(long id) throws Exception {
        return products.findById(id);
    }

    public List<Product> getSellerProducts(long sellerId) throws Exception {
        return products.findBySeller(sellerId);
    }

    public List<Product> getAllProducts() throws Exception {
        return products.all();
    }

    public List<Product> getRelatedProducts(long productId, String category, int limit) throws Exception {
        if (products != null) {
            return products.getRelated(category, productId, limit);
        }
        return List.of();
    }

    public void addProduct(Product p) throws Exception {
        if (p.name == null || p.name.trim().isEmpty()) {
            throw new IllegalArgumentException("Product name is required.");
        }
        if (p.price == null || p.price.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Price must be greater than zero.");
        }
        if (p.stockQty < 0) {
            throw new IllegalArgumentException("Stock quantity cannot be negative.");
        }
        products.add(p);
    }

    public void updateProduct(Product p) throws Exception {
        if (p.name == null || p.name.trim().isEmpty()) {
            throw new IllegalArgumentException("Product name is required.");
        }
        if (p.price == null || p.price.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Price must be greater than zero.");
        }
        if (p.stockQty < 0) {
            throw new IllegalArgumentException("Stock quantity cannot be negative.");
        }
        products.update(p);
    }

    public void deleteProduct(long id, long sellerId) throws Exception {
        products.delete(id, sellerId);
    }

    public void adminDeleteProduct(long id) throws Exception {
        products.adminDelete(id);
    }

    // --- Cart Methods ---
    public void addCart(long buyer, long product, int qty) throws Exception {
        if (qty < 1) throw new IllegalArgumentException("Quantity must be at least 1.");
        cart.add(buyer, product, qty);
    }

    public void removeCart(long b, long p) throws Exception {
        cart.remove(b, p);
    }

    public List<CartItem> getCart(long b) throws Exception {
        return cart.list(b);
    }

    public BigDecimal total(List<CartItem> a) {
        return a.stream().map(CartItem::total).reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // --- Wishlist Methods (O1) ---
    public void addWishlist(long buyerId, long productId) throws Exception {
        if (wishlist != null) {
            wishlist.add(buyerId, productId);
        }
    }

    public void removeWishlist(long buyerId, long productId) throws Exception {
        if (wishlist != null) {
            wishlist.remove(buyerId, productId);
        }
    }

    public List<WishlistItem> getWishlist(long buyerId) throws Exception {
        return wishlist != null ? wishlist.list(buyerId) : List.of();
    }

    public boolean isWishlisted(long buyerId, long productId) throws Exception {
        return wishlist != null && wishlist.isWishlisted(buyerId, productId);
    }

    public int getWishlistCount(long buyerId) throws Exception {
        return wishlist != null ? wishlist.count(buyerId) : 0;
    }

    public void moveWishlistToCart(long buyerId, long productId, int qty) throws Exception {
        addCart(buyerId, productId, qty > 0 ? qty : 1);
        if (wishlist != null) {
            wishlist.remove(buyerId, productId);
        }
    }

    // --- Checkout & Orders ---
    public long checkout(long buyerId, String shipName, String shipPhone, String shipAddress,
                         String shipCity, String shipPincode, String paymentMethod) throws Exception {
        List<CartItem> items = cart.list(buyerId);
        if (items.isEmpty()) {
            throw new IllegalArgumentException("Your shopping cart is empty.");
        }

        if (shipName == null || shipName.trim().isEmpty()) {
            throw new IllegalArgumentException("Customer name is required.");
        }
        if (shipPhone == null || shipPhone.trim().isEmpty()) {
            throw new IllegalArgumentException("Valid contact phone number is required.");
        }
        if (shipAddress == null || shipAddress.trim().isEmpty()) {
            throw new IllegalArgumentException("Delivery address is required.");
        }
        if (shipCity == null || shipCity.trim().isEmpty()) {
            throw new IllegalArgumentException("City is required.");
        }
        if (shipPincode == null || shipPincode.trim().isEmpty()) {
            throw new IllegalArgumentException("PIN code is required.");
        }

        String method = (paymentMethod == null || paymentMethod.trim().isEmpty()) ? "CARD" : paymentMethod.toUpperCase();
        String paymentStatus = "COD".equalsIgnoreCase(method) ? "PENDING_CASH" : "COMPLETED";

        List<Long> ids = new ArrayList<>();
        List<Long> sellers = new ArrayList<>();
        List<Integer> qty = new ArrayList<>();
        List<BigDecimal> prices = new ArrayList<>();

        for (CartItem i : items) {
            ids.add(i.productId);
            qty.add(i.quantity);
            prices.add(i.price);
            sellers.add(i.sellerId);
        }

        long orderId = orders.create(
            buyerId, total(items),
            shipName.trim(), shipPhone.trim(), shipAddress.trim(),
            shipCity.trim(), shipPincode.trim(),
            method, paymentStatus,
            ids, qty, prices, sellers
        );

        cart.clear(buyerId);
        return orderId;
    }

    public long checkout(long b) throws Exception {
        return checkout(b, "Valued Customer", "9876543210", "Main Street Address", "City", "600001", "CARD");
    }

    public List<Order> buyerOrders(long b) throws Exception {
        return orders.buyerOrders(b);
    }

    public List<Order> sellerOrders(long sellerId) throws Exception {
        return orders.sellerOrders(sellerId);
    }

    public List<Order> allOrders() throws Exception {
        return orders.all();
    }

    public void updateOrderStatus(long orderId, String status) throws Exception {
        orders.updateStatus(orderId, status);
    }

    // --- Reviews & Ratings (F8) ---
    public void addReview(long buyerId, long productId, int rating, String comment) throws Exception {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5 stars.");
        }
        if (reviews != null) {
            Review r = new Review(buyerId, productId, rating, comment != null ? comment.trim() : "");
            reviews.add(r);
        }
    }

    public List<Review> getProductReviews(long productId) throws Exception {
        return reviews != null ? reviews.findByProduct(productId) : List.of();
    }

    public double getProductAverageRating(long productId) throws Exception {
        return reviews != null ? reviews.getAverageRating(productId) : 0.0;
    }

    public int getProductReviewCount(long productId) throws Exception {
        return reviews != null ? reviews.getReviewCount(productId) : 0;
    }

    public Map<Long, Double> getAllProductRatings() throws Exception {
        return reviews != null ? reviews.getAllProductRatings() : Map.of();
    }

    public Map<Long, Integer> getAllProductReviewCounts() throws Exception {
        return reviews != null ? reviews.getAllProductReviewCounts() : Map.of();
    }

    // --- Dashboard & Profile Analytics ---
    public Map<String, Object> getBuyerStats(long buyerId) throws Exception {
        List<Order> myOrders = buyerOrders(buyerId);
        int orderCount = myOrders.size();
        BigDecimal totalSpent = myOrders.stream().map(o -> o.total).reduce(BigDecimal.ZERO, BigDecimal::add);
        int wishlistCount = getWishlistCount(buyerId);
        List<CartItem> cartItems = getCart(buyerId);
        int cartItemsCount = cartItems.size();

        Map<String, Object> stats = new HashMap<>();
        stats.put("orderCount", orderCount);
        stats.put("totalSpent", totalSpent);
        stats.put("wishlistCount", wishlistCount);
        stats.put("cartItemsCount", cartItemsCount);
        return stats;
    }

    public Map<String, Object> getSellerStats(long sellerId) throws Exception {
        List<Product> myProducts = getSellerProducts(sellerId);
        List<Order> incomingOrders = sellerOrders(sellerId);

        long lowStockCount = myProducts.stream().filter(p -> p.stockQty <= 5).count();
        BigDecimal totalRevenue = BigDecimal.ZERO;
        for (Order o : incomingOrders) {
            if (o.items != null) {
                for (OrderItem it : o.items) {
                    if (it.sellerId == sellerId) {
                        totalRevenue = totalRevenue.add(it.getSubtotal());
                    }
                }
            }
        }

        Map<String, Object> stats = new HashMap<>();
        stats.put("productCount", myProducts.size());
        stats.put("orderCount", incomingOrders.size());
        stats.put("totalRevenue", totalRevenue);
        stats.put("lowStockCount", lowStockCount);
        return stats;
    }

    public Map<String, Object> getAdminStats(int usersCount) throws Exception {
        List<Product> allP = getAllProducts();
        List<Order> allO = allOrders();
        BigDecimal gmv = allO.stream().map(o -> o.total).reduce(BigDecimal.ZERO, BigDecimal::add);

        Map<String, Object> stats = new HashMap<>();
        stats.put("usersCount", usersCount);
        stats.put("productsCount", allP.size());
        stats.put("ordersCount", allO.size());
        stats.put("gmv", gmv);
        return stats;
    }
}
