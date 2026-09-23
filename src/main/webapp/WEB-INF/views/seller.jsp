<%@ page import="java.util.List,com.shanjay.mart.model.Product,com.shanjay.mart.model.Order,com.shanjay.mart.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Central & Inventory | SHAN MART</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <nav class="bar">
        <a href="${pageContext.request.contextPath}/dashboard" class="brand-logo">
            🛒 SHAN MART <span style="font-size: 0.85rem; font-weight: 600; color: var(--text-muted); background: var(--border-light); padding: 3px 8px; border-radius: 4px; margin-left: 6px;">Seller Central</span>
        </a>

        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/orders">
                <span>📦</span> Incoming Customer Orders
            </a>
            <a href="${pageContext.request.contextPath}/shop">
                <span>🛍️</span> Storefront Preview
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
                ✓ Product inventory updated successfully!
            </div>
        <% } %>

        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 24px;">
            <div>
                <h2>Seller Inventory Dashboard</h2>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 4px;">
                    Manage your marketplace listings, stock levels, and pricing
                </p>
            </div>
            <button type="button" class="btn" onclick="document.getElementById('newProductCard').scrollIntoView({behavior: 'smooth'})">
                ➕ Add New Listing
            </button>
        </div>

        <!-- Listings Management Table (F2, Week 3-4) -->
        <div class="card" style="max-width: 100%; box-shadow: var(--shadow-sm); padding: 24px; margin-bottom: 32px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; border-bottom: 1px solid var(--border-light); padding-bottom: 12px;">
                <h3>Your Active Listings</h3>
                <% 
                    List<Product> products = (List<Product>) request.getAttribute("products"); 
                    int totalListings = products != null ? products.size() : 0;
                %>
                <span class="category-pill active"><%= totalListings %> Listed Products</span>
            </div>

            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock Qty</th>
                            <th>Status</th>
                            <th>Actions</th>
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
                                        <img src="<%= pImg %>" alt="<%= p.name %>" style="width: 44px; height: 44px; object-fit: cover; border-radius: 4px; border: 1px solid var(--border-color);" onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600'">
                                        <div>
                                            <div style="font-weight: 700; color: var(--text-heading);"><%= p.name %></div>
                                            <div style="font-size: 0.78rem; color: var(--text-muted); max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                <%= p.description %>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="category-tag"><%= p.category %></span></td>
                                <td><b style="color: var(--primary);">₹ <%= p.price %></b></td>
                                <td><b><%= p.stockQty %></b> units</td>
                                <td>
                                    <% if (p.stockQty > 10) { %>
                                        <span class="badge-status badge-confirmed">In Stock</span>
                                    <% } else if (p.stockQty > 0) { %>
                                        <span class="badge-status badge-pending">Low Stock</span>
                                    <% } else { %>
                                        <span class="badge-status badge-cancelled">Out of Stock</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <button type="button" class="btn-outline" style="padding: 4px 10px; font-size: 0.8rem;" 
                                                onclick="openEditModal(<%= p.id %>, '<%= p.name.replace("'", "\\'") %>', '<%= p.description != null ? p.description.replace("'", "\\'") : "" %>', '<%= p.price %>', <%= p.stockQty %>, '<%= p.category %>', '<%= p.imageUrl %>')">
                                            ✏️ Edit
                                        </button>
                                        <form method="post" action="${pageContext.request.contextPath}/product" style="display: inline; margin: 0; padding: 0; background: none; border: none;" onsubmit="return confirm('Delete this product listing?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= p.id %>">
                                            <button type="submit" class="btn-outline" style="padding: 4px 10px; font-size: 0.8rem; border-color: #EF4444; color: #EF4444;">
                                                🗑️
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <% }} else { %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 32px; color: var(--text-muted);">
                                    No products listed yet. Fill out the form below to publish your first listing!
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Add New Product Card -->
        <div id="newProductCard" class="card" style="max-width: 100%; box-shadow: var(--shadow-sm); padding: 28px;">
            <h3 style="margin-bottom: 18px; border-bottom: 1px solid var(--border-light); padding-bottom: 10px;">
                ➕ List a New Product
            </h3>

            <form class="formbox" method="post" action="${pageContext.request.contextPath}/product" style="padding: 0; border: none; box-shadow: none; max-width: 100%; margin: 0;">
                <label for="pname">Product Title *</label>
                <input id="pname" name="name" placeholder="e.g. Wireless Noise-Cancelling Earbuds / Running Shoes" required>

                <label for="pdesc">Product Description</label>
                <textarea id="pdesc" name="description" placeholder="Provide detailed specifications, features, material, warranty..."></textarea>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div>
                        <label for="pprice">Price (₹) *</label>
                        <input id="pprice" name="price" type="number" step="0.01" min="1" placeholder="999.00" required>
                    </div>
                    <div>
                        <label for="pstock">Initial Stock Quantity *</label>
                        <input id="pstock" name="stockQty" type="number" min="0" placeholder="50" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div>
                        <label for="pcat">Category *</label>
                        <select id="pcat" name="category" required style="padding: 12px; border: 1.5px solid var(--border-color); border-radius: var(--radius-sm); width: 100%;">
                            <option value="Electronics">Electronics</option>
                            <option value="Fashion">Fashion</option>
                            <option value="Home & Kitchen">Home & Kitchen</option>
                            <option value="Books">Books</option>
                            <option value="Sports">Sports</option>
                        </select>
                    </div>
                    <div>
                        <label for="pimg">Image URL</label>
                        <input id="pimg" name="imageUrl" placeholder="https://images.unsplash.com/photo-...">
                    </div>
                </div>

                <button class="btn full" style="margin-top: 18px; padding: 13px; font-size: 1rem;" type="submit">
                    Publish Product to Store 🚀
                </button>
            </form>
        </div>
    </div>

    <!-- Edit Product Modal -->
    <div id="editProductModal" class="modal-overlay" onclick="if(event.target===this) closeEditModal()">
        <div class="modal-box">
            <button class="modal-close-btn" onclick="closeEditModal()">✕</button>
            <h3 style="margin-bottom: 16px;">Edit Product Listing</h3>

            <form method="post" action="${pageContext.request.contextPath}/product">
                <input type="hidden" name="action" value="update">
                <input type="hidden" id="editId" name="id">

                <div class="field-group">
                    <label>Product Title *</label>
                    <input id="editName" name="name" required>
                </div>

                <div class="field-group">
                    <label>Description</label>
                    <textarea id="editDesc" name="description" rows="3"></textarea>
                </div>

                <div class="form-grid-2">
                    <div class="field-group">
                        <label>Price (₹) *</label>
                        <input id="editPrice" name="price" type="number" step="0.01" min="1" required>
                    </div>
                    <div class="field-group">
                        <label>Stock Qty *</label>
                        <input id="editStock" name="stockQty" type="number" min="0" required>
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="field-group">
                        <label>Category *</label>
                        <select id="editCat" name="category" required style="padding: 11px; border: 1.5px solid var(--border-color); border-radius: var(--radius-sm); width: 100%;">
                            <option value="Electronics">Electronics</option>
                            <option value="Fashion">Fashion</option>
                            <option value="Home & Kitchen">Home & Kitchen</option>
                            <option value="Books">Books</option>
                            <option value="Sports">Sports</option>
                        </select>
                    </div>
                    <div class="field-group">
                        <label>Image URL</label>
                        <input id="editImg" name="imageUrl">
                    </div>
                </div>

                <button type="submit" class="btn full" style="margin-top: 14px; padding: 12px;">Save Changes ✓</button>
            </form>
        </div>
    </div>

    <script>
        function openEditModal(id, name, desc, price, stock, cat, img) {
            document.getElementById('editId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editDesc').value = desc;
            document.getElementById('editPrice').value = price;
            document.getElementById('editStock').value = stock;
            document.getElementById('editCat').value = cat;
            document.getElementById('editImg').value = img || '';
            document.getElementById('editProductModal').classList.add('active');
        }

        function closeEditModal() {
            document.getElementById('editProductModal').classList.remove('active');
        }
    </script>
</body>
</html>
