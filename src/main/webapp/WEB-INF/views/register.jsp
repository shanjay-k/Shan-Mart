<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-card">
        <div class="logo">🛒</div>
        <h1>Create Account</h1>
        <p class="subtitle">Join SHAN MART for unbeatable prices & deals</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error">
                <span>⚠️</span> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/register">
            <label for="name">Full Name</label>
            <input id="name" name="name" type="text" required placeholder="John Doe">

            <label for="email">Email Address</label>
            <input id="email" name="email" type="email" required placeholder="you@example.com">

            <label for="password">Password</label>
            <input id="password" name="password" type="password" minlength="4" required placeholder="At least 4 characters">

            <label for="role">Register As</label>
            <select id="role" name="role">
                <option value="BUYER">Buyer (Shop for products)</option>
                <option value="SELLER">Seller (List and sell products)</option>
            </select>

            <button class="btn full" type="submit" style="margin-top: 14px;">Create Account</button>
        </form>

        <p class="auth-footer-text">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Sign In</a>
        </p>
    </div>
</body>
</html>
