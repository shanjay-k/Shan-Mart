<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SHAN MART - Online Shopping for Fashion, Electronics, Home & More</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Top Navigation Bar -->
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/" class="brand-logo">
            🛒 SHAN MART
        </a>

        <div class="search-bar" style="max-width: 480px;">
            <span style="color: var(--text-muted); font-size: 1.1rem;">🔍</span>
            <input type="text" placeholder="Try Shoes, T-Shirts, Electronics, or Books..." readonly onclick="window.location.href='${pageContext.request.contextPath}/login'">
            <a href="${pageContext.request.contextPath}/login" class="btn" style="padding: 6px 16px; font-size: 0.88rem;">Search</a>
        </div>

        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/register">Become a Seller</a>
            <a href="${pageContext.request.contextPath}/login" class="btn-outline" style="border-radius: var(--radius-sm); padding: 7px 16px;">Sign In</a>
            <a href="${pageContext.request.contextPath}/register" class="btn" style="padding: 8px 18px;">Join Free</a>
        </div>
    </nav>

    <!-- Sub-Navbar / Categories Strip -->
    <div class="category-strip">
        <a href="${pageContext.request.contextPath}/login" class="category-pill active">All Categories</a>
        <a href="${pageContext.request.contextPath}/login" class="category-pill">Fashion</a>
        <a href="${pageContext.request.contextPath}/login" class="category-pill">Electronics</a>
        <a href="${pageContext.request.contextPath}/login" class="category-pill">Home & Kitchen</a>
        <a href="${pageContext.request.contextPath}/login" class="category-pill">Books</a>
        <a href="${pageContext.request.contextPath}/login" class="category-pill">Sports & Fitness</a>
    </div>

    <!-- Hero Promotional Banner -->
    <div class="hero-container">
        <div class="hero-banner">
            <div class="hero-content">
                <span class="hero-tag">✨ Lowest Prices Guaranteed</span>
                <h1>Lowest Prices,<br>Best Quality Shopping</h1>
                <p>Shop from 1,000s of products at wholesale rates. Enjoy Free Delivery and Cash on Delivery on all orders.</p>
                <a href="${pageContext.request.contextPath}/login" class="hero-btn">
                    Start Shopping Now 🛍️
                </a>
            </div>
            <div style="font-size: 6rem; text-align: center; filter: drop-shadow(0 8px 16px rgba(0,0,0,0.25)); display: flex; flex-direction: column; align-items: center; gap: 8px;">
                <span>🏷️</span>
                <span style="font-size: 1.1rem; font-weight: 700; color: #FFF; background: rgba(255,255,255,0.25); padding: 4px 14px; border-radius: 20px;">Up to 70% Off</span>
            </div>
        </div>
    </div>

    <!-- Trust Badges & Features -->
    <div class="features-grid">
        <div class="feature-box">
            <div class="feature-icon">🚚</div>
            <div class="feature-text">
                <h4>Free Delivery</h4>
                <p>Zero shipping fees on all eligible orders</p>
            </div>
        </div>

        <div class="feature-box">
            <div class="feature-icon">💵</div>
            <div class="feature-text">
                <h4>Cash on Delivery</h4>
                <p>Pay comfortably after your order arrives</p>
            </div>
        </div>

        <div class="feature-box">
            <div class="feature-icon">🔄</div>
            <div class="feature-text">
                <h4>Easy 7-Day Returns</h4>
                <p>Hassle-free instant refund policy</p>
            </div>
        </div>

        <div class="feature-box">
            <div class="feature-icon">🛡️</div>
            <div class="feature-text">
                <h4>100% Genuine</h4>
                <p>Verified sellers with guaranteed quality</p>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer style="background: #FFFFFF; border-top: 1px solid var(--border-color); padding: 32px 20px; text-align: center; margin-top: 48px; color: var(--text-muted); font-size: 0.9rem;">
        <p><b>SHAN MART</b> — Inspired by Meesho & Amazon. Built for fast, joyful, and smart e-commerce.</p>
        <p style="margin-top: 6px; font-size: 0.8rem;">© 2026 SHAN MART. All rights reserved.</p>
    </footer>

    <script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>
</body>
</html>

