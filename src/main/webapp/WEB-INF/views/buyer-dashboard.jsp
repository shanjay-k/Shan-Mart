<%@ page import="java.util.List,java.util.Map,com.shanjay.mart.model.Order,com.shanjay.mart.model.OrderItem,com.shanjay.mart.model.WishlistItem,com.shanjay.mart.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buyer Dashboard | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <% 
        User user = (User) session.getAttribute("user");
        Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
        List<Order> recentOrders = (List<Order>) request.getAttribute("recentOrders");
        List<WishlistItem> wishlistItems = (List<WishlistItem>) request.getAttribute("wishlistItems");
    %>

    <!-- Top Navigation Bar -->
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/shop" class="brand-logo">
            🛒 SHAN MART
        </a>

        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/shop">
                <span>🛍️</span> Shop Catalog
            </a>
            <a href="${pageContext.request.contextPath}/wishlist">
                <span>❤️</span> Wishlist
            </a>
            <a href="${pageContext.request.contextPath}/cart">
                <span>🛒</span> Cart
            </a>
            <a href="${pageContext.request.contextPath}/orders">
                <span>📦</span> Orders
            </a>
            <a href="${pageContext.request.contextPath}/profile">
                <span>👤</span> Profile
            </a>
            <a href="${pageContext.request.contextPath}/logout" style="color: #DC2626;">
                <span>🚪</span> Logout
            </a>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="wrap" style="max-width: 1140px; margin-top: 28px;">
        <!-- Welcome Hero Banner -->
        <div style="background: linear-gradient(135deg, #0F172A 0%, #1E293B 60%, #BE123C 100%); color: white; border-radius: var(--radius-lg); padding: 32px 36px; margin-bottom: 32px; box-shadow: var(--shadow-md); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
            <div>
                <span style="background: rgba(255,255,255,0.2); font-size: 0.8rem; font-weight: 700; padding: 4px 12px; border-radius: var(--radius-full); text-transform: uppercase; letter-spacing: 0.5px;">
                    Buyer Overview
                </span>
                <h1 style="color: white; font-size: 2rem; margin: 10px 0 6px 0;">Welcome back, <%= user != null ? user.name : "Customer" %>! 👋</h1>
                <p style="color: rgba(255,255,255,0.85); font-size: 0.95rem;">
                    Manage your marketplace purchases, track live shipping status, and review saved wishlist items.
                </p>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/shop" class="btn" style="background: white; color: var(--primary); font-weight: 700; padding: 12px 22px;">
                    🛍️ Start Shopping
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="btn-outline" style="border-color: white; color: white; padding: 12px 18px;">
                    👤 Edit Profile
                </a>
            </div>
        </div>

        <!-- 4 KPI Summary Cards -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(230px, 1fr)); gap: 20px; margin-bottom: 36px;">
            <div class="feature-box" style="padding: 22px;">
                <div class="feature-icon" style="background: var(--accent-green-bg); color: var(--accent-green);">📦</div>
                <div class="feature-text">
                    <h4 style="font-size: 1.4rem;"><%= stats != null ? stats.get("orderCount") : 0 %> Orders</h4>
                    <p>Total orders placed</p>
                </div>
            </div>

            <div class="feature-box" style="padding: 22px;">
                <div class="feature-icon" style="background: #E0E7FF; color: #3730A3;">💳</div>
                <div class="feature-text">
                    <h4 style="font-size: 1.4rem;">₹ <%= stats != null ? stats.get("totalSpent") : "0.00" %></h4>
                    <p>Total spend amount</p>
                </div>
            </div>

            <div class="feature-box" style="padding: 22px;">
                <div class="feature-icon" style="background: #FFF1F2; color: var(--primary);">❤️</div>
                <div class="feature-text">
                    <h4 style="font-size: 1.4rem;"><%= stats != null ? stats.get("wishlistCount") : 0 %> Saved</h4>
                    <p>Items in your wishlist</p>
                </div>
            </div>

            <div class="feature-box" style="padding: 22px;">
                <div class="feature-icon" style="background: #FEF3C7; color: #92400E;">🛒</div>
                <div class="feature-text">
                    <h4 style="font-size: 1.4rem;"><%= stats != null ? stats.get("cartItemsCount") : 0 %> Items</h4>
                    <p>Current shopping cart</p>
                </div>
            </div>
        </div>

        <!-- Two Column Layout: Recent Orders (Left) & Saved Wishlist (Right) -->
        <div style="display: grid; grid-template-columns: 1fr 380px; gap: 32px; align-items: flex-start; margin-bottom: 40px;">
            <!-- Left: Recent Orders -->
            <div class="card" style="max-width: 100%; box-shadow: var(--shadow-sm); padding: 26px;">
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-light); padding-bottom: 14px; margin-bottom: 20px;">
                    <div>
                        <h3 style="font-size: 1.2rem;">Recent Orders</h3>
                        <p style="font-size: 0.85rem; color: var(--text-muted); margin-top: 2px;">Your latest marketplace purchases</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/orders" style="font-size: 0.88rem; font-weight: 600;">
                        View All Orders →
                    </a>
                </div>

                <% if (recentOrders != null && !recentOrders.isEmpty()) { %>
                    <div style="display: flex; flex-direction: column; gap: 14px;">
                        <% for (Order o : recentOrders) { 
                            String statusBadge = "badge-pending";
                            if ("CONFIRMED".equalsIgnoreCase(o.status)) statusBadge = "badge-confirmed";
                            else if ("SHIPPED".equalsIgnoreCase(o.status)) statusBadge = "badge-shipped";
                            else if ("DELIVERED".equalsIgnoreCase(o.status)) statusBadge = "badge-delivered";
                            else if ("CANCELLED".equalsIgnoreCase(o.status)) statusBadge = "badge-cancelled";
                        %>
                            <div style="background: var(--bg-page); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 14px 18px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                                <div>
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <b>Order #<%= o.id %></b>
                                        <span class="badge-status <%= statusBadge %>">● <%= o.status %></span>
                                    </div>
                                    <div style="font-size: 0.82rem; color: var(--text-muted); margin-top: 4px;">
                                        Date: <%= o.createdAt != null ? o.createdAt.toString().substring(0, 10) : "Recent" %> · 
                                        Payment: <b><%= o.paymentMethod %></b>
                                    </div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-size: 1.15rem; font-weight: 800; color: var(--primary);">
                                        ₹ <%= o.total %>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/orders" style="font-size: 0.8rem; font-weight: 600; color: var(--text-heading); text-decoration: underline;">
                                        Track & Review →
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-state" style="margin: 0; padding: 32px 16px;">
                        <div class="empty-state-icon">📦</div>
                        <h4>No orders placed yet</h4>
                        <p style="color: var(--text-muted); font-size: 0.88rem; margin: 4px 0 16px 0;">Start exploring top authentic deals on SHAN MART</p>
                        <a href="${pageContext.request.contextPath}/shop" class="btn" style="padding: 8px 16px; font-size: 0.88rem;">Shop Catalog</a>
                    </div>
                <% } %>
            </div>

            <!-- Right: Saved Wishlist Preview -->
            <div class="card" style="max-width: 100%; box-shadow: var(--shadow-sm); padding: 26px;">
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-light); padding-bottom: 14px; margin-bottom: 20px;">
                    <div>
                        <h3 style="font-size: 1.2rem;">Wishlist Items</h3>
                        <p style="font-size: 0.85rem; color: var(--text-muted); margin-top: 2px;">Saved for later</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/wishlist" style="font-size: 0.88rem; font-weight: 600;">
                        View All →
                    </a>
                </div>

                <% if (wishlistItems != null && !wishlistItems.isEmpty()) { %>
                    <div style="display: flex; flex-direction: column; gap: 12px;">
                        <% for (WishlistItem it : wishlistItems) { 
                            String itImg = (it.productImageUrl != null && !it.productImageUrl.isBlank()) ? it.productImageUrl : "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600";
                        %>
                            <div style="display: flex; align-items: center; justify-content: space-between; padding: 10px; border-radius: var(--radius-sm); border: 1px solid var(--border-light); background: var(--bg-page); gap: 10px;">
                                <a href="${pageContext.request.contextPath}/product?id=<%= it.productId %>">
                                    <img src="<%= itImg %>" alt="<%= it.productName %>" style="width: 48px; height: 48px; object-fit: cover; border-radius: 4px; border: 1px solid var(--border-color);" onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600'">
                                </a>
                                <div style="flex: 1; min-width: 0;">
                                    <div style="font-size: 0.88rem; font-weight: 700; color: var(--text-heading); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                        <a href="${pageContext.request.contextPath}/product?id=<%= it.productId %>" style="color: inherit;">
                                            <%= it.productName %>
                                        </a>
                                    </div>
                                    <div style="font-size: 0.82rem; color: var(--primary); font-weight: 700;">
                                        ₹ <%= it.productPrice %>
                                    </div>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/wishlist" style="margin: 0; padding: 0; background: none; border: none;">
                                    <input type="hidden" name="action" value="moveToCart">
                                    <input type="hidden" name="productId" value="<%= it.productId %>">
                                    <button type="submit" class="btn" style="padding: 6px 10px; font-size: 0.78rem;">
                                        🛒
                                    </button>
                                </form>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-state" style="margin: 0; padding: 24px 14px;">
                        <div class="empty-state-icon" style="font-size: 2.2rem;">🤍</div>
                        <h4 style="font-size: 0.95rem;">No saved items</h4>
                        <p style="color: var(--text-muted); font-size: 0.82rem; margin: 4px 0 14px 0;">Save items to monitor prices and purchase later</p>
                        <a href="${pageContext.request.contextPath}/shop" class="btn" style="padding: 6px 14px; font-size: 0.82rem;">Explore Store</a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- AI Chatbot Floating Widget -->
    <script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>
</body>
</html>
