package com.shanjay.mart.service.chat;

import java.util.Locale;

public class MockChatProvider implements ChatProvider {

    @Override
    public String ask(String userMessage, String context) throws Exception {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return "Hello! I am ShanAI, your SHAN MART Virtual Assistant. How can I help you today?";
        }

        String q = userMessage.trim().toLowerCase(Locale.ROOT);

        if (q.contains("shipping") || q.contains("delivery") || q.contains("deliver")) {
            return "SHAN MART offers Free Delivery on all eligible orders across India! Standard delivery typically takes 2 to 4 business days.";
        } else if (q.contains("return") || q.contains("refund") || q.contains("exchange")) {
            return "We offer a 7-day hassle-free return policy on all products. If you receive a damaged or incorrect item, you can initiate a return directly from your Orders page for a full refund.";
        } else if (q.contains("payment") || q.contains("cod") || q.contains("pay") || q.contains("upi") || q.contains("card")) {
            return "We support multiple secure payment options: Cash on Delivery (COD), Credit/Debit Cards (Visa, MasterCard, RuPay), UPI (Google Pay, PhonePe, Paytm), and Net Banking.";
        } else if (q.contains("category") || q.contains("categories") || q.contains("product")) {
            return "SHAN MART features top categories including Electronics (Smartphones, Laptops, 4K TVs), Fashion (Shirts, Shoes, Backpacks), Home & Kitchen, Books, and Sports & Fitness equipment.";
        } else if (q.contains("seller") || q.contains("sell") || q.contains("list")) {
            return "Want to sell on SHAN MART? Simply register a Seller account or switch to Seller role to publish your product listings, set prices, and manage customer orders!";
        } else if (q.contains("order") || q.contains("track") || q.contains("history")) {
            return "You can track your placed orders and view shipment status (Pending, Confirmed, Shipped, Delivered) directly under the 'Orders' tab in your top navigation bar.";
        } else if (q.contains("contact") || q.contains("support") || q.contains("help")) {
            return "SHAN MART Customer Support is available 24/7. You can reach out via email at support@shanjaymart.local or ask ShanAI anytime.";
        } else if (q.contains("hi") || q.contains("hello") || q.contains("hey")) {
            return "Hello! Welcome to SHAN MART. I am ShanAI! I can help you with product queries, order tracking, returns, and payment options. What would you like to know?";
        } else {
            return "Thank you for contacting ShanAI! For queries regarding product availability, pricing, or order tracking, please visit our Storefront or Orders tab. Is there anything specific about shipping, payments, or returns I can help with?";
        }
    }
}
