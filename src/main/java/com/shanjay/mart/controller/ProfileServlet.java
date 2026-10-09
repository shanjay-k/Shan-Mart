package com.shanjay.mart.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.shanjay.mart.dao.CartDAO;
import com.shanjay.mart.dao.OrderDAO;
import com.shanjay.mart.dao.ProductDAO;
import com.shanjay.mart.dao.ReviewDAO;
import com.shanjay.mart.dao.UserDAO;
import com.shanjay.mart.dao.WishlistDAO;
import com.shanjay.mart.model.User;
import com.shanjay.mart.service.AuthService;
import com.shanjay.mart.service.ShopService;

public class ProfileServlet extends HttpServlet {
    private AuthService auth;
    private ShopService shop;
    private UserDAO userDAO;

    @Override
    public void init() {
        DataSource ds = (DataSource) getServletContext().getAttribute("ds");
        userDAO = new UserDAO(ds);
        auth = new AuthService(userDAO);
        shop = new ShopService(new ProductDAO(ds), new CartDAO(ds), new OrderDAO(ds), new ReviewDAO(ds), new WishlistDAO(ds));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            User current = auth.getUser(user.id);
            if (current == null) {
                current = user;
            }
            req.setAttribute("userProfile", current);

            Map<String, Object> stats;
            if ("SELLER".equalsIgnoreCase(current.role)) {
                stats = shop.getSellerStats(current.id);
            } else if ("ADMIN".equalsIgnoreCase(current.role)) {
                stats = shop.getAdminStats(userDAO.all().size());
            } else {
                stats = shop.getBuyerStats(current.id);
            }
            req.setAttribute("stats", stats);

            req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
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

        try {
            if ("updateName".equalsIgnoreCase(action)) {
                String name = req.getParameter("name");
                auth.updateProfile(user.id, name);
                user.name = name.trim();
                req.getSession().setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/profile?profileUpdated=1");
            } else if ("changePassword".equalsIgnoreCase(action)) {
                String oldPass = req.getParameter("oldPassword");
                String newPass = req.getParameter("newPassword");
                String confirmPass = req.getParameter("confirmPassword");

                if (newPass == null || !newPass.equals(confirmPass)) {
                    throw new IllegalArgumentException("New passwords do not match.");
                }

                auth.changePassword(user.id, oldPass, newPass);
                resp.sendRedirect(req.getContextPath() + "/profile?passwordUpdated=1");
            } else {
                resp.sendRedirect(req.getContextPath() + "/profile");
            }
        } catch (Exception e) {
            String err = URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Operation failed", StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/profile?error=" + err);
        }
    }
}
