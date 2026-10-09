package com.shanjay.mart.controller;

import java.io.IOException;
import java.util.List;
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
import com.shanjay.mart.model.Order;
import com.shanjay.mart.model.Product;
import com.shanjay.mart.model.User;
import com.shanjay.mart.model.WishlistItem;
import com.shanjay.mart.service.ShopService;

public class DashboardServlet extends HttpServlet {
    private ShopService shop;
    private UserDAO userDAO;

    @Override
    public void init() {
        DataSource ds = (DataSource) getServletContext().getAttribute("ds");
        shop = new ShopService(new ProductDAO(ds), new CartDAO(ds), new OrderDAO(ds), new ReviewDAO(ds), new WishlistDAO(ds));
        userDAO = new UserDAO(ds);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            if ("BUYER".equalsIgnoreCase(user.role)) {
                Map<String, Object> stats = shop.getBuyerStats(user.id);
                List<Order> orders = shop.buyerOrders(user.id);
                List<WishlistItem> wishlist = shop.getWishlist(user.id);

                req.setAttribute("stats", stats);
                req.setAttribute("recentOrders", orders.size() > 5 ? orders.subList(0, 5) : orders);
                req.setAttribute("allOrdersCount", orders.size());
                req.setAttribute("wishlistItems", wishlist.size() > 4 ? wishlist.subList(0, 4) : wishlist);
                req.setAttribute("wishlistCount", wishlist.size());

                req.getRequestDispatcher("/WEB-INF/views/buyer-dashboard.jsp").forward(req, resp);
            } else if ("SELLER".equalsIgnoreCase(user.role)) {
                List<Product> products = shop.getSellerProducts(user.id);
                List<Order> orders = shop.sellerOrders(user.id);
                Map<String, Object> stats = shop.getSellerStats(user.id);

                req.setAttribute("products", products);
                req.setAttribute("orders", orders);
                req.setAttribute("stats", stats);
                req.getRequestDispatcher("/WEB-INF/views/seller.jsp").forward(req, resp);
            } else if ("ADMIN".equalsIgnoreCase(user.role)) {
                List<User> users = userDAO.all();
                List<Product> products = shop.getAllProducts();
                List<Order> orders = shop.allOrders();
                Map<String, Object> stats = shop.getAdminStats(users.size());

                req.setAttribute("users", users);
                req.setAttribute("products", products);
                req.setAttribute("orders", orders);
                req.setAttribute("stats", stats);
                req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/shop");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
