# SHAN MART Capstone — Final Comprehensive Report

**Course / Institution**: Anna University R2025, Semester 3  
**Project Name**: SHAN MART (`com.shanjay.mart`)  
**Technology Stack**: Java Servlets 4.0 · JDBC · HikariCP · H2 Database · Apache Tomcat 9.0.x · JUnit 5 & Mockito  
**Author / Builder**: Solo Capstone Build  

---

## 1. Executive Summary & Problem Statement

Modern e-commerce platforms require robust multi-role capabilities, real-time inventory synchronization, transparent order tracking, security hardening, and intelligent customer assistance. **SHAN MART** is a production-ready, full-stack Java web application engineered to solve these challenges.

The system provides:
- **Buyer Persona**: Seamless storefront browsing, keyword search, category filtering, cart management, multi-payment options (Card, UPI, Net Banking, COD), order tracking, and 5-star product review submission.
- **Seller Persona**: Dedicated Seller Central inventory dashboard to publish, edit, stock-manage, and fulfill incoming orders.
- **Admin Persona**: Platform-wide user account auditing, product catalog moderation, and executive KPI analytics.
- **AI Customer Assistant**: Embedded AI Chatbot (Phase 3) powered by `ChatProvider` architecture (Gemini REST API / Mock) offering instant 24/7 customer support.

---

## 2. System Architecture & Component Design

SHAN MART follows the standard 4-tier Java Enterprise Architecture pattern:

1. **Presentation Layer**: Responsive JSP views (`buyer.jsp`, `seller.jsp`, `admin.jsp`, `cart.jsp`, `checkout.jsp`, `orders.jsp`, `login.jsp`, `register.jsp`, `error.jsp`) styled with a modern Meesho/Amazon-inspired design system (`style.css`), dynamic AJAX modals, and a floating AI chatbot widget (`chatbot.js`).
2. **Control Layer**: Front-Controller Servlets implementing routing, authentication filters (`AuthFilter`), and global UTF-8 encoding filters (`EncodingFilter`).
3. **Service & Business Logic Layer**: `ShopService`, `AuthService`, and `ChatService` managing transaction rules, cart total calculations, field validation, rate limiting, and fallback handling.
4. **Data Access Layer**: Interface/DAO pattern (`UserDAO`, `ProductDAO`, `CartDAO`, `OrderDAO`, `ReviewDAO`) using parameterized `PreparedStatement` and HikariCP connection pooling against an H2 database engine.

---

## 3. Design Patterns Applied

| Design Pattern | Implementation Location | Purpose & Benefit |
|---|---|---|
| **DAO Pattern (Data Access Object)** | `UserDAO`, `ProductDAO`, `CartDAO`, `OrderDAO`, `ReviewDAO` | Encapsulates raw JDBC SQL operations, decoupling database interactions from domain services. |
| **Front Controller Pattern** | Servlets (`ShopServlet`, `CheckoutServlet`, `ChatServlet`, etc.) | Centralizes request handling, session management, view routing, and HTTP response formatting. |
| **Singleton Pattern** | `HikariDataSource` in `AppListener` | Ensures a single shared database connection pool lifecycle across the entire web application. |
| **Strategy Pattern** | `ChatProvider` (`MockChatProvider` vs `GeminiChatProvider`) | Enables dynamic runtime switching of LLM providers based on configuration (`ai.chatbot.provider`). |
| **Factory Pattern** | `ApiResponse.ok(data)` / `ApiResponse.fail(error)` | Standardizes REST JSON envelope creation across API endpoints. |
| **Builder / DTO Pattern** | `UserResponseDTO`, `CartItem`, `Order`, `Review` | Prevents exposing internal entity states (e.g. `passwordHash`) over public network payloads. |

---

## 4. Complete System Diagrams

### D1: Entity-Relationship Diagram (ERD)

```mermaid
erDiagram
    USERS ||--o{ PRODUCTS : "lists / sells"
    USERS ||--o{ ORDERS : "places (buyer)"
    USERS ||--o{ CART_ITEMS : "adds to cart"
    USERS ||--o{ REVIEWS : "writes"
    PRODUCTS ||--o{ CART_ITEMS : "contained in"
    PRODUCTS ||--o{ ORDER_ITEMS : "ordered as"
    PRODUCTS ||--o{ REVIEWS : "receives"
    ORDERS ||--|{ ORDER_ITEMS : "contains"
    USERS ||--o{ ORDER_ITEMS : "fulfills (seller)"

    USERS {
        bigint id PK
        varchar name
        varchar email UK
        varchar password_hash
        varchar role
        timestamp created_at
    }

    PRODUCTS {
        bigint id PK
        bigint seller_id FK
        varchar name
        varchar description
        decimal price
        int stock_qty
        varchar category
        varchar image_url
        timestamp created_at
    }

    CART_ITEMS {
        bigint id PK
        bigint buyer_id FK
        bigint product_id FK
        int quantity
        timestamp created_at
    }

    ORDERS {
        bigint id PK
        bigint buyer_id FK
        decimal total
        varchar status
        varchar shipping_name
        varchar shipping_phone
        varchar shipping_address
        varchar shipping_city
        varchar shipping_pincode
        varchar payment_method
        varchar payment_status
        timestamp created_at
    }

    ORDER_ITEMS {
        bigint id PK
        bigint order_id FK
        bigint product_id FK
        bigint seller_id FK
        int quantity
        decimal unit_price
        timestamp created_at
    }

    REVIEWS {
        bigint id PK
        bigint buyer_id FK
        bigint product_id FK
        int rating
        varchar comment
        timestamp created_at
    }
```

