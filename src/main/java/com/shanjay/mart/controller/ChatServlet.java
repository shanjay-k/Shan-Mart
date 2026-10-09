package com.shanjay.mart.controller;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shanjay.mart.dto.ApiResponse;
import com.shanjay.mart.service.chat.ChatService;

public class ChatServlet extends HttpServlet {
    private ChatService chatService;
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public void init() {
        chatService = new ChatService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String message = null;

        String contentType = req.getContentType();
        if (contentType != null && contentType.toLowerCase().contains("application/json")) {
            try {
                JsonNode json = mapper.readTree(req.getInputStream());
                if (json != null && json.has("message")) {
                    message = json.get("message").asText();
                }
            } catch (Exception ignored) {
            }
        }

        if (message == null) {
            message = req.getParameter("message");
        }

        String sessionId = req.getSession(true).getId();
        String reply = chatService.processUserMessage(sessionId, message);

        Map<String, String> data = new LinkedHashMap<>();
        data.put("reply", reply);

        ApiResponse<Map<String, String>> response = ApiResponse.ok(data);
        mapper.writeValue(resp.getWriter(), response);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
