package com.shanjay.mart.service.chat;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class ChatService {
    private final ChatProvider primaryProvider;
    private final ChatProvider fallbackProvider;
    
    // Per-session message timestamps for rate limiting (max 10 msgs / min)
    private final Map<String, java.util.List<Long>> sessionTimestamps = new ConcurrentHashMap<>();
    
    // Per-session question cache: sessionId -> Map<NormalizedQuery, Answer>
    private final Map<String, Map<String, String>> sessionCaches = new ConcurrentHashMap<>();

    public ChatService() {
        this(null);
    }

    public ChatService(String configuredProvider) {
        String apiKey = System.getenv("GEMINI_API_KEY");
        if (apiKey == null || apiKey.trim().isEmpty()) {
            apiKey = System.getProperty("ai.chatbot.gemini.key");
        }

        String providerName = configuredProvider != null ? configuredProvider : System.getProperty("ai.chatbot.provider", "mock");
        
        this.fallbackProvider = new MockChatProvider();
        if ("gemini".equalsIgnoreCase(providerName) && apiKey != null && !apiKey.trim().isEmpty()) {
            this.primaryProvider = new GeminiChatProvider(apiKey);
        } else {
            this.primaryProvider = this.fallbackProvider;
        }
    }

    public ChatService(ChatProvider primary, ChatProvider fallback) {
        this.primaryProvider = primary != null ? primary : new MockChatProvider();
        this.fallbackProvider = fallback != null ? fallback : new MockChatProvider();
    }

    public String processUserMessage(String sessionId, String rawMessage) {
        if (rawMessage == null || rawMessage.trim().isEmpty()) {
            return "Please type a message or question about SHAN MART!";
        }

        String message = rawMessage.trim();
        if (message.length() > 500) {
            return "Your question is a bit long. Please keep your inquiry under 500 characters.";
        }

        // Rate limit check: max 10 requests per 60 seconds per session
        if (sessionId != null && isRateLimited(sessionId)) {
            return "⏳ You are sending messages too quickly! Please wait a moment before asking another question (limit: 10 messages/min).";
        }

        // In-session cache check
        String normKey = message.toLowerCase();
        if (sessionId != null) {
            Map<String, String> cache = sessionCaches.computeIfAbsent(sessionId, k -> new ConcurrentHashMap<>());
            if (cache.containsKey(normKey)) {
                return cache.get(normKey);
            }
        }

        // Call AI Provider with Fallback
        String response;
        try {
            response = primaryProvider.ask(message, "SHAN MART E-Commerce Catalog & Support");
        } catch (Exception e) {
            try {
                response = fallbackProvider.ask(message, "SHAN MART Fallback");
            } catch (Exception fallbackError) {
                response = "Welcome to SHAN MART! I am ShanAI. How can I assist you with products, orders, shipping, or returns today?";
            }

        }

        // Save in cache
        if (sessionId != null && response != null) {
            sessionCaches.computeIfAbsent(sessionId, k -> new ConcurrentHashMap<>()).put(normKey, response);
        }

        return response;
    }

    private synchronized boolean isRateLimited(String sessionId) {
        long now = System.currentTimeMillis();
        long windowStart = now - 60000; // 1 minute window

        java.util.List<Long> timestamps = sessionTimestamps.computeIfAbsent(sessionId, k -> new java.util.ArrayList<>());
        timestamps.removeIf(t -> t < windowStart);

        if (timestamps.size() >= 10) {
            return true;
        }

        timestamps.add(now);
        return false;
    }
}
