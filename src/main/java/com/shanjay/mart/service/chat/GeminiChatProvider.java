package com.shanjay.mart.service.chat;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class GeminiChatProvider implements ChatProvider {
    private final String apiKey;
    private final ObjectMapper mapper = new ObjectMapper();

    public GeminiChatProvider(String apiKey) {
        this.apiKey = apiKey;
    }

    @Override
    public String ask(String userMessage, String context) throws Exception {
        if (apiKey == null || apiKey.trim().isEmpty()) {
            throw new IllegalStateException("Gemini API key is not configured.");
        }

        String prompt = "System: You are SHAN MART AI Assistant, an e-commerce customer support chatbot. " +
                "Only answer questions related to SHAN MART products, order tracking, shipping, payments, returns, and seller registration. " +
                "Be polite, concise, and helpful.\n\n" +
                "Context: " + (context != null ? context : "SHAN MART E-Commerce Platform") + "\n" +
                "Customer Question: " + userMessage;

        String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey.trim();

        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(7000);
        conn.setDoOutput(true);

        String jsonPayload = mapper.writeValueAsString(
            mapper.createObjectNode()
                .set("contents", mapper.createArrayNode().add(
                    mapper.createObjectNode()
                        .set("parts", mapper.createArrayNode().add(
                            mapper.createObjectNode().put("text", prompt)
                        ))
                ))
        );

        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonPayload.getBytes(StandardCharsets.UTF_8));
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            try (InputStream is = conn.getInputStream()) {
                JsonNode root = mapper.readTree(is);
                JsonNode candidates = root.path("candidates");
                if (candidates.isArray() && candidates.size() > 0) {
                    JsonNode textNode = candidates.get(0).path("content").path("parts").get(0).path("text");
                    if (!textNode.isMissingNode()) {
                        return textNode.asText().trim();
                    }
                }
            }
        }

        throw new RuntimeException("Gemini API request failed with status code " + responseCode);
    }
}
