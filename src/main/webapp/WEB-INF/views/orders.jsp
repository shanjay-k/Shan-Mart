<%@ page import="java.util.List,com.shanjay.mart.model.Order,com.shanjay.mart.model.OrderItem,com.shanjay.mart.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders & History | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <% User user = (User) session.getAttribute("user"); %>
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/shop" class="brand-logo">
            🛒 SHAN MART
        </a>

        <div class="nav-links">
            <% if (user != null && "SELLER".equalsIgnoreCase(user.role)) { %>
                <a href="${pageContext.request.contextPath}/dashboard"><span>📊</span> Dashboard</a>
                <a href="${pageContext.request.contextPath}/shop"><span>🛍️</span> Storefront</a>
                <a href="${pageContext.request.contextPath}/profile"><span>👤</span> Profile</a>
            <% } else if (user != null && "ADMIN".equalsIgnoreCase(user.role)) { %>
                <a href="${pageContext.request.contextPath}/dashboard"><span>🛡️</span> Admin Panel</a>
                <a href="${pageContext.request.contextPath}/shop"><span>🛍️</span> Storefront</a>
                <a href="${pageContext.request.contextPath}/profile"><span>👤</span> Profile</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/dashboard"><span>📊</span> Dashboard</a>
                <a href="${pageContext.request.contextPath}/shop"><span>🛍️</span> Shop</a>
                <a href="${pageContext.request.contextPath}/wishlist"><span>❤️</span> Wishlist</a>
                <a href="${pageContext.request.contextPath}/cart"><span>🛒</span> Cart</a>
                <a href="${pageContext.request.contextPath}/profile"><span>👤</span> Profile</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/logout" style="color: #DC2626;">
                <span>🚪</span> Logout
            </a>
        </div>
    </nav>

    <div class="wrap" style="max-width: 980px;">
        <% String success = request.getParameter("success"); %>
        <% if (success != null && !success.isBlank()) { %>
            <div style="background: var(--accent-green-bg); border: 1.5px solid var(--accent-green); border-radius: var(--radius-md); padding: 18px 24px; margin-bottom: 24px; display: flex; align-items: center; gap: 14px;">
                <div style="font-size: 2rem;">🎉</div>
                <div>
                    <h3 style="color: var(--accent-green); margin-bottom: 2px;">Order #<%= success %> Placed Successfully!</h3>
                    <p style="color: var(--text-heading); font-size: 0.92rem;">
                        Thank you for shopping with SHAN MART. Your order details and payment have been confirmed.
                    </p>
                </div>
            </div>
        <% } %>

        <% if ("1".equals(request.getParameter("reviewed"))) { %>
            <div style="background: var(--accent-green-bg); border: 1.5px solid var(--accent-green); border-radius: var(--radius-md); padding: 14px 20px; margin-bottom: 24px; color: var(--accent-green); font-weight: 600;">
                ⭐ Thank you! Your product review and rating have been recorded.
            </div>
        <% } %>

        <div style="margin-bottom: 24px;">
            <h2>
                <% if (user != null && ("SELLER".equalsIgnoreCase(user.role) || "ADMIN".equalsIgnoreCase(user.role))) { %>
                    Customer Orders Management
                <% } else { %>
                    Your Orders & Purchases
                <% } %>
            </h2>
            <p style="color: var(--text-muted); font-size: 0.92rem; margin-top: 4px;">
                Track deliveries, inspect shipping details, view invoices, and review purchased products
            </p>
        </div>

        <% 
            List<Order> os = (List<Order>) request.getAttribute("orders"); 
            if (os == null || os.isEmpty()) { 
        %>
            <div class="empty-state">
                <div class="empty-state-icon">📦</div>
                <h3>No orders placed yet</h3>
                <p style="color: var(--text-muted); margin: 8px 0 20px 0;">You haven't placed any orders yet. Explore our top deals!</p>
                <a href="${pageContext.request.contextPath}/shop" class="btn">Start Shopping Now</a>
            </div>
        <% } else { %>
            <div class="orders-list">
                <% for (Order o : os) { 
                    String statusClass = "badge-pending";
                    if ("CONFIRMED".equalsIgnoreCase(o.status)) statusClass = "badge-confirmed";
                    else if ("SHIPPED".equalsIgnoreCase(o.status)) statusClass = "badge-shipped";
                    else if ("DELIVERED".equalsIgnoreCase(o.status)) statusClass = "badge-delivered";
                    else if ("CANCELLED".equalsIgnoreCase(o.status)) statusClass = "badge-cancelled";
                %>
                    <div class="order-card" style="flex-direction: column; align-items: stretch; gap: 16px;">
                        <!-- Order Header -->
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 12px; border-bottom: 1px solid var(--border-light); padding-bottom: 14px;">
                            <div>
                                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 4px;">
                                    <h3 style="font-size: 1.15rem; color: var(--text-heading);">Order #<%= o.id %></h3>
                                    <span class="badge-status <%= statusClass %>">● <%= o.status != null ? o.status : "CONFIRMED" %></span>
                                </div>
                                <div style="color: var(--text-muted); font-size: 0.85rem;">
                                    Placed on: <%= o.createdAt != null ? o.createdAt : "Recently" %>
                                </div>
                            </div>

                            <div style="text-align: right;">
                                <div style="font-size: 1.35rem; font-weight: 800; color: var(--primary);">
                                    ₹ <%= o.total %>
                                </div>
                                <div style="font-size: 0.8rem; color: var(--accent-green); font-weight: 600;">
                                    Free Delivery Included
                                </div>
                            </div>
                        </div>

                        <!-- Shipping & Payment Info Grid -->
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 16px; background: var(--bg-page); padding: 14px 18px; border-radius: var(--radius-sm); font-size: 0.88rem;">
                            <div>
                                <div style="font-weight: 700; color: var(--text-heading); margin-bottom: 4px;">📍 Delivery Address:</div>
                                <div style="color: var(--text-body); line-height: 1.4;">
                                    <b><%= o.shippingName != null && !o.shippingName.isBlank() ? o.shippingName : "Customer" %></b><br>
                                    <%= o.shippingAddress != null && !o.shippingAddress.isBlank() ? o.shippingAddress : "Registered Address" %><br>
                                    <%= o.shippingCity != null && !o.shippingCity.isBlank() ? o.shippingCity : "" %>
                                    <%= o.shippingPincode != null && !o.shippingPincode.isBlank() ? " - " + o.shippingPincode : "" %><br>
                                    Phone: <b><%= o.shippingPhone != null && !o.shippingPhone.isBlank() ? o.shippingPhone : "N/A" %></b>
                                </div>
                            </div>

                            <div>
                                <div style="font-weight: 700; color: var(--text-heading); margin-bottom: 4px;">💳 Payment Method:</div>
                                <div style="color: var(--text-body); line-height: 1.4;">
                                    Method: <span class="category-pill active" style="font-size: 0.78rem; padding: 2px 8px;"><%= o.paymentMethod != null ? o.paymentMethod : "CARD" %></span><br>
                                    Status: <b style="color: <%= "PENDING_CASH".equalsIgnoreCase(o.paymentStatus) ? "#D97706" : "var(--accent-green)" %>;">
                                        <%= "PENDING_CASH".equalsIgnoreCase(o.paymentStatus) ? "Pay on Delivery (Cash/UPI)" : "Payment Confirmed (Paid)" %>
                                    </b>
                                </div>

                                <!-- Status transition for Seller/Admin -->
                                <% if (user != null && ("SELLER".equalsIgnoreCase(user.role) || "ADMIN".equalsIgnoreCase(user.role))) { %>
                                    <form method="post" action="${pageContext.request.contextPath}/orders" style="margin-top: 10px; display: flex; gap: 6px; align-items: center;">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="orderId" value="<%= o.id %>">
                                        <select name="status" style="padding: 4px 8px; font-size: 0.82rem; border-radius: 4px; border: 1px solid var(--border-color);">
                                            <option value="CONFIRMED" <%= "CONFIRMED".equalsIgnoreCase(o.status) ? "selected" : "" %>>CONFIRMED</option>
                                            <option value="SHIPPED" <%= "SHIPPED".equalsIgnoreCase(o.status) ? "selected" : "" %>>SHIPPED</option>
                                            <option value="DELIVERED" <%= "DELIVERED".equalsIgnoreCase(o.status) ? "selected" : "" %>>DELIVERED</option>
                                            <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(o.status) ? "selected" : "" %>>CANCELLED</option>
                                        </select>
                                        <button type="submit" class="btn" style="padding: 4px 10px; font-size: 0.8rem;">Update</button>
                                    </form>
                                <% } %>
                            </div>
                        </div>

                        <!-- Order Items List -->
                        <% if (o.items != null && !o.items.isEmpty()) { %>
                            <div style="margin-top: 4px;">
                                <div style="font-size: 0.85rem; font-weight: 700; color: var(--text-muted); margin-bottom: 8px;">
                                    ORDERED ITEMS (<%= o.items.size() %>)
                                </div>
                                <div style="display: flex; flex-direction: column; gap: 8px;">
                                    <% for (OrderItem item : o.items) { 
                                        String itImg = (item.productImageUrl != null && !item.productImageUrl.isBlank()) ? item.productImageUrl : "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600";
                                    %>
                                        <div style="display: flex; align-items: center; justify-content: space-between; padding: 8px 12px; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: var(--radius-sm); gap: 12px; flex-wrap: wrap;">
                                            <div style="display: flex; align-items: center; gap: 12px; flex: 1; min-width: 200px;">
                                                <a href="${pageContext.request.contextPath}/product?id=<%= item.productId %>">
                                                    <img src="<%= itImg %>" alt="<%= item.productName %>" style="width: 44px; height: 44px; object-fit: cover; border-radius: 4px; border: 1px solid var(--border-color);" onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600'">
                                                </a>
                                                <div>
                                                    <div style="font-weight: 600; font-size: 0.92rem; color: var(--text-heading);">
                                                        <a href="${pageContext.request.contextPath}/product?id=<%= item.productId %>" style="color: inherit; text-decoration: none;">
                                                            <%= item.productName %>
                                                        </a>
                                                    </div>
                                                    <div style="font-size: 0.8rem; color: var(--text-muted);">
                                                        Qty: <b><%= item.quantity %></b> × ₹<%= item.unitPrice %>
                                                    </div>
                                                </div>
                                            </div>

                                            <div style="display: flex; align-items: center; gap: 14px;">
                                                <span style="font-weight: 700; font-size: 0.95rem; color: var(--text-heading);">
                                                    ₹ <%= item.getSubtotal() %>
                                                </span>

                                                <!-- Rate & Review Button for Buyer -->
                                                <% if (user != null && "BUYER".equalsIgnoreCase(user.role)) { %>
                                                    <button type="button" class="btn-outline" style="padding: 4px 12px; font-size: 0.8rem;" 
                                                            onclick="openRateModal(<%= item.productId %>, '<%= item.productName.replace("'", "\\'") %>')">
                                                        ★ Rate & Review
                                                    </button>
                                                <% } %>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Rating & Review Submission Modal -->
    <div id="rateModal" class="modal-overlay" onclick="if(event.target===this) closeRateModal()">
        <div class="modal-box">
            <button class="modal-close-btn" onclick="closeRateModal()">✕</button>
            <h3 id="rateModalTitle" style="margin-bottom: 6px; font-size: 1.25rem;">Rate & Review Product</h3>
            <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 20px;">Share your genuine experience to help other buyers</p>

            <form method="post" action="${pageContext.request.contextPath}/review">
                <input type="hidden" name="productId" id="rateProductId">
                <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/orders">

                <div class="field-group" style="align-items: center; text-align: center;">
                    <label style="font-size: 0.95rem; font-weight: 700;">Select Star Rating</label>
                    <div class="interactive-stars">
                        <input type="radio" id="star5" name="rating" value="5" required>
                        <label for="star5" title="5 Stars - Excellent">★</label>
                        <input type="radio" id="star4" name="rating" value="4">
                        <label for="star4" title="4 Stars - Very Good">★</label>
                        <input type="radio" id="star3" name="rating" value="3">
                        <label for="star3" title="3 Stars - Good">★</label>
                        <input type="radio" id="star2" name="rating" value="2">
                        <label for="star2" title="2 Stars - Fair">★</label>
                        <input type="radio" id="star1" name="rating" value="1">
                        <label for="star1" title="1 Star - Poor">★</label>
                    </div>
                </div>

                <div class="field-group">
                    <label for="revComment">Written Review (Optional)</label>
                    <textarea id="revComment" name="comment" rows="4" placeholder="What did you like or dislike? How was the quality, fit, or performance?"></textarea>
                </div>

                <button type="submit" class="btn full" style="margin-top: 16px; padding: 13px; font-size: 1rem;">
                    Submit Customer Review ⭐
                </button>
            </form>
        </div>
    </div>

    <script>
        function openRateModal(productId, productName) {
            document.getElementById('rateProductId').value = productId;
            document.getElementById('rateModalTitle').innerText = 'Rate & Review: ' + productName;
            document.getElementById('rateModal').classList.add('active');
        }

        function closeRateModal() {
            document.getElementById('rateModal').classList.remove('active');
        }
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>
</body>
</html>

