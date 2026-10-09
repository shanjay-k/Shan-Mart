<%@ page import="java.util.List,com.shanjay.mart.model.WishlistItem,com.shanjay.mart.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist & Saved Items | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <% User user = (User) session.getAttribute("user"); %>

    <!-- Header Navigation Bar -->
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/shop" class="brand-logo">
            🛒 SHAN MART
        </a>

        <!-- Search Bar -->
        <form class="search" action="${pageContext.request.contextPath}/shop" method="get">
            <span style="color: var(--text-muted); font-size: 1.1rem; padding-left: 4px;">🔍</span>
            <input name="q" placeholder="Search wishlist and catalog..." value="">
            <select name="category" onchange="this.form.submit()">
                <option value="">All Categories</option>
                <option value="Fashion">Fashion</option>
                <option value="Electronics">Electronics</option>
                <option value="Home & Kitchen">Home & Kitchen</option>
                <option value="Books">Books</option>
                <option value="Sports">Sports</option>
            </select>
            <button class="btn" type="submit">Search</button>
        </form>

        <!-- Nav Links -->
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">
                <span>📊</span> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/shop">
                <span>🛍️</span> Shop
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

    <!-- Sub-Navbar Category Strip -->
    <div class="category-strip">
        <a href="${pageContext.request.contextPath}/shop" class="category-pill">All Products</a>
        <a href="${pageContext.request.contextPath}/shop?category=Fashion" class="category-pill">Fashion</a>
        <a href="${pageContext.request.contextPath}/shop?category=Electronics" class="category-pill">Electronics</a>
        <a href="${pageContext.request.contextPath}/shop?category=Home+%26+Kitchen" class="category-pill">Home & Kitchen</a>
        <a href="${pageContext.request.contextPath}/shop?category=Books" class="category-pill">Books</a>
        <a href="${pageContext.request.contextPath}/shop?category=Sports" class="category-pill">Sports</a>
    </div>

    <!-- Main Content Container -->
    <div class="wrap" style="max-width: 1140px; margin-top: 24px;">
        <% String removed = request.getParameter("removed"); %>
        <% if ("1".equals(removed)) { %>
            <div style="background: var(--bg-page); border: 1.5px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 18px; margin-bottom: 20px; color: var(--text-body); font-weight: 600;">
                ✓ Product removed from your wishlist.
            </div>
        <% } %>

        <% String added = request.getParameter("added"); %>
        <% if ("1".equals(added)) { %>
            <div style="background: #FFF1F2; border: 1.5px solid var(--primary-border); border-radius: var(--radius-sm); padding: 12px 18px; margin-bottom: 20px; color: var(--primary); font-weight: 600;">
                ❤️ Product added to your wishlist!
            </div>
        <% } %>

        <% 
            List<WishlistItem> items = (List<WishlistItem>) request.getAttribute("items"); 
            int count = items != null ? items.size() : 0;
        %>

        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 24px;">
            <div>
                <h2>My Saved Wishlist (<%= count %>)</h2>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 4px;">
                    Items you saved for later. Move them to your cart when you are ready to order!
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/shop" class="btn-outline" style="padding: 8px 16px; font-size: 0.9rem;">
                ➕ Continue Shopping
            </a>
        </div>

        <% if (items == null || items.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-state-icon">🤍</div>
                <h3>Your Wishlist is Empty</h3>
                <p style="color: var(--text-muted); margin: 8px 0 24px 0;">
                    You haven't saved any items yet. Explore the marketplace and tap the heart icon on products you love!
                </p>
                <a href="${pageContext.request.contextPath}/shop" class="btn" style="padding: 12px 24px;">
                    Explore Products Now 🛍️
                </a>
            </div>
        <% } else { %>
            <div class="grid" style="grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 24px;">
                <% for (WishlistItem item : items) { 
                    String itImg = (item.productImageUrl != null && !item.productImageUrl.isBlank()) ? item.productImageUrl : "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600";
                %>
                    <div class="product" style="position: relative;">
                        <!-- Remove Cross Button on Top Right -->
                        <form method="post" action="${pageContext.request.contextPath}/wishlist" style="position: absolute; top: 10px; right: 10px; z-index: 10; margin: 0; padding: 0; background: none; border: none;">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="productId" value="<%= item.productId %>">
                            <button type="submit" title="Remove from wishlist" 
                                    style="width: 32px; height: 32px; border-radius: 50%; background: rgba(255,255,255,0.9); border: 1px solid var(--border-color); color: #EF4444; font-size: 1rem; cursor: pointer; display: flex; align-items: center; justify-content: center; box-shadow: var(--shadow-sm);">
                                ✕
                            </button>
                        </form>

                        <a href="${pageContext.request.contextPath}/product?id=<%= item.productId %>">
                            <img src="<%= itImg %>" alt="<%= item.productName %>" loading="lazy" onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600'">
                        </a>

                        <div class="product-body">
                            <span class="category-tag"><%= item.productCategory %></span>
                            <h3>
                                <a href="${pageContext.request.contextPath}/product?id=<%= item.productId %>" style="color: inherit;">
                                    <%= item.productName %>
                                </a>
                            </h3>

                            <div class="price-row" style="margin-top: 4px;">
                                <strong>₹ <%= item.productPrice %></strong>
                                <span class="free-delivery-badge">Free Delivery</span>
                            </div>

                            <div class="stock-info" style="margin-bottom: 12px;">
                                <% if (item.stockQty > 0) { %>
                                    <span style="color: var(--accent-green); font-weight: 600;">● In Stock</span> (<%= item.stockQty %> left)
                                <% } else { %>
                                    <span style="color: #DC2626; font-weight: 600;">✕ Out of Stock</span>
                                <% } %>
                            </div>

                            <!-- Move to Cart Form -->
                            <form method="post" action="${pageContext.request.contextPath}/wishlist" style="display: flex; gap: 8px; margin-top: auto; padding: 0; background: none; border: none; box-shadow: none;">
                                <input type="hidden" name="action" value="moveToCart">
                                <input type="hidden" name="productId" value="<%= item.productId %>">
                                <button type="submit" class="btn full" style="padding: 10px; font-size: 0.92rem;" <%= item.stockQty <= 0 ? "disabled" : "" %>>
                                    🛒 Move to Cart
                                </button>
                            </form>

                            <a href="${pageContext.request.contextPath}/product?id=<%= item.productId %>" style="display: block; text-align: center; font-size: 0.82rem; color: var(--primary); font-weight: 600; margin-top: 8px;">
                                View Full Details & Reviews →
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Chatbot script -->
    <script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>
</body>
</html>
