package com.shanjay.mart.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.shanjay.mart.dao.CartDAO;
import com.shanjay.mart.dao.OrderDAO;
import com.shanjay.mart.dao.ProductDAO;
import com.shanjay.mart.dao.ReviewDAO;
import com.shanjay.mart.dao.WishlistDAO;
import com.shanjay.mart.dto.ApiResponse;
import com.shanjay.mart.model.User;
import com.shanjay.mart.model.WishlistItem;
import com.shanjay.mart.service.ShopService;

public class WishlistServlet extends HttpServlet {
    private ShopService shop;
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public void init() {
        DataSource ds = (DataSource) getServletContext().getAttribute("ds");
        shop = new ShopService(new ProductDAO(ds), new CartDAO(ds), new OrderDAO(ds), new ReviewDAO(ds), new WishlistDAO(ds));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String checkPid = req.getParameter("check");
        if (checkPid != null && !checkPid.isBlank()) {
            resp.setContentType("application/json");
            try {
                boolean wishlisted = shop.isWishlisted(user.id, Long.parseLong(checkPid.trim()));
                mapper.writeValue(resp.getWriter(), ApiResponse.ok(wishlisted));
            } catch (Exception e) {
                mapper.writeValue(resp.getWriter(), ApiResponse.fail(e.getMessage()));
            }
            return;
        }

        try {
            List<WishlistItem> items = shop.getWishlist(user.id);
            req.setAttribute("items", items);
            req.setAttribute("wishlistCount", items.size());
            req.getRequestDispatcher("/WEB-INF/views/wishlist.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
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
        String redirect = req.getParameter("redirect");
        boolean isJson = "json".equalsIgnoreCase(req.getParameter("format"));

        try {
            long productId = Long.parseLong(req.getParameter("productId"));

            if ("remove".equalsIgnoreCase(action)) {
                shop.removeWishlist(user.id, productId);
                if (isJson) {
                    resp.setContentType("application/json");
                    mapper.writeValue(resp.getWriter(), ApiResponse.ok("Removed from wishlist"));
                    return;
                }
                resp.sendRedirect(req.getContextPath() + "/wishlist?removed=1");
            } else if ("moveToCart".equalsIgnoreCase(action)) {
                int qty = 1;
                String qStr = req.getParameter("quantity");
                if (qStr != null && !qStr.isBlank()) {
                    qty = Integer.parseInt(qStr.trim());
                }
                shop.moveWishlistToCart(user.id, productId, qty);
                resp.sendRedirect(req.getContextPath() + "/cart?fromWishlist=1");
            } else {
                // Default: add
                shop.addWishlist(user.id, productId);
                if (isJson) {
                    resp.setContentType("application/json");
                    mapper.writeValue(resp.getWriter(), ApiResponse.ok("Added to wishlist"));
                    return;
                }
                if (redirect != null && !redirect.isBlank()) {
                    resp.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") + "wishlistAdded=1");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/wishlist?added=1");
                }
            }
        } catch (Exception e) {
            if (isJson) {
                resp.setContentType("application/json");
                mapper.writeValue(resp.getWriter(), ApiResponse.fail(e.getMessage()));
                return;
            }
            if (redirect != null && !redirect.isBlank()) {
                resp.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") + "wishlistError=1");
            } else {
                resp.sendRedirect(req.getContextPath() + "/wishlist?error=1");
            }
        }
    }
}
