package com.shanjay.mart.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.fasterxml.jackson.databind.ObjectMapper;

public class HealthServlet extends HttpServlet {
    private DataSource ds;
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public void init() {
        ds = (DataSource) getServletContext().getAttribute("ds");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        Map<String, String> status = new LinkedHashMap<>();
        boolean dbOk = false;

        if (ds != null) {
            try (Connection c = ds.getConnection();
                 PreparedStatement p = c.prepareStatement("SELECT 1");
                 ResultSet r = p.executeQuery()) {
                if (r.next()) {
                    dbOk = true;
                }
            } catch (Exception ignored) {
            }
        }

        if (dbOk) {
            status.put("status", "UP");
            status.put("db", "UP");
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            status.put("status", "DOWN");
            status.put("db", "DOWN");
            resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        }

        mapper.writeValue(resp.getWriter(), status);
    }
}
