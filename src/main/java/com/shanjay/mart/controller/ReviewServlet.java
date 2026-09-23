package com.shanjay.mart.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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
import com.shanjay.mart.dto.ApiResponse;
import com.shanjay.mart.model.Review;
import com.shanjay.mart.model.User;
import com.shanjay.mart.service.ShopService;

public class ReviewServlet extends HttpServlet {
    private ShopService shop;
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public void init() {
        DataSource ds = (DataSource) getServletContext().getAttribute("ds");
        shop = new ShopService(new ProductDAO(ds), new CartDAO(ds), new OrderDAO(ds), new ReviewDAO(ds));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pidStr = req.getParameter("productId");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if (pidStr == null || pidStr.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            mapper.writeValue(resp.getWriter(), ApiResponse.fail("productId parameter is required."));
            return;
        }

        try {
            long productId = Long.parseLong(pidStr);
            List<Review> list = shop.getProductReviews(productId);
            mapper.writeValue(resp.getWriter(), ApiResponse.ok(list));
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            mapper.writeValue(resp.getWriter(), ApiResponse.fail(e.getMessage()));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String redirect = req.getParameter("redirect");
        if (redirect == null || redirect.isBlank()) {
            redirect = req.getContextPath() + "/orders";
        }

        try {
            long productId = Long.parseLong(req.getParameter("productId"));
            int rating = Integer.parseInt(req.getParameter("rating"));
            String comment = req.getParameter("comment");

            shop.addReview(user.id, productId, rating, comment);
            resp.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") + "reviewed=1");
        } catch (Exception e) {
            String err = URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Review failed", StandardCharsets.UTF_8);
            resp.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") + "reviewError=" + err);
        }
    }
}
