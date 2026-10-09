(function() {
    // Inject ShanAI Chatbot HTML into DOM on page load
    document.addEventListener("DOMContentLoaded", function() {
        if (document.getElementById("chatbotWidget")) return;

        const container = document.createElement("div");
        container.id = "chatbotWidget";
        container.innerHTML = `
            <button id="chatbotToggleBtn" class="chatbot-toggle-btn" onclick="toggleChatbot()" title="Open ShanAI Assistant">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                    <path d="M8 10h.01"></path>
                    <path d="M12 10h.01"></path>
                    <path d="M16 10h.01"></path>
                </svg>
                <span>Ask ShanAI</span>
            </button>

            <div id="chatbotWindow" class="chatbot-window">
                <div class="chatbot-header">
                    <div class="chatbot-title-box">
                        <div class="chatbot-avatar-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="11" width="18" height="10" rx="2"></rect>
                                <circle cx="12" cy="5" r="2"></circle>
                                <path d="M12 7v4"></path>
                                <line x1="8" y1="16" x2="8.01" y2="16"></line>
                                <line x1="16" y1="16" x2="16.01" y2="16"></line>
                            </svg>
                        </div>
                        <div>
                            <h3>ShanAI Assistant</h3>
                            <span class="chatbot-status-sub">24/7 E-Commerce AI Support</span>
                        </div>
                    </div>
                    <button class="chatbot-close-btn" onclick="toggleChatbot()" title="Close chat">&times;</button>
                </div>

                <div id="chatbotBody" class="chatbot-body">
                    <div class="chat-msg bot">
                        Hello! I am <b>ShanAI</b>, your SHAN MART virtual shopping assistant. Ask me anything about our catalog, order status, shipping, payments, or returns!
                    </div>
                </div>

                <div class="chatbot-faq-strip">
                    <button type="button" class="faq-chip" onclick="sendFaq('Track my order')">Track Order</button>
                    <button type="button" class="faq-chip" onclick="sendFaq('What payment methods are supported?')">Payments</button>
                    <button type="button" class="faq-chip" onclick="sendFaq('What is the return policy?')">Returns</button>
                    <button type="button" class="faq-chip" onclick="sendFaq('Is delivery free?')">Free Shipping</button>
                    <button type="button" class="faq-chip" onclick="sendFaq('How to sell on ShanjayMart?')">Sell on ShanMart</button>
                </div>

                <div class="chatbot-footer">
                    <input type="text" id="chatInput" placeholder="Ask ShanAI about products, orders..." onkeypress="if(event.key==='Enter') sendChatMsg()">
                    <button type="button" class="btn" onclick="sendChatMsg()">Send</button>
                </div>
            </div>
        `;
        document.body.appendChild(container);
    });

    window.toggleChatbot = function() {
        const win = document.getElementById("chatbotWindow");
        if (win) {
            win.classList.toggle("active");
            if (win.classList.contains("active")) {
                const input = document.getElementById("chatInput");
                if (input) input.focus();
            }
        }
    };

    window.sendFaq = function(text) {
        const input = document.getElementById("chatInput");
        if (input) {
            input.value = text;
            sendChatMsg();
        }
    };

    window.sendChatMsg = function() {
        const input = document.getElementById("chatInput");
        const body = document.getElementById("chatbotBody");
        if (!input || !body) return;

        const msg = input.value.trim();
        if (!msg) return;

        // Append User Message
        const userMsgElem = document.createElement("div");
        userMsgElem.className = "chat-msg user";
        userMsgElem.textContent = msg;
        body.appendChild(userMsgElem);

        input.value = "";
        body.scrollTop = body.scrollHeight;

        // Append Typing Indicator
        const typingElem = document.createElement("div");
        typingElem.className = "chat-msg bot typing-indicator";
        typingElem.innerHTML = "<span>ShanAI is thinking...</span>";
        body.appendChild(typingElem);
        body.scrollTop = body.scrollHeight;

        // Context path extraction
        let contextPath = window.location.pathname.startsWith('/shanjays-mart') ? '/shanjays-mart' : '';

        fetch(contextPath + '/api/chat', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({ message: msg })
        })
        .then(res => res.json())
        .then(data => {
            typingElem.remove();
            const botMsgElem = document.createElement("div");
            botMsgElem.className = "chat-msg bot";

            if (data && data.success && data.data && data.data.reply) {
                botMsgElem.innerHTML = formatReply(data.data.reply);
            } else if (data && data.reply) {
                botMsgElem.innerHTML = formatReply(data.reply);
            } else {
                botMsgElem.textContent = "I'm sorry, I couldn't process your question right now.";
            }

            body.appendChild(botMsgElem);
            body.scrollTop = body.scrollHeight;
        })
        .catch(err => {
            typingElem.remove();
            const botMsgElem = document.createElement("div");
            botMsgElem.className = "chat-msg bot";
            botMsgElem.innerHTML = "SHAN MART offers <b>Free Delivery</b>, 7-day easy returns, and Cash on Delivery (COD). You can track orders directly under the <b>Orders</b> tab!";
            body.appendChild(botMsgElem);
            body.scrollTop = body.scrollHeight;
        });
    };

    function formatReply(text) {
        if (!text) return "";
        // Sanitize & format text safely
        let formatted = text
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/\n/g, "<br>");
        return formatted;
    }
})();
