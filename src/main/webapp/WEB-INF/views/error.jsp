<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Something Went Wrong | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-card" style="max-width: 520px; text-align: center;">
        <div class="logo">🛍️</div>
        <h1>Oops! Something went wrong</h1>
        <p class="subtitle" style="margin-bottom: 20px;">
            We encountered an unexpected issue while processing your request. Don't worry, your items and cart are safe!
        </p>

        <div style="background: #FEF2F2; border: 1px solid #FCA5A5; color: #991B1B; padding: 14px 18px; border-radius: var(--radius-md); font-size: 0.9rem; margin-bottom: 24px;">
            <b>Error Code:</b> <%= response.getStatus() > 0 ? response.getStatus() : 500 %><br>
            <span style="font-size: 0.85rem; color: #B91C1C;">Please return to the store or contact customer support if this issue persists.</span>
        </div>

        <div style="display: flex; gap: 12px; justify-content: center;">
            <a href="${pageContext.request.contextPath}/shop" class="btn" style="padding: 10px 20px;">
                Back to Storefront 🛒
            </a>
            <a href="${pageContext.request.contextPath}/orders" class="btn-outline" style="padding: 10px 20px; border-radius: var(--radius-sm);">
                View My Orders 📦
            </a>
        </div>
    </div>
</body>
</html>
