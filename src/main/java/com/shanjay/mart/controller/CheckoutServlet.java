package com.shanjay.mart.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

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

public class CheckoutServlet extends HttpServlet {
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
            var items = shop.getCart(user.id);
            if (items == null || items.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/cart?error=CartIsEmpty");
                return;
            }

            req.setAttribute("items", items);
            req.setAttribute("total", shop.total(items));
            req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String name = req.getParameter("shippingName");
            String phone = req.getParameter("shippingPhone");
            String address = req.getParameter("shippingAddress");
            String city = req.getParameter("shippingCity");
            String pincode = req.getParameter("shippingPincode");
            String method = req.getParameter("paymentMethod");

            long orderId = shop.checkout(user.id, name, phone, address, city, pincode, method);
            resp.sendRedirect(req.getContextPath() + "/orders?success=" + orderId);
        } catch (Exception e) {
            String err = URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Checkout failed", StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/checkout?error=" + err);
        }
    }
}
