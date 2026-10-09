<%@ page import="java.util.List,com.shanjay.mart.model.User,com.shanjay.mart.model.Product,com.shanjay.mart.model.Order" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard & Moderation | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/dashboard" class="brand-logo">
            🛒 SHAN MART <span style="font-size: 0.85rem; font-weight: 600; color: #DC2626; background: #FEE2E2; padding: 3px 8px; border-radius: 4px; margin-left: 6px;">Admin Panel</span>
        </a>

        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/orders">
                <span>📦</span> All Customer Orders
            </a>
            <a href="${pageContext.request.contextPath}/shop">
                <span>🛍️</span> Storefront Preview
            </a>
            <a href="${pageContext.request.contextPath}/profile">
                <span>👤</span> Profile
            </a>
            <a href="${pageContext.request.contextPath}/logout" style="color: #DC2626;">
                <span>🚪</span> Logout
            </a>
        </div>
    </nav>

    <div class="wrap" style="max-width: 1140px;">
        <% String success = request.getParameter("success"); %>
        <% if ("1".equals(success)) { %>
            <div style="background: var(--accent-green-bg); border: 1.5px solid var(--accent-green); border-radius: var(--radius-sm); padding: 12px 18px; margin-bottom: 20px; color: var(--accent-green); font-weight: 600;">
                ✓ Admin moderation action applied successfully!
            </div>
        <% } %>

        <div style="margin-bottom: 24px;">
            <h2>Platform Administration & Moderation</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 4px;">
                F7 Admin Oversight: Audit registered users, manage listings, and supervise customer orders
            </p>
        </div>

        <% 
            List<User> users = (List<User>) request.getAttribute("users");
            List<Product> products = (List<Product>) request.getAttribute("products");
            List<Order> orders = (List<Order>) request.getAttribute("orders");
        %>

        <!-- KPI Summary Cards -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 32px;">
            <div class="feature-box">
                <div class="feature-icon" style="background: #E0E7FF; color: #3730A3;">👥</div>
                <div class="feature-text">
                    <h4><%= users != null ? users.size() : 0 %> Users</h4>
                    <p>Registered buyers & sellers</p>
                </div>
            </div>

            <div class="feature-box">
                <div class="feature-icon" style="background: var(--primary-light); color: var(--primary);">🛍️</div>
                <div class="feature-text">
                    <h4><%= products != null ? products.size() : 0 %> Products</h4>
                    <p>Active catalog listings</p>
                </div>
            </div>

            <div class="feature-box">
                <div class="feature-icon" style="background: var(--accent-green-bg); color: var(--accent-green);">📦</div>
                <div class="feature-text">
                    <h4><%= orders != null ? orders.size() : 0 %> Orders</h4>
                    <p>Total orders placed</p>
                </div>
            </div>
        </div>

        <!-- Section 1: Registered Users Audit (F7) -->
        <div class="card" style="max-width: 100%; box-shadow: var(--shadow-sm); padding: 24px; margin-bottom: 32px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; border-bottom: 1px solid var(--border-light); padding-bottom: 12px;">
                <h3>Registered User Accounts</h3>
                <span class="category-pill active"><%= users != null ? users.size() : 0 %> Accounts</span>
            </div>

            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Full Name</th>
                            <th>Email Address</th>
                            <th>Platform Role</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (users != null && !users.isEmpty()) { 
                            for (User u : users) { 
                                String roleBadge = "badge-pending";
                                if ("ADMIN".equalsIgnoreCase(u.role)) roleBadge = "badge-cancelled";
                                else if ("SELLER".equalsIgnoreCase(u.role)) roleBadge = "badge-shipped";
                                else if ("BUYER".equalsIgnoreCase(u.role)) roleBadge = "badge-confirmed";
                        %>
                            <tr>
                                <td>#<%= u.id %></td>
                                <td><b><%= u.name %></b></td>
                                <td><%= u.email %></td>
                                <td>
                                    <span class="badge-status <%= roleBadge %>"><%= u.role %></span>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Section 2: Product Catalog Moderation (F7) -->
        <div class="card" style="max-width: 100%; box-shadow: var(--shadow-sm); padding: 24px; margin-bottom: 32px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; border-bottom: 1px solid var(--border-light); padding-bottom: 12px;">
                <h3>Product Moderation & Audit</h3>
                <span class="category-pill active"><%= products != null ? products.size() : 0 %> Items</span>
            </div>

            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (products != null && !products.isEmpty()) { 
                            for (Product p : products) { 
                                String pImg = (p.imageUrl != null && !p.imageUrl.isBlank()) ? p.imageUrl : "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600";
                        %>
                            <tr>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <img src="<%= pImg %>" alt="<%= p.name %>" style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px; border: 1px solid var(--border-color);" onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600'">
                                        <div style="font-weight: 600; color: var(--text-heading);"><%= p.name %></div>
                                    </div>
                                </td>
                                <td><span class="category-tag"><%= p.category %></span></td>
                                <td><b>₹ <%= p.price %></b></td>
                                <td><%= p.stockQty %></td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/product" style="display: inline; margin: 0; padding: 0; background: none; border: none;" onsubmit="return confirm('Moderate/Delete listing: <%= p.name.replace("'", "\\'") %>?');">
                                        <input type="hidden" name="action" value="adminDelete">
                                        <input type="hidden" name="id" value="<%= p.id %>">
                                        <button type="submit" class="btn-outline" style="padding: 4px 10px; font-size: 0.8rem; border-color: #EF4444; color: #EF4444;">
                                            Remove ✕
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>
</body>
</html>

