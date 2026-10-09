<%@ page import="java.util.List,java.util.Map,com.shanjay.mart.model.Product" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop Products | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Meesho-style Top Header Bar -->
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/shop" class="brand-logo">
            🛒 SHAN MART
        </a>

        <!-- Wide Search Bar -->
        <form class="search" action="${pageContext.request.contextPath}/shop" method="get">
            <span style="color: var(--text-muted); font-size: 1.1rem; padding-left: 4px;">🔍</span>
            <input name="q" placeholder="Try Saree, Earbuds, Shoes, T-Shirt or search by name..." value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>">
            <select name="category" onchange="this.form.submit()">
                <option value="">All Categories</option>
                <option value="Fashion" <%= "Fashion".equalsIgnoreCase(request.getParameter("category")) ? "selected" : "" %>>Fashion</option>
                <option value="Electronics" <%= "Electronics".equalsIgnoreCase(request.getParameter("category")) ? "selected" : "" %>>Electronics</option>
                <option value="Home & Kitchen" <%= "Home & Kitchen".equalsIgnoreCase(request.getParameter("category")) ? "selected" : "" %>>Home & Kitchen</option>
                <option value="Books" <%= "Books".equalsIgnoreCase(request.getParameter("category")) ? "selected" : "" %>>Books</option>
                <option value="Sports" <%= "Sports".equalsIgnoreCase(request.getParameter("category")) ? "selected" : "" %>>Sports</option>
            </select>
            <button class="btn" type="submit">Search</button>
        </form>

        <!-- Right Navigation Links -->
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">
                <span>📊</span> Dashboard
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

    <!-- Sub-Navbar Category Filters -->
    <div class="category-strip">
        <a href="${pageContext.request.contextPath}/shop" class="category-pill <%= request.getParameter("category") == null || request.getParameter("category").isEmpty() ? "active" : "" %>">All Products</a>
        <a href="${pageContext.request.contextPath}/shop?category=Fashion" class="category-pill <%= "Fashion".equalsIgnoreCase(request.getParameter("category")) ? "active" : "" %>">Fashion</a>
        <a href="${pageContext.request.contextPath}/shop?category=Electronics" class="category-pill <%= "Electronics".equalsIgnoreCase(request.getParameter("category")) ? "active" : "" %>">Electronics</a>
        <a href="${pageContext.request.contextPath}/shop?category=Home+%26+Kitchen" class="category-pill <%= "Home & Kitchen".equalsIgnoreCase(request.getParameter("category")) ? "active" : "" %>">Home & Kitchen</a>
        <a href="${pageContext.request.contextPath}/shop?category=Books" class="category-pill <%= "Books".equalsIgnoreCase(request.getParameter("category")) ? "active" : "" %>">Books</a>
        <a href="${pageContext.request.contextPath}/shop?category=Sports" class="category-pill <%= "Sports".equalsIgnoreCase(request.getParameter("category")) ? "active" : "" %>">Sports</a>
    </div>

    <!-- Storefront Catalog Container -->
    <div class="storefront-container">
        <div class="store-header">
            <div>
                <h2>Products For You</h2>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 4px;">
                    Showing high quality authentic products at lowest prices online with free delivery
                </p>
            </div>
            <% if ((request.getParameter("q") != null && !request.getParameter("q").isEmpty()) || 
                   (request.getParameter("category") != null && !request.getParameter("category").isEmpty())) { %>
                <a href="${pageContext.request.contextPath}/shop" class="btn-outline" style="padding: 6px 14px; font-size: 0.85rem; border-radius: var(--radius-full);">
                    ✕ Clear Filters
                </a>
            <% } %>
        </div>

        <!-- Product Grid -->
        <div class="grid">
            <% 
                List<Product> ps = (List<Product>) request.getAttribute("products"); 
                Map<Long, Double> ratingsMap = (Map<Long, Double>) request.getAttribute("ratingsMap");
                Map<Long, Integer> reviewCountsMap = (Map<Long, Integer>) request.getAttribute("reviewsCountMap");

                if (ps != null && !ps.isEmpty()) { 
                    for (Product p : ps) { 
                        String img = (p.imageUrl != null && !p.imageUrl.isBlank()) ? p.imageUrl : "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600";
                        double ratingVal = (ratingsMap != null && ratingsMap.containsKey(p.id)) ? ratingsMap.get(p.id) : 4.5;
                        int reviewCnt = (reviewCountsMap != null && reviewCountsMap.containsKey(p.id)) ? reviewCountsMap.get(p.id) : 18;
            %>
                <div class="product" style="position: relative;">
                    <!-- Wishlist Shortcut on Card -->
                    <form method="post" action="${pageContext.request.contextPath}/wishlist" style="position: absolute; top: 10px; right: 10px; z-index: 5; margin: 0; padding: 0; background: none; border: none;">
                        <input type="hidden" name="productId" value="<%= p.id %>">
                        <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/shop">
                        <button type="submit" title="Save to Wishlist" style="width: 32px; height: 32px; border-radius: 50%; background: rgba(255,255,255,0.92); border: 1px solid var(--border-color); color: var(--primary); font-size: 1rem; cursor: pointer; display: flex; align-items: center; justify-content: center; box-shadow: var(--shadow-sm); padding: 0;">
                            🤍
                        </button>
                    </form>

                    <a href="${pageContext.request.contextPath}/product?id=<%= p.id %>" style="display: block;">
                        <img src="<%= img %>" alt="<%= p.name %>" loading="lazy" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600'">
                    </a>
                    
                    <div class="product-body">
                        <span class="category-tag"><%= p.category %></span>
                        <h3 title="<%= p.name %>">
                            <a href="${pageContext.request.contextPath}/product?id=<%= p.id %>" style="color: inherit; text-decoration: none;">
                                <%= p.name %>
                            </a>
                        </h3>
                        
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px;">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <span class="rating-badge"><%= ratingVal %> ★</span>
                                <span style="font-size: 0.8rem; color: var(--text-muted);">(<%= reviewCnt %> reviews)</span>
                            </div>
                            <button type="button" onclick="openReviewsModal(<%= p.id %>, '<%= p.name.replace("'", "\\'") %>')" 
                                    style="background: none; border: none; color: var(--primary); font-size: 0.82rem; font-weight: 600; cursor: pointer; padding: 0; box-shadow: none;">
                                View Reviews ▾
                            </button>
                        </div>

                        <p class="desc" title="<%= p.description %>"><%= p.description %></p>
                        
                        <div class="price-row">
                            <strong>₹ <%= p.price %></strong>
                            <span class="free-delivery-badge">Free Delivery</span>
                        </div>

                        <div class="stock-info">
                            <% if (p.stockQty > 0) { %>
                                <span style="color: var(--accent-green); font-weight: 600;">● In Stock</span> (<%= p.stockQty %> available)
                            <% } else { %>
                                <span style="color: #DC2626; font-weight: 600;">Out of Stock</span>
                            <% } %>
                        </div>

                        <form class="add-to-cart-form" method="post" action="${pageContext.request.contextPath}/cart">
                            <input type="hidden" name="productId" value="<%= p.id %>">
                            <input type="number" name="quantity" min="1" max="<%= p.stockQty %>" value="1" title="Quantity">
                            <button class="btn" type="submit" <%= p.stockQty <= 0 ? "disabled" : "" %>>
                                🛒 Add to Cart
                            </button>
                        </form>

                        <a href="${pageContext.request.contextPath}/product?id=<%= p.id %>" style="display: block; text-align: center; font-size: 0.82rem; color: var(--primary); font-weight: 600; margin-top: 10px;">
                            View Full Details & Reviews →
                        </a>
                    </div>
                </div>
            <% 
                    } 
                } else { 
            %>
                <div class="empty-state" style="grid-column: 1 / -1;">
                    <div class="empty-state-icon">🔍</div>
                    <h3>No products found</h3>
                    <p style="color: var(--text-muted); margin: 8px 0 20px 0;">We couldn't find any products matching your search criteria.</p>
                    <a href="${pageContext.request.contextPath}/shop" class="btn">View All Products</a>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Customer Reviews Modal -->
    <div id="reviewsModal" class="modal-overlay" onclick="if(event.target===this) closeReviewsModal()">
        <div class="modal-box">
            <button class="modal-close-btn" onclick="closeReviewsModal()">✕</button>
            <h3 id="modalProductTitle" style="margin-bottom: 6px; font-size: 1.25rem;">Customer Reviews</h3>
            <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 20px;">Verified customer ratings and experiences</p>

            <div id="modalReviewsContent" style="display: flex; flex-direction: column; gap: 12px; max-height: 400px; overflow-y: auto;">
                <!-- Dynamically populated via AJAX -->
                <p style="color: var(--text-muted); text-align: center; padding: 20px;">Loading customer reviews...</p>
            </div>
        </div>
    </div>

    <script>
        function openReviewsModal(productId, productName) {
            document.getElementById('modalProductTitle').innerText = 'Reviews for ' + productName;
            const container = document.getElementById('modalReviewsContent');
            container.innerHTML = '<p style="color: var(--text-muted); text-align: center; padding: 24px;">Loading reviews...</p>';
            document.getElementById('reviewsModal').classList.add('active');

            fetch('${pageContext.request.contextPath}/review?productId=' + productId)
                .then(r => r.json())
                .then(res => {
                    if (res && res.success && res.data && res.data.length > 0) {
                        let html = '';
                        res.data.forEach(rev => {
                            let stars = '★'.repeat(rev.rating) + '☆'.repeat(5 - rev.rating);
                            let dateStr = rev.createdAt ? new Date(rev.createdAt).toLocaleDateString('en-IN', {day:'numeric', month:'short', year:'numeric'}) : 'Verified Buyer';
                            html += '<div class="review-card-item">' +
                                '<div class="review-header">' +
                                    '<span class="review-author">👤 ' + (rev.buyerName || 'Verified Buyer') + '</span>' +
                                    '<span class="review-date">' + dateStr + '</span>' +
                                '</div>' +
                                '<div style="color: var(--star-yellow); font-size: 1.1rem; margin-bottom: 6px;">' + stars + '</div>' +
                                '<p class="review-text">' + (rev.comment ? rev.comment : 'Great quality product!') + '</p>' +
                            '</div>';
                        });
                        container.innerHTML = html;
                    } else {
                        container.innerHTML = '<div style="text-align: center; padding: 32px 16px;">' +
                            '<div style="font-size: 2.2rem; margin-bottom: 8px;">🌟</div>' +
                            '<h4>No reviews yet for this product</h4>' +
                            '<p style="color: var(--text-muted); font-size: 0.88rem; margin-top: 4px;">Be the first to order and review this item!</p>' +
                        '</div>';
                    }
                })
                .catch(err => {
                    container.innerHTML = '<p style="color: #DC2626; text-align: center; padding: 20px;">Unable to load reviews at this time.</p>';
                });
        }

        function closeReviewsModal() {
            document.getElementById('reviewsModal').classList.remove('active');
        }
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>
</body>
</html>

