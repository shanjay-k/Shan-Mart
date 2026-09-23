<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-card">
        <div class="logo">🛒</div>
        <h1>SHAN MART</h1>
        <p class="subtitle">Sign in to your account for the best deals</p>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">
                <span>⚠️</span> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <label for="email">Email Address</label>
            <input id="email" name="email" type="email" required placeholder="name@example.com" autocomplete="email">

            <label for="password">Password</label>
            <div class="pass">
                <input id="password" name="password" type="password" required placeholder="Enter your password" autocomplete="current-password">
                <button type="button" id="toggleBtn" onclick="togglePass()" title="Toggle password visibility">👁</button>
            </div>

            <label class="check">
                <input id="show" type="checkbox" onclick="togglePass()">
                <span>Show password</span>
            </label>

            <button class="btn full" type="submit">Sign In</button>
        </form>

        <div class="demo-accounts">
            <div class="demo-accounts-title">💡 Quick Demo Login:</div>
            <div class="demo-account-item">
                <span>Buyer: <b>buyer@shanjaymart.local</b></span>
                <span>Pass: <b>1234</b></span>
            </div>
            <div class="demo-account-item">
                <span>Seller: <b>seller@shanjaymart.local</b></span>
                <span>Pass: <b>1234</b></span>
            </div>
        </div>

        <p class="auth-footer-text">
            New to SHAN MART? <a href="${pageContext.request.contextPath}/register">Create an account</a>
        </p>
    </div>

    <script>
        function togglePass() {
            const p = document.getElementById('password');
            const c = document.getElementById('show');
            const isText = p.type === 'text';
            p.type = isText ? 'password' : 'text';
            if (c) c.checked = !isText;
            const btn = document.getElementById('toggleBtn');
            if (btn) btn.textContent = isText ? '👁' : '🙈';
        }
    </script>
</body>
</html>
