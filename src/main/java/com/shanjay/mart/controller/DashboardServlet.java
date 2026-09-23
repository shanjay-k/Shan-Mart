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
import com.shanjay.mart.dao.UserDAO;
import com.shanjay.mart.model.User;
import com.shanjay.mart.service.ShopService;

public class DashboardServlet extends HttpServlet {
    private ShopService shop;
    private UserDAO userDAO;

    @Override
    public void init() {
        DataSource ds = (DataSource) getServletContext().getAttribute("ds");
        shop = new ShopService(new ProductDAO(ds), new CartDAO(ds), new OrderDAO(ds), new ReviewDAO(ds));
        userDAO = new UserDAO(ds);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("BUYER".equalsIgnoreCase(user.role)) {
            resp.sendRedirect(req.getContextPath() + "/shop");
            return;
        }

        try {
            if ("SELLER".equalsIgnoreCase(user.role)) {
                req.setAttribute("products", shop.getSellerProducts(user.id));
                req.setAttribute("orders", shop.sellerOrders(user.id));
                req.getRequestDispatcher("/WEB-INF/views/seller.jsp").forward(req, resp);
            } else if ("ADMIN".equalsIgnoreCase(user.role)) {
                req.setAttribute("users", userDAO.all());
                req.setAttribute("products", shop.getAllProducts());
                req.setAttribute("orders", shop.allOrders());
                req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/shop");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