---

### D2: Use Case Diagram

```mermaid
graph TD
    subgraph Actors
        B[Buyer]
        S[Seller]
        A[Admin]
    end

    subgraph "SHAN MART System"
        UC1[Register / Login Auth - F1]
        UC2[Browse & Search Products - F3]
        UC3[Manage Cart & Items - F4]
        UC4[Checkout & Multi-Payment - F5]
        UC5[Track Order History - F6]
        UC6[Submit Product Reviews - F8]
        UC7[Interact with AI Chatbot - O4]
        
        UC8[Create / Edit / Delete Listings - F2]
        UC9[Manage Incoming Orders - F6]
        
        UC10[Audit Users & Orders - F7]
        UC11[Moderate / Delete Listings - F7]
    end

    B --> UC1
    B --> UC2
    B --> UC3
    B --> UC4
    B --> UC5
    B --> UC6
    B --> UC7

    S --> UC1
    S --> UC8
    S --> UC9
    S --> UC7

    A --> UC1
    A --> UC10
    A --> UC11
    A --> UC7
```

---

### D3: Sequence Diagram (Place-Order Flow)

```mermaid
sequenceDiagram
    autonumber
    actor Buyer as Buyer Client
    participant Controller as CheckoutServlet
    participant Service as ShopService
    participant CartDAO as CartDAO
    participant OrderDAO as OrderDAO
    participant DB as H2 Database

    Buyer->>Controller: POST /checkout (Shipping info + Payment method)
    Controller->>Service: checkout(buyerId, shipName, shipPhone, address, city, pin, paymentMethod)
    Service->>CartDAO: list(buyerId)
    CartDAO->>DB: SELECT * FROM cart_items WHERE buyer_id = ?
    DB-->>CartDAO: Return Cart Items
    CartDAO-->>Service: List<CartItem>
    
    Note over Service: Validate input fields & calculate order total
    
    Service->>OrderDAO: create(buyerId, total, shippingInfo, paymentMethod, items...)
    OrderDAO->>DB: BEGIN TRANSACTION
    OrderDAO->>DB: INSERT INTO orders(...)
    OrderDAO->>DB: INSERT INTO order_items(...)
    OrderDAO->>DB: UPDATE products SET stock_qty = stock_qty - ? WHERE id = ?
    OrderDAO->>DB: COMMIT TRANSACTION
    DB-->>OrderDAO: Order ID generated (#101)
    OrderDAO-->>Service: Order ID #101
    
    Service->>CartDAO: clear(buyerId)
    CartDAO->>DB: DELETE FROM cart_items WHERE buyer_id = ?
    DB-->>CartDAO: Cart cleared
    
    Service-->>Controller: Order ID #101
    Controller-->>Buyer: Redirect /orders?success=101
```

---

## 5. Security & Quality Audit Verification

| Security Checklist Item | Implementation Status | Evidence / Verification |
|---|---|---|
| **SQL Injection Prevention** | 100% Verified | All SQL queries in `UserDAO`, `ProductDAO`, `CartDAO`, `OrderDAO`, `ReviewDAO` use `PreparedStatement`. Zero string concatenation. |
| **Password Hashing** | 100% Verified | Passwords hashed with `jBCrypt` salt round 10 via `Password.hash()`. |
| **Session Protection** | 100% Verified | Session regenerated on login; explicit 30-minute timeout configured in `web.xml`; protected routes guarded by `AuthFilter`. |
| **Output XSS Escaping** | 100% Verified | Dynamic JSP fields escaped via HTML entity escaping and JSTL tags. |
| **Custom Error Handling** | 100% Verified | `web.xml` maps 404, 500, and `java.lang.Throwable` to `/WEB-INF/views/error.jsp`. Stack traces are strictly hidden. |
| **API Secret Exclusion** | 100% Verified | `.env` and `config.properties` excluded in `.gitignore`. API keys loaded from server-side environment variables. |
| **Automated Testing** | 100% Green | 15 JUnit 5 + Mockito unit tests passing via `mvn clean test`. |

---

## 6. Known Limitations & Future Scope

1. **Payment Gateway Integration**: Current checkout simulates transactions via card, UPI, net banking, and COD. Integrating a live PG (Razorpay/Stripe) can be added in production.
2. **File Upload Storage**: Product images currently accept hosted image URLs (Unsplash CDN). Direct multipart image file uploading to S3/Cloud Storage can be expanded.
