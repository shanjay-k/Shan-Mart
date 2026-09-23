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
import com.shanjay.mart.model.User;
import com.shanjay.mart.service.ShopService;

public class OrdersServlet extends HttpServlet {
    private ShopService shop;

    @Override
    public void init() {
        DataSource ds = (DataSource) getServletContext().getAttribute("ds");
        shop = new ShopService(new ProductDAO(ds), new CartDAO(ds), new OrderDAO(ds), new ReviewDAO(ds));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            if ("ADMIN".equalsIgnoreCase(user.role)) {
                req.setAttribute("orders", shop.allOrders());
            } else if ("SELLER".equalsIgnoreCase(user.role)) {
                req.setAttribute("orders", shop.sellerOrders(user.id));
            } else {
                req.setAttribute("orders", shop.buyerOrders(user.id));
            }
            req.getRequestDispatcher("/WEB-INF/views/orders.jsp").forward(req, resp);
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
        if ("updateStatus".equals(action) && ("SELLER".equalsIgnoreCase(user.role) || "ADMIN".equalsIgnoreCase(user.role))) {
            try {
                long orderId = Long.parseLong(req.getParameter("orderId"));
                String newStatus = req.getParameter("status");
                shop.updateOrderStatus(orderId, newStatus);
                resp.sendRedirect(req.getContextPath() + "/orders?statusUpdated=1");
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/orders?error=1");
                return;
            }
        }

        resp.sendRedirect(req.getContextPath() + "/orders");
    }
}
