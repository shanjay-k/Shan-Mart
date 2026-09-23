package com.shanjay.mart.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.shanjay.mart.dao.CartDAO;
import com.shanjay.mart.dao.OrderDAO;
import com.shanjay.mart.dao.ProductDAO;
import com.shanjay.mart.dao.ReviewDAO;
import com.shanjay.mart.service.ShopService;

public class ShopServlet extends HttpServlet {
    private ShopService shop;

    @Override
    public void init() {
        DataSource ds = (DataSource) getServletContext().getAttribute("ds");
        shop = new ShopService(new ProductDAO(ds), new CartDAO(ds), new OrderDAO(ds), new ReviewDAO(ds));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String query = request.getParameter("q");
            String category = request.getParameter("category");

            if (query == null) query = "";
            if (category == null) category = "";

            request.setAttribute("products", shop.search(query, category));
            request.setAttribute("ratingsMap", shop.getAllProductRatings());
            request.setAttribute("reviewsCountMap", shop.getAllProductReviewCounts());
            request.getRequestDispatcher("/WEB-INF/views/buyer.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}