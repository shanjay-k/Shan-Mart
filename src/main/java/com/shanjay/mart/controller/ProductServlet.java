package com.shanjay.mart.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.shanjay.mart.dao.CartDAO;
import com.shanjay.mart.dao.OrderDAO;
import com.shanjay.mart.dao.ProductDAO;
import com.shanjay.mart.dao.ReviewDAO;
import com.shanjay.mart.dao.WishlistDAO;
import com.shanjay.mart.model.Product;
import com.shanjay.mart.model.Review;
import com.shanjay.mart.model.User;
import com.shanjay.mart.service.ShopService;

public class ProductServlet extends HttpServlet {
    private ShopService shop;

    @Override
    public void init() {
        DataSource ds = (DataSource) getServletContext().getAttribute("ds");
        shop = new ShopService(new ProductDAO(ds), new CartDAO(ds), new OrderDAO(ds), new ReviewDAO(ds), new WishlistDAO(ds));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/shop");
            return;
        }

        try {
            long id = Long.parseLong(idStr.trim());
            Product p = shop.getProduct(id);
            if (p == null) {
                resp.sendRedirect(req.getContextPath() + "/shop");
                return;
            }

            List<Review> reviews = shop.getProductReviews(id);
            double avgRating = shop.getProductAverageRating(id);
            int reviewCount = shop.getProductReviewCount(id);
            List<Product> related = shop.getRelatedProducts(id, p.category, 4);

            User user = (User) req.getSession().getAttribute("user");
            boolean isWishlisted = false;
            if (user != null) {
                isWishlisted = shop.isWishlisted(user.id, id);
            }

            req.setAttribute("product", p);
            req.setAttribute("reviews", reviews);
            req.setAttribute("avgRating", avgRating > 0 ? avgRating : 4.5);
            req.setAttribute("reviewCount", reviewCount);
            req.setAttribute("relatedProducts", related);
            req.setAttribute("isWishlisted", isWishlisted);

            req.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/shop");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("delete".equals(action)) {
                long id = Long.parseLong(req.getParameter("id"));
                shop.deleteProduct(id, user.id);
            } else if ("adminDelete".equals(action) && "ADMIN".equalsIgnoreCase(user.role)) {
                long id = Long.parseLong(req.getParameter("id"));
                shop.adminDeleteProduct(id);
            } else if ("update".equals(action)) {
                long id = Long.parseLong(req.getParameter("id"));
                Product p = new Product();
                p.id = id;
                p.sellerId = user.id;
                p.name = req.getParameter("name");
                p.description = req.getParameter("description");
                p.price = new BigDecimal(req.getParameter("price"));
                p.stockQty = Integer.parseInt(req.getParameter("stockQty"));
                p.category = req.getParameter("category");
                p.imageUrl = req.getParameter("imageUrl");
                shop.updateProduct(p);
            } else {
                Product p = new Product();
                p.sellerId = user.id;
                p.name = req.getParameter("name");
                p.description = req.getParameter("description");
                p.price = new BigDecimal(req.getParameter("price"));
                p.stockQty = Integer.parseInt(req.getParameter("stockQty"));
                p.category = req.getParameter("category");
                p.imageUrl = req.getParameter("imageUrl");
                shop.addProduct(p);
            }
            resp.sendRedirect(req.getContextPath() + "/dashboard?success=1");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?error=" + (e.getMessage() != null ? e.getMessage() : "1"));
        }
    }
}
