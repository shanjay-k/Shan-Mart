<%@ page import="java.util.List,com.shanjay.mart.model.CartItem" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Top Header Bar -->
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/shop" class="brand-logo">
            🛒 SHAN MART
        </a>

        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">
                <span>📊</span> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/shop">
                <span>🛍️</span> Shop More
            </a>
            <a href="${pageContext.request.contextPath}/wishlist">
                <span>❤️</span> Wishlist
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

    <div class="wrap">
        <h2 style="margin-bottom: 24px;">Shopping Cart</h2>

        <% 
            List<CartItem> items = (List<CartItem>) request.getAttribute("items"); 
            if (items == null || items.isEmpty()) { 
        %>
            <div class="empty-state">
                <div class="empty-state-icon">🛒</div>
                <h3>Your cart is empty</h3>
                <p style="color: var(--text-muted); margin: 8px 0 24px 0;">Explore thousands of products with lowest prices and free delivery!</p>
                <a href="${pageContext.request.contextPath}/shop" class="btn">Start Shopping Now</a>
            </div>
        <% } else { %>
            <div class="cart-layout">
                <!-- Left: Cart Items List -->
                <div class="cart-items-card">
                    <h3 style="margin-bottom: 16px; border-bottom: 1px solid var(--border-color); padding-bottom: 12px;">
                        Cart Items (<%= items.size() %>)
                    </h3>

                    <% for (CartItem i : items) { %>
                        <div class="cart-item-row">
                            <div style="flex: 1;">
                                <h4 style="font-size: 1.05rem; margin-bottom: 4px;">
                                    <a href="${pageContext.request.contextPath}/product?id=<%= i.productId %>" style="color: inherit; text-decoration: none;">
                                        <%= i.name %>
                                    </a>
                                </h4>
                                <p style="color: var(--text-muted); font-size: 0.9rem;">
                                    Quantity: <b><%= i.quantity %></b>
                                </p>
                                <span class="free-delivery-badge" style="margin-top: 6px; display: inline-block;">Free Delivery</span>
                                <div style="margin-top: 4px;">
                                    <a href="${pageContext.request.contextPath}/product?id=<%= i.productId %>" style="font-size: 0.8rem; color: var(--primary); font-weight: 600;">
                                        View Details & Reviews →
                                    </a>
                                </div>
                            </div>

                            <div style="text-align: right; display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
                                <span style="font-size: 1.25rem; font-weight: 800; color: var(--text-heading);">
                                    ₹ <%= i.total() %>
                                </span>

                                <form method="post" action="${pageContext.request.contextPath}/cart" style="margin: 0; padding: 0; background: none; border: none;">
                                    <input type="hidden" name="productId" value="<%= i.productId %>">
                                    <input type="hidden" name="action" value="remove">
                                    <button type="submit" class="btn-outline" style="padding: 4px 12px; font-size: 0.82rem; border-color: #EF4444; color: #EF4444;">
                                        🗑️ Remove
                                    </button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Right: Price Details Box (Amazon / Meesho style) -->
                <div class="cart-summary-box">
                    <h3 style="margin-bottom: 16px; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;">
                        Price Details
                    </h3>

                    <div class="summary-line">
                        <span>Items Total (<%= items.size() %> items)</span>
                        <span>₹ <%= request.getAttribute("total") %></span>
                    </div>

                    <div class="summary-line">
                        <span>Delivery Charges</span>
                        <span style="color: var(--accent-green); font-weight: 700;">FREE</span>
                    </div>

                    <div class="summary-line">
                        <span>Discount / Savings</span>
                        <span style="color: var(--accent-green); font-weight: 700;">-₹ 0.00</span>
                    </div>

                    <div class="summary-total">
                        <span>Order Total</span>
                        <span style="color: var(--primary);">₹ <%= request.getAttribute("total") %></span>
                    </div>

                    <a href="${pageContext.request.contextPath}/checkout" class="btn full" style="margin-top: 24px; padding: 14px; font-size: 1.05rem; display: flex; align-items: center; justify-content: center;">
                        Proceed to Checkout & Address →
                    </a>

                    <div style="display: flex; align-items: center; justify-content: center; gap: 8px; margin-top: 16px; color: var(--text-muted); font-size: 0.8rem;">
                        <span>🔒</span> Safe and Secure Payments
                    </div>
                </div>
            </div>
        <% } %>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>
</body>
</html>

