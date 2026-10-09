<%@ page import="java.util.List,com.shanjay.mart.model.Product,com.shanjay.mart.model.Review,com.shanjay.mart.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <% Product p = (Product) request.getAttribute("product"); %>
    <title><%= p != null ? p.name : "Product Details" %> | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <% 
        User user = (User) session.getAttribute("user");
        String pImg = (p != null && p.imageUrl != null && !p.imageUrl.isBlank()) ? p.imageUrl : "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600";
        double avgRating = request.getAttribute("avgRating") != null ? (Double) request.getAttribute("avgRating") : 4.5;
        int reviewCount = request.getAttribute("reviewCount") != null ? (Integer) request.getAttribute("reviewCount") : 0;
        List<Review> reviews = (List<Review>) request.getAttribute("reviews");
        List<Product> relatedProducts = (List<Product>) request.getAttribute("relatedProducts");
        boolean isWishlisted = Boolean.TRUE.equals(request.getAttribute("isWishlisted"));
    %>

    <!-- Top Navigation Bar -->
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/shop" class="brand-logo">
            🛒 SHAN MART
        </a>

        <!-- Search Bar -->
        <form class="search" action="${pageContext.request.contextPath}/shop" method="get">
            <span style="color: var(--text-muted); font-size: 1.1rem; padding-left: 4px;">🔍</span>
            <input name="q" placeholder="Search products, brands and categories..." value="">
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

        <!-- Right Nav Links -->
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

    <!-- Sub-Navbar Category Strip -->
    <div class="category-strip">
        <a href="${pageContext.request.contextPath}/shop" class="category-pill">All Products</a>
        <a href="${pageContext.request.contextPath}/shop?category=Fashion" class="category-pill <%= "Fashion".equalsIgnoreCase(p != null ? p.category : "") ? "active" : "" %>">Fashion</a>
        <a href="${pageContext.request.contextPath}/shop?category=Electronics" class="category-pill <%= "Electronics".equalsIgnoreCase(p != null ? p.category : "") ? "active" : "" %>">Electronics</a>
        <a href="${pageContext.request.contextPath}/shop?category=Home+%26+Kitchen" class="category-pill <%= "Home & Kitchen".equalsIgnoreCase(p != null ? p.category : "") ? "active" : "" %>">Home & Kitchen</a>
        <a href="${pageContext.request.contextPath}/shop?category=Books" class="category-pill <%= "Books".equalsIgnoreCase(p != null ? p.category : "") ? "active" : "" %>">Books</a>
        <a href="${pageContext.request.contextPath}/shop?category=Sports" class="category-pill <%= "Sports".equalsIgnoreCase(p != null ? p.category : "") ? "active" : "" %>">Sports</a>
    </div>

    <!-- Main Container -->
    <div class="wrap" style="max-width: 1200px; margin-top: 20px;">
        <!-- Breadcrumbs -->
        <div class="breadcrumbs-bar" style="margin-bottom: 20px; font-size: 0.88rem; color: var(--text-muted); display: flex; align-items: center; gap: 8px;">
            <a href="${pageContext.request.contextPath}/shop" style="color: var(--text-muted);">Home</a>
            <span>/</span>
            <a href="${pageContext.request.contextPath}/shop?category=<%= p != null ? p.category : "" %>" style="color: var(--text-muted);"><%= p != null ? p.category : "Category" %></a>
            <span>/</span>
            <span style="color: var(--text-heading); font-weight: 600;"><%= p != null ? p.name : "Product" %></span>
        </div>

        <!-- Success & Error Alerts -->
        <% if ("1".equals(request.getParameter("reviewed"))) { %>
            <div style="background: var(--accent-green-bg); border: 1.5px solid var(--accent-green); border-radius: var(--radius-sm); padding: 14px 20px; margin-bottom: 20px; color: var(--accent-green); font-weight: 600; display: flex; align-items: center; gap: 10px;">
                <span style="font-size: 1.3rem;">⭐</span> Thank you! Your product review and rating have been posted successfully.
            </div>
        <% } %>

        <% if ("1".equals(request.getParameter("wishlistAdded"))) { %>
            <div style="background: #FFF1F2; border: 1.5px solid var(--primary-border); border-radius: var(--radius-sm); padding: 14px 20px; margin-bottom: 20px; color: var(--primary); font-weight: 600; display: flex; align-items: center; gap: 10px;">
                <span style="font-size: 1.3rem;">❤️</span> Product added to your Wishlist! You can find it under Saved Items.
            </div>
        <% } %>

        <% if (request.getParameter("reviewError") != null) { %>
            <div class="error" style="margin-bottom: 20px;">
                ⚠️ <%= request.getParameter("reviewError") %>
            </div>
        <% } %>

        <% if (p != null) { %>
            <!-- Two Column Product Overview -->
            <div class="product-detail-layout" style="display: grid; grid-template-columns: 460px 1fr; gap: 40px; background: var(--bg-surface); padding: 32px; border-radius: var(--radius-lg); border: 1px solid var(--border-color); box-shadow: var(--shadow-sm); margin-bottom: 40px;">
                
                <!-- Left: Media & Guarantees -->
                <div class="product-gallery-col">
                    <div style="position: relative; border: 1px solid var(--border-color); border-radius: var(--radius-md); overflow: hidden; background: #FAF9F6; margin-bottom: 20px;">
                        <img src="<%= pImg %>" alt="<%= p.name %>" style="width: 100%; height: 420px; object-fit: contain; display: block;" onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600'">
                        <span class="free-delivery-badge" style="position: absolute; top: 16px; left: 16px; font-size: 0.82rem; padding: 4px 12px; box-shadow: var(--shadow-sm);">
                            🚚 Free Delivery
                        </span>
                    </div>

                    <!-- Trust Guarantees -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; background: var(--bg-page); padding: 16px; border-radius: var(--radius-md); border: 1px solid var(--border-light); font-size: 0.85rem;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <span style="font-size: 1.3rem;">🛡️</span>
                            <div><b>100% Genuine</b><br><span style="color: var(--text-muted); font-size: 0.78rem;">Direct from brand</span></div>
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <span style="font-size: 1.3rem;">🔄</span>
                            <div><b>7-Day Returns</b><br><span style="color: var(--text-muted); font-size: 0.78rem;">No questions asked</span></div>
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <span style="font-size: 1.3rem;">⚡</span>
                            <div><b>Fast Dispatch</b><br><span style="color: var(--text-muted); font-size: 0.78rem;">Ships in 24 hours</span></div>
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <span style="font-size: 1.3rem;">💵</span>
                            <div><b>Pay on Delivery</b><br><span style="color: var(--text-muted); font-size: 0.78rem;">Cash / UPI at doorstep</span></div>
                        </div>
                    </div>
                </div>

                <!-- Right: Details, Pricing, Add to Cart, Wishlist -->
                <div class="product-info-col" style="display: flex; flex-direction: column;">
                    <span class="category-tag" style="margin-bottom: 8px;"><%= p.category %></span>
                    
                    <h1 style="font-size: 1.85rem; color: var(--text-heading); margin-bottom: 10px; line-height: 1.3;">
                        <%= p.name %>
                    </h1>

                    <!-- Rating summary bar -->
                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 18px;">
                        <span class="rating-badge" style="font-size: 0.9rem; padding: 4px 10px;">
                            <%= avgRating %> ★
                        </span>
                        <a href="#reviews" style="font-size: 0.9rem; color: var(--primary); font-weight: 600; text-decoration: underline;">
                            <%= reviewCount %> Ratings & Reviews ▾
                        </a>
                        <span style="color: var(--text-muted);">|</span>
                        <span style="font-size: 0.85rem; color: var(--accent-green); font-weight: 600;">✓ Verified Product</span>
                    </div>

                    <!-- Price Block -->
                    <div style="background: var(--bg-page); border: 1px solid var(--border-light); padding: 16px 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                        <div style="display: flex; align-items: baseline; gap: 14px; margin-bottom: 6px;">
                            <span style="font-size: 2.1rem; font-weight: 800; color: var(--text-heading);">
                                ₹ <%= p.price %>
                            </span>
                            <span style="font-size: 1.15rem; color: var(--text-muted); text-decoration: line-through;">
                                ₹ <%= p.price.multiply(new java.math.BigDecimal("1.25")).setScale(2, java.math.RoundingMode.HALF_UP) %>
                            </span>
                            <span style="color: var(--accent-green); font-weight: 700; font-size: 0.95rem; background: var(--accent-green-bg); padding: 3px 8px; border-radius: 4px;">
                                20% OFF
                            </span>
                        </div>
                        <div style="font-size: 0.85rem; color: var(--text-muted);">
                            Inclusive of all taxes · <b>Free Express Delivery</b> on this item
                        </div>
                    </div>

                    <!-- Live Stock Status -->
                    <div style="margin-bottom: 20px; font-size: 0.92rem;">
                        <b>Availability:</b> 
                        <% if (p.stockQty > 10) { %>
                            <span style="color: var(--accent-green); font-weight: 700;">● In Stock (<%= p.stockQty %> units available)</span>
                        <% } else if (p.stockQty > 0) { %>
                            <span style="color: #D97706; font-weight: 700;">● Only <%= p.stockQty %> left in stock - order soon!</span>
                        <% } else { %>
                            <span style="color: #DC2626; font-weight: 700;">✕ Out of Stock</span>
                        <% } %>
                    </div>

                    <!-- Description -->
                    <div style="margin-bottom: 24px;">
                        <h4 style="font-size: 1rem; margin-bottom: 8px; color: var(--text-heading);">Product Description</h4>
                        <p style="color: var(--text-body); font-size: 0.95rem; line-height: 1.6; white-space: pre-line;">
                            <%= p.description != null && !p.description.isBlank() ? p.description : "High quality authentic " + p.name + " with verified seller warranty." %>
                        </p>
                    </div>

                    <!-- Product Highlights Bullet Points -->
                    <div style="margin-bottom: 28px; background: #F8FAFC; border-left: 3px solid var(--primary); padding: 12px 18px; border-radius: 0 var(--radius-sm) var(--radius-sm) 0;">
                        <ul style="padding-left: 18px; font-size: 0.88rem; color: var(--text-body); line-height: 1.6;">
                            <li>Authentic premium grade material and original packaging.</li>
                            <li>Fully backed by manufacturer guarantee and 7-day buyer protection.</li>
                            <li>Instant order tracking and safe, contactless delivery options.</li>
                        </ul>
                    </div>

                    <!-- Add to Cart & Wishlist Actions Bar -->
                    <div style="display: flex; gap: 14px; flex-wrap: wrap; align-items: center; margin-top: auto; padding-top: 16px; border-top: 1px solid var(--border-light);">
                        <!-- Add to Cart Form -->
                        <form method="post" action="${pageContext.request.contextPath}/cart" style="display: flex; gap: 12px; align-items: center; flex: 1; margin: 0; padding: 0; background: none; border: none; box-shadow: none;">
                            <input type="hidden" name="productId" value="<%= p.id %>">
                            <div style="display: flex; align-items: center; border: 1.5px solid var(--border-color); border-radius: var(--radius-sm); overflow: hidden; background: var(--bg-surface);">
                                <span style="font-size: 0.85rem; font-weight: 600; padding: 0 10px; color: var(--text-muted);">Qty</span>
                                <input type="number" name="quantity" min="1" max="<%= p.stockQty > 0 ? p.stockQty : 1 %>" value="1" 
                                       style="width: 55px; border: none; padding: 10px 6px; text-align: center; font-size: 1rem; font-weight: 700; outline: none;" <%= p.stockQty <= 0 ? "disabled" : "" %>>
                            </div>
                            <button class="btn" type="submit" style="flex: 1; padding: 14px 20px; font-size: 1.05rem;" <%= p.stockQty <= 0 ? "disabled" : "" %>>
                                🛒 Add to Cart
                            </button>
                        </form>

                        <!-- Wishlist Form -->
                        <form method="post" action="${pageContext.request.contextPath}/wishlist" style="margin: 0; padding: 0; background: none; border: none; box-shadow: none;">
                            <input type="hidden" name="productId" value="<%= p.id %>">
                            <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/product?id=<%= p.id %>">
                            <% if (isWishlisted) { %>
                                <input type="hidden" name="action" value="remove">
                                <button type="submit" class="btn-outline" style="padding: 13px 18px; border-color: var(--primary); background: var(--primary-light); color: var(--primary); font-weight: 700;">
                                    ❤️ Saved in Wishlist
                                </button>
                            <% } else { %>
                                <input type="hidden" name="action" value="add">
                                <button type="submit" class="btn-outline" style="padding: 13px 18px; font-weight: 700;">
                                    🤍 Add to Wishlist
                                </button>
                            <% } %>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Customer Reviews & Ratings Full Section (F8) -->
            <div id="reviews" class="card" style="max-width: 100%; padding: 32px; box-shadow: var(--shadow-sm); margin-bottom: 40px;">
                <div style="border-bottom: 1px solid var(--border-color); padding-bottom: 16px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                    <div>
                        <h2>Verified Customer Reviews & Ratings</h2>
                        <p style="color: var(--text-muted); font-size: 0.92rem; margin-top: 4px;">
                            Real feedback and star ratings from buyers who purchased this product
                        </p>
                    </div>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <span class="rating-badge" style="font-size: 1.15rem; padding: 6px 14px;">
                            <%= avgRating %> ★
                        </span>
                        <span style="font-size: 0.95rem; color: var(--text-muted);">
                            Overall Rating (<%= reviewCount %> reviews)
                        </span>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 380px; gap: 36px; align-items: flex-start;">
                    <!-- Left: Reviews List -->
                    <div>
                        <h3 style="font-size: 1.15rem; margin-bottom: 16px;">Buyer Experiences (<%= reviews != null ? reviews.size() : 0 %>)</h3>

                        <% if (reviews != null && !reviews.isEmpty()) { %>
                            <div style="display: flex; flex-direction: column; gap: 14px;">
                                <% for (Review rev : reviews) { 
                                    String stars = "★".repeat(Math.max(1, Math.min(5, rev.rating))) + "☆".repeat(Math.max(0, 5 - rev.rating));
                                %>
                                    <div class="review-card-item" style="padding: 18px 22px;">
                                        <div class="review-header">
                                            <span class="review-author">
                                                👤 <%= rev.buyerName != null && !rev.buyerName.isBlank() ? rev.buyerName : "Verified Buyer" %>
                                                <span style="font-size: 0.72rem; background: var(--accent-green-bg); color: var(--accent-green); padding: 2px 6px; border-radius: 4px; margin-left: 6px;">✓ Verified Purchase</span>
                                            </span>
                                            <span class="review-date">
                                                <%= rev.createdAt != null ? rev.createdAt.toString().substring(0, 10) : "Recent" %>
                                            </span>
                                        </div>
                                        <div style="color: var(--star-yellow); font-size: 1.15rem; margin-bottom: 8px;">
                                            <%= stars %>
                                        </div>
                                        <p class="review-text" style="font-size: 0.95rem; color: var(--text-body);">
                                            <%= rev.comment != null && !rev.comment.isBlank() ? rev.comment : "Great product, works as advertised!" %>
                                        </p>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="empty-state" style="margin: 0; padding: 32px 20px;">
                                <div class="empty-state-icon">🌟</div>
                                <h4>No customer reviews yet</h4>
                                <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 4px;">
                                    Be the first customer to rate and review this item using the form on the right!
                                </p>
                            </div>
                        <% } %>
                    </div>

                    <!-- Right: Write a Review Form -->
                    <div style="background: var(--bg-page); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px;">
                        <h3 style="font-size: 1.15rem; margin-bottom: 4px;">Write a Review</h3>
                        <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 18px;">
                            Rate this product and share your thoughts with other shoppers
                        </p>

                        <form method="post" action="${pageContext.request.contextPath}/review">
                            <input type="hidden" name="productId" value="<%= p.id %>">
                            <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/product?id=<%= p.id %>">

                            <div class="field-group" style="align-items: center; text-align: center;">
                                <label style="font-size: 0.9rem; font-weight: 700;">Overall Rating *</label>
                                <div class="interactive-stars" style="margin: 6px 0 12px 0;">
                                    <input type="radio" id="pstar5" name="rating" value="5" required>
                                    <label for="pstar5" title="5 Stars - Excellent">★</label>
                                    <input type="radio" id="pstar4" name="rating" value="4">
                                    <label for="pstar4" title="4 Stars - Very Good">★</label>
                                    <input type="radio" id="pstar3" name="rating" value="3">
                                    <label for="pstar3" title="3 Stars - Good">★</label>
                                    <input type="radio" id="pstar2" name="rating" value="2">
                                    <label for="pstar2" title="2 Stars - Fair">★</label>
                                    <input type="radio" id="pstar1" name="rating" value="1">
                                    <label for="pstar1" title="1 Star - Poor">★</label>
                                </div>
                            </div>

                            <div class="field-group">
                                <label for="prodReviewComment">Detailed Review (Optional)</label>
                                <textarea id="prodReviewComment" name="comment" rows="4" placeholder="How is the quality, fit, finish, or performance? Would you recommend it?"></textarea>
                            </div>

                            <button type="submit" class="btn full" style="margin-top: 14px; padding: 12px;">
                                Submit Review & Rating ⭐
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Related Products Section -->
            <% if (relatedProducts != null && !relatedProducts.isEmpty()) { %>
                <div style="margin-bottom: 40px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;">
                        <h3>Similar Products in <%= p.category %></h3>
                        <a href="${pageContext.request.contextPath}/shop?category=<%= p.category %>" style="font-weight: 600; font-size: 0.9rem;">
                            View More in <%= p.category %> →
                        </a>
                    </div>

                    <div class="grid">
                        <% for (Product rel : relatedProducts) { 
                            String relImg = (rel.imageUrl != null && !rel.imageUrl.isBlank()) ? rel.imageUrl : "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600";
                        %>
                            <div class="product">
                                <a href="${pageContext.request.contextPath}/product?id=<%= rel.id %>">
                                    <img src="<%= relImg %>" alt="<%= rel.name %>" loading="lazy" onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600'">
                                </a>
                                <div class="product-body">
                                    <span class="category-tag"><%= rel.category %></span>
                                    <h3>
                                        <a href="${pageContext.request.contextPath}/product?id=<%= rel.id %>" style="color: inherit;">
                                            <%= rel.name %>
                                        </a>
                                    </h3>
                                    <div class="price-row" style="margin-top: 6px;">
                                        <strong>₹ <%= rel.price %></strong>
                                        <span class="free-delivery-badge">Free Delivery</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/product?id=<%= rel.id %>" class="btn-outline" style="margin-top: auto; padding: 8px 12px; font-size: 0.85rem; text-align: center;">
                                        View Details & Buy →
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>

        <% } else { %>
            <div class="empty-state">
                <div class="empty-state-icon">🔍</div>
                <h3>Product not found</h3>
                <p style="color: var(--text-muted); margin: 8px 0 20px 0;">This product may no longer be available in our catalog.</p>
                <a href="${pageContext.request.contextPath}/shop" class="btn">Explore All Products</a>
            </div>
        <% } %>
    </div>

    <!-- AI Chatbot Floating Widget -->
    <script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>
</body>
</html>
