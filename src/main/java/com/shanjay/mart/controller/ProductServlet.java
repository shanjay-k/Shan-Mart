package com.shanjay.mart.controller;

import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.shanjay.mart.dao.CartDAO;
import com.shanjay.mart.dao.OrderDAO;
import com.shanjay.mart.dao.ProductDAO;
import com.shanjay.mart.dao.ReviewDAO;
import com.shanjay.mart.model.Product;
import com.shanjay.mart.model.User;
import com.shanjay.mart.service.ShopService;

public class ProductServlet extends HttpServlet {
    private ShopService shop;

    @Override
    public void init() {
        DataSource ds = (DataSource) getServletContext().getAttribute("ds");
        shop = new ShopService(new ProductDAO(ds), new CartDAO(ds), new OrderDAO(ds), new ReviewDAO(ds));
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
