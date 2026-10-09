package com.shanjay.mart.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.shanjay.mart.service.chat.ChatProvider;
import com.shanjay.mart.service.chat.ChatService;

public class ChatServiceTest {
    private ChatProvider mockPrimary;
    private ChatProvider mockFallback;
    private ChatService chatService;

    @BeforeEach
    void setUp() {
        mockPrimary = mock(ChatProvider.class);
        mockFallback = mock(ChatProvider.class);
        chatService = new ChatService(mockPrimary, mockFallback);
    }

    @Test
    void testProcessMessage_SuccessWithPrimary() throws Exception {
        when(mockPrimary.ask(anyString(), anyString())).thenReturn("Gemini answer about shipping");

        String result = chatService.processUserMessage("session-123", "What is your shipping policy?");
        assertEquals("Gemini answer about shipping", result);
        verify(mockPrimary, times(1)).ask(anyString(), anyString());
    }

    @Test
    void testProcessMessage_FallbackOnPrimaryException() throws Exception {
        when(mockPrimary.ask(anyString(), anyString())).thenThrow(new RuntimeException("API down"));
        when(mockFallback.ask(anyString(), anyString())).thenReturn("Fallback answer");

        String result = chatService.processUserMessage("session-456", "How do I return a product?");
        assertEquals("Fallback answer", result);
        verify(mockFallback, times(1)).ask(anyString(), anyString());
    }

    @Test
    void testProcessMessage_CachingPerSession() throws Exception {
        when(mockPrimary.ask(anyString(), anyString())).thenReturn("Cached Answer");

        String result1 = chatService.processUserMessage("session-789", "payment options");
        String result2 = chatService.processUserMessage("session-789", "payment options");

        assertEquals("Cached Answer", result1);
        assertEquals("Cached Answer", result2);
        // Primary provider should only be called ONCE due to session cache
        verify(mockPrimary, times(1)).ask(anyString(), anyString());
    }

    @Test
    void testProcessMessage_RateLimiting() throws Exception {
        when(mockPrimary.ask(anyString(), anyString())).thenReturn("OK");

        String sessionId = "rate-limit-session";
        for (int i = 0; i < 10; i++) {
            chatService.processUserMessage(sessionId, "Question " + i);
        }

        // 11th message should be rate limited
        String rateLimitedResult = chatService.processUserMessage(sessionId, "Question 11");
        assertTrue(rateLimitedResult.contains("too quickly"));
    }

    @Test
    void testProcessMessage_InputValidation() {
        String emptyResult = chatService.processUserMessage("session-0", "");
        assertNotNull(emptyResult);
        assertTrue(emptyResult.contains("Please type a message"));

        StringBuilder longMsg = new StringBuilder();
        for (int i = 0; i < 600; i++) longMsg.append("a");

        String longResult = chatService.processUserMessage("session-0", longMsg.toString());
        assertTrue(longResult.contains("under 500 characters"));
    }
}
