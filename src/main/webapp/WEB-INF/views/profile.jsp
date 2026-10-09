<%@ page import="java.util.Map,com.shanjay.mart.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Account & Profile | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <% 
        User user = (User) request.getAttribute("userProfile");
        if (user == null) user = (User) session.getAttribute("user");
        Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    %>

    <!-- Top Navigation Bar -->
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/dashboard" class="brand-logo">
            🛒 SHAN MART
        </a>

        <div class="nav-links">
            <% if (user != null && "SELLER".equalsIgnoreCase(user.role)) { %>
                <a href="${pageContext.request.contextPath}/dashboard"><span>📊</span> Dashboard</a>
                <a href="${pageContext.request.contextPath}/orders"><span>📦</span> Orders</a>
                <a href="${pageContext.request.contextPath}/shop"><span>🛍️</span> Storefront</a>
            <% } else if (user != null && "ADMIN".equalsIgnoreCase(user.role)) { %>
                <a href="${pageContext.request.contextPath}/dashboard"><span>🛡️</span> Admin Panel</a>
                <a href="${pageContext.request.contextPath}/orders"><span>📦</span> Orders</a>
                <a href="${pageContext.request.contextPath}/shop"><span>🛍️</span> Storefront</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/dashboard"><span>📊</span> Dashboard</a>
                <a href="${pageContext.request.contextPath}/shop"><span>🛍️</span> Shop</a>
                <a href="${pageContext.request.contextPath}/wishlist"><span>❤️</span> Wishlist</a>
                <a href="${pageContext.request.contextPath}/cart"><span>🛒</span> Cart</a>
                <a href="${pageContext.request.contextPath}/orders"><span>📦</span> Orders</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/logout" style="color: #DC2626;">
                <span>🚪</span> Logout
            </a>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="wrap" style="max-width: 980px; margin-top: 28px;">
        <!-- Alerts -->
        <% if ("1".equals(request.getParameter("profileUpdated"))) { %>
            <div style="background: var(--accent-green-bg); border: 1.5px solid var(--accent-green); border-radius: var(--radius-sm); padding: 12px 18px; margin-bottom: 20px; color: var(--accent-green); font-weight: 600;">
                ✓ Profile details updated successfully!
            </div>
        <% } %>

        <% if ("1".equals(request.getParameter("passwordUpdated"))) { %>
            <div style="background: var(--accent-green-bg); border: 1.5px solid var(--accent-green); border-radius: var(--radius-sm); padding: 12px 18px; margin-bottom: 20px; color: var(--accent-green); font-weight: 600;">
                ✓ Password changed successfully! Please keep your new password safe.
            </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="error" style="margin-bottom: 20px;">
                ⚠️ <%= request.getParameter("error") %>
            </div>
        <% } %>

        <!-- User Identity Card -->
        <div class="card" style="max-width: 100%; box-shadow: var(--shadow-sm); padding: 28px; margin-bottom: 32px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 20px;">
                <div style="width: 72px; height: 72px; border-radius: 50%; background: var(--primary-light); color: var(--primary); font-size: 2.2rem; display: flex; align-items: center; justify-content: center; border: 2px solid var(--primary-border);">
                    👤
                </div>
                <div>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <h2 style="font-size: 1.45rem;"><%= user != null ? user.name : "User" %></h2>
                        <% 
                            String roleBadge = "badge-confirmed";
                            if (user != null && "ADMIN".equalsIgnoreCase(user.role)) roleBadge = "badge-cancelled";
                            else if (user != null && "SELLER".equalsIgnoreCase(user.role)) roleBadge = "badge-shipped";
                        %>
                        <span class="badge-status <%= roleBadge %>"><%= user != null ? user.role : "BUYER" %></span>
                    </div>
                    <p style="color: var(--text-muted); font-size: 0.92rem; margin-top: 2px;">
                        <%= user != null ? user.email : "" %> · User ID #<%= user != null ? user.id : 1 %>
                    </p>
                    <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">
                        Account Created: <b><%= user != null && user.createdAt != null ? user.createdAt.toString().substring(0, 10) : "Active Member" %></b>
                    </div>
                </div>
            </div>

            <div>
                <% if (user != null && "BUYER".equalsIgnoreCase(user.role)) { %>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn-outline" style="padding: 10px 18px;">
                        📊 Go to Buyer Dashboard
                    </a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn-outline" style="padding: 10px 18px;">
                        📊 Go to Central Dashboard
                    </a>
                <% } %>
            </div>
        </div>

        <!-- Role Activity Stats Box -->
        <% if (stats != null) { %>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 32px;">
                <% if (user != null && "BUYER".equalsIgnoreCase(user.role)) { %>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: var(--accent-green-bg); color: var(--accent-green);">📦</div>
                        <div class="feature-text">
                            <h4><%= stats.get("orderCount") %> Orders</h4>
                            <p>Purchases placed</p>
                        </div>
                    </div>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: #E0E7FF; color: #3730A3;">💳</div>
                        <div class="feature-text">
                            <h4>₹ <%= stats.get("totalSpent") %></h4>
                            <p>Lifetime spending</p>
                        </div>
                    </div>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: #FFF1F2; color: var(--primary);">❤️</div>
                        <div class="feature-text">
                            <h4><%= stats.get("wishlistCount") %> Saved</h4>
                            <p>Wishlist items</p>
                        </div>
                    </div>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: #FEF3C7; color: #92400E;">🛒</div>
                        <div class="feature-text">
                            <h4><%= stats.get("cartItemsCount") %> In Cart</h4>
                            <p>Active cart items</p>
                        </div>
                    </div>
                <% } else if (user != null && "SELLER".equalsIgnoreCase(user.role)) { %>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: var(--primary-light); color: var(--primary);">🛍️</div>
                        <div class="feature-text">
                            <h4><%= stats.get("productCount") %> Products</h4>
                            <p>Active listings</p>
                        </div>
                    </div>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: var(--accent-green-bg); color: var(--accent-green);">💰</div>
                        <div class="feature-text">
                            <h4>₹ <%= stats.get("totalRevenue") %></h4>
                            <p>Sales revenue</p>
                        </div>
                    </div>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: #E0E7FF; color: #3730A3;">📦</div>
                        <div class="feature-text">
                            <h4><%= stats.get("orderCount") %> Orders</h4>
                            <p>Customer orders</p>
                        </div>
                    </div>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: #FEF3C7; color: #92400E;">⚠️</div>
                        <div class="feature-text">
                            <h4><%= stats.get("lowStockCount") %> Low Stock</h4>
                            <p>Needs restock</p>
                        </div>
                    </div>
                <% } else { %>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: #E0E7FF; color: #3730A3;">👥</div>
                        <div class="feature-text">
                            <h4><%= stats.get("usersCount") %> Users</h4>
                            <p>Registered accounts</p>
                        </div>
                    </div>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: var(--primary-light); color: var(--primary);">🛍️</div>
                        <div class="feature-text">
                            <h4><%= stats.get("productsCount") %> Products</h4>
                            <p>Catalog listings</p>
                        </div>
                    </div>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: var(--accent-green-bg); color: var(--accent-green);">📦</div>
                        <div class="feature-text">
                            <h4><%= stats.get("ordersCount") %> Orders</h4>
                            <p>Platform orders</p>
                        </div>
                    </div>
                    <div class="feature-box">
                        <div class="feature-icon" style="background: #FEF3C7; color: #92400E;">📈</div>
                        <div class="feature-text">
                            <h4>₹ <%= stats.get("gmv") %></h4>
                            <p>Platform GMV</p>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

        <!-- Two Column Forms: Profile Edit (Left) & Password Change (Right) -->
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 28px; align-items: flex-start;">
            <!-- Profile Details Form -->
            <div class="card" style="max-width: 100%; box-shadow: var(--shadow-sm); padding: 26px;">
                <h3 style="margin-bottom: 6px; font-size: 1.15rem;">Edit Profile Information</h3>
                <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 20px;">
                    Update your display name and personal preferences
                </p>

                <form method="post" action="${pageContext.request.contextPath}/profile">
                    <input type="hidden" name="action" value="updateName">

                    <div class="field-group">
                        <label for="profName">Full Name *</label>
                        <input id="profName" name="name" value="<%= user != null ? user.name : "" %>" required>
                    </div>

                    <div class="field-group">
                        <label>Registered Email</label>
                        <input value="<%= user != null ? user.email : "" %>" disabled style="background: var(--bg-page); color: var(--text-muted); cursor: not-allowed;">
                        <span style="font-size: 0.75rem; color: var(--text-muted);">Email address cannot be modified for account security.</span>
                    </div>

                    <div class="field-group">
                        <label>Account Role</label>
                        <input value="<%= user != null ? user.role : "" %>" disabled style="background: var(--bg-page); color: var(--text-muted); cursor: not-allowed;">
                    </div>

                    <button type="submit" class="btn full" style="margin-top: 14px; padding: 12px;">
                        Save Profile Changes ✓
                    </button>
                </form>
            </div>

            <!-- Password Change Form (BCrypt Security) -->
            <div class="card" style="max-width: 100%; box-shadow: var(--shadow-sm); padding: 26px;">
                <h3 style="margin-bottom: 6px; font-size: 1.15rem;">Change Password</h3>
                <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 20px;">
                    Ensure your account stays secure with a strong password
                </p>

                <form method="post" action="${pageContext.request.contextPath}/profile">
                    <input type="hidden" name="action" value="changePassword">

                    <div class="field-group">
                        <label for="oldPassword">Current Password *</label>
                        <input id="oldPassword" name="oldPassword" type="password" placeholder="Enter your current password" required>
                    </div>

                    <div class="field-group">
                        <label for="newPassword">New Password (min 4 characters) *</label>
                        <input id="newPassword" name="newPassword" type="password" placeholder="Enter new password" required minlength="4">
                    </div>

                    <div class="field-group">
                        <label for="confirmPassword">Confirm New Password *</label>
                        <input id="confirmPassword" name="confirmPassword" type="password" placeholder="Re-enter new password" required minlength="4">
                    </div>

                    <button type="submit" class="btn full" style="margin-top: 14px; padding: 12px; background: #0F172A;">
                        Update Account Password 🔒
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- AI Chatbot Floating Widget -->
    <script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>
</body>
</html>
