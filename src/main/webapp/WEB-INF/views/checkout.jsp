<%@ page import="java.util.List,com.shanjay.mart.model.CartItem,com.shanjay.mart.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout & Payment | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Top Header Bar -->
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/shop" class="brand-logo">
            🛒 SHAN MART <span style="font-size: 0.85rem; font-weight: 600; color: var(--text-muted); background: var(--border-light); padding: 3px 8px; border-radius: 4px; margin-left: 6px;">Secure Checkout</span>
        </a>

        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/cart">
                <span>🛒</span> Back to Cart
            </a>
            <a href="${pageContext.request.contextPath}/orders">
                <span>📦</span> Orders
            </a>
            <a href="${pageContext.request.contextPath}/logout" style="color: #DC2626;">
                <span>🚪</span> Logout
            </a>
        </div>
    </nav>

    <div class="wrap" style="max-width: 1140px;">
        <% String error = request.getParameter("error"); %>
        <% if (error != null && !error.isBlank()) { %>
            <div class="error" style="margin-bottom: 20px;">
                ⚠️ <%= error %>
            </div>
        <% } %>

        <% 
            List<CartItem> items = (List<CartItem>) request.getAttribute("items"); 
            User user = (User) session.getAttribute("user");
            String defaultName = user != null && user.name != null ? user.name : "";
        %>

        <form method="post" action="${pageContext.request.contextPath}/checkout" id="checkoutForm">
            <div class="checkout-layout">
                <!-- Left: Shipping & Payment Details -->
                <div class="checkout-main-card">
                    <!-- Step 1: Shipping Address -->
                    <div>
                        <div class="checkout-section-header">
                            <span class="step-num">1</span>
                            <h3>Enter Delivery Address</h3>
                        </div>

                        <div class="form-grid-2">
                            <div class="field-group">
                                <label for="sName">Full Name *</label>
                                <input id="sName" name="shippingName" value="<%= defaultName %>" placeholder="e.g. John Doe" required>
                            </div>
                            <div class="field-group">
                                <label for="sPhone">Contact Phone Number *</label>
                                <input id="sPhone" name="shippingPhone" type="tel" pattern="[0-9]{10}" placeholder="10-digit mobile (e.g. 9876543210)" required>
                            </div>
                        </div>

                        <div class="field-group">
                            <label for="sAddr">Street Address / House No. / Building *</label>
                            <input id="sAddr" name="shippingAddress" placeholder="Flat / House No., Street, Landmark, Area" required>
                        </div>

                        <div class="form-grid-2">
                            <div class="field-group">
                                <label for="sCity">City / District *</label>
                                <input id="sCity" name="shippingCity" placeholder="e.g. Chennai" required>
                            </div>
                            <div class="field-group">
                                <label for="sPin">PIN Code *</label>
                                <input id="sPin" name="shippingPincode" type="text" pattern="[0-9]{6}" placeholder="6-digit PIN code (e.g. 600025)" required>
                            </div>
                        </div>
                    </div>

                    <!-- Step 2: Payment Method Selection -->
                    <div>
                        <div class="checkout-section-header">
                            <span class="step-num">2</span>
                            <h3>Select Payment Method</h3>
                        </div>

                        <div class="payment-methods-grid">
                            <label class="payment-method-card selected" id="cardOption">
                                <input type="radio" name="paymentMethod" value="CARD" checked onchange="switchPayment('CARD')">
                                <div class="payment-icon">💳</div>
                                <div class="payment-info">
                                    <h4>Credit / Debit Card</h4>
                                    <p>Visa, MasterCard, RuPay</p>
                                </div>
                            </label>

                            <label class="payment-method-card" id="upiOption">
                                <input type="radio" name="paymentMethod" value="UPI" onchange="switchPayment('UPI')">
                                <div class="payment-icon">📱</div>
                                <div class="payment-info">
                                    <h4>UPI / QR Code</h4>
                                    <p>GPay, PhonePe, Paytm</p>
                                </div>
                            </label>

                            <label class="payment-method-card" id="netOption">
                                <input type="radio" name="paymentMethod" value="NET_BANKING" onchange="switchPayment('NET_BANKING')">
                                <div class="payment-icon">🏦</div>
                                <div class="payment-info">
                                    <h4>Net Banking</h4>
                                    <p>All Indian major banks</p>
                                </div>
                            </label>

                            <label class="payment-method-card" id="codOption">
                                <input type="radio" name="paymentMethod" value="COD" onchange="switchPayment('COD')">
                                <div class="payment-icon">💵</div>
                                <div class="payment-info">
                                    <h4>Cash on Delivery</h4>
                                    <p>Pay at your doorstep</p>
                                </div>
                            </label>
                        </div>

                        <!-- Card Details Panel -->
                        <div id="panel-CARD" class="payment-details-panel active">
                            <h4 style="margin-bottom: 12px; font-size: 0.95rem;">Enter Card Details (Mock Sandbox)</h4>
                            <div class="field-group">
                                <label>Card Number</label>
                                <input type="text" placeholder="XXXX XXXX XXXX 4242" maxlength="19" value="4532 8901 2345 4242">
                            </div>
                            <div class="form-grid-2">
                                <div class="field-group">
                                    <label>Expiry Date</label>
                                    <input type="text" placeholder="MM/YY" maxlength="5" value="12/28">
                                </div>
                                <div class="field-group">
                                    <label>CVV</label>
                                    <input type="password" placeholder="123" maxlength="3" value="888">
                                </div>
                            </div>
                            <div class="field-group">
                                <label>Cardholder Name</label>
                                <input type="text" placeholder="Name on Card" value="<%= defaultName %>">
                            </div>
                        </div>

                        <!-- UPI Panel -->
                        <div id="panel-UPI" class="payment-details-panel">
                            <h4 style="margin-bottom: 12px; font-size: 0.95rem;">Pay via UPI (Instant & Zero Fee)</h4>
                            <div style="display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 14px;">
                                <span class="category-pill active">Google Pay</span>
                                <span class="category-pill active">PhonePe</span>
                                <span class="category-pill active">Paytm UPI</span>
                                <span class="category-pill active">BHIM</span>
                            </div>
                            <div class="field-group">
                                <label>Enter UPI ID / VPA</label>
                                <input type="text" placeholder="username@okaxis / mobile@upi" value="demo.buyer@okhdfcbank">
                            </div>
                            <p style="font-size: 0.85rem; color: var(--accent-green); font-weight: 600;">
                                ✓ Seamless instant payment verification enabled
                            </p>
                        </div>

                        <!-- Net Banking Panel -->
                        <div id="panel-NET_BANKING" class="payment-details-panel">
                            <h4 style="margin-bottom: 12px; font-size: 0.95rem;">Select Bank</h4>
                            <div class="field-group">
                                <label>Choose your Bank</label>
                                <select>
                                    <option>State Bank of India (SBI)</option>
                                    <option selected>HDFC Bank</option>
                                    <option>ICICI Bank</option>
                                    <option>Axis Bank</option>
                                    <option>Kotak Mahindra Bank</option>
                                    <option>Punjab National Bank</option>
                                </select>
                            </div>
                            <p style="font-size: 0.85rem; color: var(--text-muted);">
                                You will be directed to the bank's secure portal to authorize the transaction.
                            </p>
                        </div>

                        <!-- Cash on Delivery Panel -->
                        <div id="panel-COD" class="payment-details-panel">
                            <h4 style="margin-bottom: 8px; font-size: 0.95rem; color: var(--accent-green);">💵 Cash on Delivery Available</h4>
                            <p style="font-size: 0.88rem; color: var(--text-body); line-height: 1.5;">
                                Pay conveniently using Cash or any UPI App when your package is delivered to your doorstep.
                            </p>
                            <div style="margin-top: 10px; background: var(--accent-green-bg); padding: 8px 12px; border-radius: var(--radius-sm); font-size: 0.85rem; color: var(--accent-green); font-weight: 600;">
                                ✓ No advance payment required
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Order Summary Sidebar -->
                <div class="cart-summary-box">
                    <h3 style="margin-bottom: 16px; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;">
                        Order Summary
                    </h3>

                    <!-- Mini Items List -->
                    <div style="max-height: 220px; overflow-y: auto; margin-bottom: 16px; padding-right: 4px;">
                        <% if (items != null) { for (CartItem it : items) { %>
                            <div class="checkout-item-mini">
                                <div style="flex: 1;">
                                    <div style="font-weight: 600; font-size: 0.88rem; color: var(--text-heading); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 220px;">
                                        <%= it.name %>
                                    </div>
                                    <div style="font-size: 0.8rem; color: var(--text-muted);">
                                        Qty: <%= it.quantity %> × ₹<%= it.price %>
                                    </div>
                                </div>
                                <div style="font-weight: 700; font-size: 0.9rem; color: var(--text-heading);">
                                    ₹ <%= it.total() %>
                                </div>
                            </div>
                        <% }} %>
                    </div>

                    <div class="summary-line">
                        <span>Items Total</span>
                        <span>₹ <%= request.getAttribute("total") %></span>
                    </div>

                    <div class="summary-line">
                        <span>Delivery Charges</span>
                        <span style="color: var(--accent-green); font-weight: 700;">FREE</span>
                    </div>

                    <div class="summary-line">
                        <span>Estimated Savings</span>
                        <span style="color: var(--accent-green); font-weight: 700;">-₹ 150.00</span>
                    </div>

                    <div class="summary-total">
                        <span>Total Payable</span>
                        <span style="color: var(--primary);">₹ <%= request.getAttribute("total") %></span>
                    </div>

                    <button class="btn full" style="margin-top: 24px; padding: 14px; font-size: 1.05rem;" type="submit" id="placeOrderBtn">
                        Place Order & Pay ₹<%= request.getAttribute("total") %> →
                    </button>

                    <div style="margin-top: 16px; display: flex; flex-direction: column; gap: 8px; font-size: 0.8rem; color: var(--text-muted); text-align: center;">
                        <div>🔒 100% Safe and Secure Encrypted Checkout</div>
                        <div>🔄 7-Day Hassle-Free Returns & Full Refund</div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
        function switchPayment(method) {
            // Update Card selected styling
            document.querySelectorAll('.payment-method-card').forEach(c => c.classList.remove('selected'));
            const cardMap = {
                'CARD': 'cardOption',
                'UPI': 'upiOption',
                'NET_BANKING': 'netOption',
                'COD': 'codOption'
            };
            const activeCard = document.getElementById(cardMap[method]);
            if (activeCard) activeCard.classList.add('selected');

            // Hide all panels and show selected
            document.querySelectorAll('.payment-details-panel').forEach(p => p.classList.remove('active'));
            const targetPanel = document.getElementById('panel-' + method);
            if (targetPanel) targetPanel.classList.add('active');

            // Update button label
            const btn = document.getElementById('placeOrderBtn');
            const total = '<%= request.getAttribute("total") %>';
            if (method === 'COD') {
                btn.innerHTML = 'Confirm Cash on Delivery Order (₹' + total + ') →';
            } else {
                btn.innerHTML = 'Place Order & Pay ₹' + total + ' →';
            }
        }
    </script>
</body>
</html>
