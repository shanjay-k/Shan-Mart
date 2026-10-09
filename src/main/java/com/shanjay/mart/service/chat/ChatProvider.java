package com.shanjay.mart.service.chat;

public interface ChatProvider {
    String ask(String userMessage, String context) throws Exception;
}
