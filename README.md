# SHAN MART — E-Commerce Marketplace Platform

A production-ready Maven + Java 17 + Servlet 4.0/JSP + Apache Tomcat 9 e-commerce capstone application implementing all specifications through **Week 11 (Final Review Checkpoint)**, including complete shopping workflows, multi-role authentication, order status management, review engine, security hardening, and **AI Chatbot Integration (Phase 3)**.

---

## Architecture & System Design

SHAN MART follows a clean, layered architectural pattern adhering to standard J2EE enterprise practices:
- **Presentation Layer**: JSP views styled with modern CSS (Meesho & Amazon aesthetics), responsive layouts, Product Full View page, Wishlist portal, Account Profile, Buyer Dashboard, floating interactive AI Chatbot widget, and dynamic AJAX modal interactions for reviews and catalog search.
- **Controller Layer**: Front Controller Servlets (`ShopServlet`, `ProductServlet`, `WishlistServlet`, `CartServlet`, `CheckoutServlet`, `OrdersServlet`, `ReviewServlet`, `ProfileServlet`, `DashboardServlet`, `HealthServlet`, `ChatServlet`, `LoginServlet`, `RegisterServlet`, `LogoutServlet`).
- **Service Layer**: `ShopService`, `AuthService`, `ChatService` enforcing business rules, cart calculation, wishlist state, input validation, stock tracking, rate limiting, and LLM fallback.
- **Data Access Layer (DAO)**: `UserDAO`, `ProductDAO`, `WishlistDAO`, `CartDAO`, `OrderDAO`, `ReviewDAO` using parameterized JDBC `PreparedStatement` with HikariCP connection pooling.
- **Persistence Layer**: H2 Database (`~/shan_mart_v7.mv.db`) with automatic schema migration, indexes on foreign keys, and seed data.

```
                  ┌─────────────────────────────────────┐
                  │          Browser Client             │
                  └──────────────────┬──────────────────┘
                                     │ HTTP (REST & Form)
                                     ▼
                  ┌─────────────────────────────────────┐
                  │    EncodingFilter & AuthFilter      │
                  └──────────────────┬──────────────────┘
                                     │
           ┌─────────────────────────┼────────────────────────┐
           │                         │                        │
           ▼                         ▼                        ▼
  ┌─────────────────┐       ┌─────────────────┐      ┌─────────────────┐
  │   ShopServlet   │       │ CheckoutServlet │      │   ChatServlet   │
  │ (Catalog & UI)  │       │ (Multi-Payment) │      │ (AI Assistant)  │
  └────────┬────────┘       └────────┬────────┘      └────────┬────────┘
           │                         │                        │
           └─────────────────────────┼────────────────────────┘
                                     │
                                     ▼
                  ┌─────────────────────────────────────┐
                  │     ShopService / ChatService       │
                  └──────────────────┬──────────────────┘
                                     │
         ┌───────────────┬───────────┴───────────┬──────────────┬──────────────┐
         ▼               ▼                       ▼              ▼              ▼
   ┌───────────┐   ┌───────────┐           ┌───────────┐  ┌───────────┐  ┌───────────┐
   │ ProductDAO│   │WishlistDAO│           │  CartDAO  │  │ OrderDAO  │  │ ReviewDAO │
   └─────┬─────┘   └─────┬─────┘           └─────┬─────┘  └─────┬─────┘  └─────┬─────┘
         │               │                       │              │              │
         └───────────────┴───────────┬───────────┴──────────────┴──────────────┘
                                     │ JDBC (HikariCP)
                                     ▼
                  ┌─────────────────────────────────────┐
                  │          H2 Database (~/shan_mart)  │
                  └─────────────────────────────────────┘
```

---

## Architectural Diagrams

### D1: Entity-Relationship Diagram (ERD)

```mermaid
erDiagram
    USERS ||--o{ PRODUCTS : "lists / sells"
    USERS ||--o{ ORDERS : "places (buyer)"
    USERS ||--o{ CART_ITEMS : "adds to cart"
    USERS ||--o{ WISHLIST_ITEMS : "saves to wishlist"
    USERS ||--o{ REVIEWS : "writes"
    PRODUCTS ||--o{ CART_ITEMS : "contained in"
    PRODUCTS ||--o{ WISHLIST_ITEMS : "saved in"
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

    WISHLIST_ITEMS {
        bigint id PK
        bigint buyer_id FK
        bigint product_id FK
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

### D2: System Use Case Diagram

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

## Tech Stack

| Component | Technology / Library | Version / Details |
|---|---|---|
| **Runtime** | Java Development Kit (JDK) | 17 LTS |
| **Build Tool** | Apache Maven | 3.9+ |
| **Web Container** | Apache Tomcat | 9.0.x (`javax.servlet.*`) |
| **Connection Pool** | HikariCP | 5.1.0 |
| **Database** | H2 Database Engine | 2.2.224 (MySQL Compatibility Mode) |
| **Security & Auth** | jBCrypt | 0.4 |
| **Serialization** | Jackson Databind | 2.17.2 |
| **Testing & Mocking**| JUnit 5 Jupiter + Mockito | 5.10.3 / 5.11.0 |
| **Code Quality** | Checkstyle & SpotBugs Maven Plugins | 3.3.1 / 4.8.3.0 |
| **AI Integration** | ChatProvider (Gemini REST API / Mock) | `ai.chatbot.provider=gemini|mock` |
| **Styling** | Vanilla CSS3 Design System | Meesho & Amazon Inspired Aesthetics |

---

## Features Implemented (Full Capstone)

### Core Features (F1 – F8 & O4)
- **F1 Authentication & Security**: Multi-role signup (Buyer/Seller), password hashing with **jBCrypt**, `AuthFilter` session checks, and `EncodingFilter` (UTF-8).
- **F2 Listing Management**: Sellers create, edit, and delete product listings with image URLs, stock quantities, and pricing.
- **F3 Search & Filtering**: Multi-category filter pills and keyword search.
- **F4 Shopping Cart**: Add to cart, adjust quantities, remove items, running total calculation.
- **F5 Checkout & Multi-Payment**: Address collection, mock credit card, UPI/QR code, net banking, and Cash on Delivery (COD).
- **F6 Order History & Fulfillment**: Buyer order tracking and Seller order fulfillment views.
- **F7 Admin Panel**: Platform user account auditing, KPI dashboards, catalog moderation.
- **F8 Reviews & Star Ratings**: 5-star rating submission modal, average rating badge computation, and AJAX review fetcher.
- **O2 Order Status Workflow**: Status transitions: PENDING → CONFIRMED → SHIPPED → DELIVERED → CANCELLED.
- **O4 AI Chatbot Widget (Phase 3)**:
  - `ChatProvider` interface architecture with `MockChatProvider` and `GeminiChatProvider`.
  - Rate limiting (max 10 msgs/min per session).
  - Input length validation (max 500 characters).
  - In-memory per-session question caching.
  - Floating UI widget on all pages with quick FAQ chips.

---

## Seed Accounts

| Role | Email | Password | Access Rights |
|---|---|---|---|
| **Buyer** | `buyer@shanjaymart.local` | `1234` | Browse, Cart, Checkout, Reviews, Order Tracking |
| **Seller** | `seller@shanjaymart.local` | `1234` | Inventory Dashboard, Add/Edit Listings, Manage Orders |
| **Admin** | `admin@shanjaymart.local` | `1234` | Platform KPIs, User Audit, Catalog Moderation |

---

## How to Run Locally

### Build & Test
```bash
# Run unit, DAO, and service tests with Mockito
mvn clean test

# Build production WAR package
mvn clean package
```

### Deploy to Tomcat
1. Copy `target/shanjays-mart.war` to Tomcat's `webapps/` folder.
2. Start Tomcat (`bin/startup.bat` or `bin/startup.sh`).
3. Open `http://localhost:8080/shanjays-mart/` in your browser.

### Verification Endpoints
```bash
# Health Check Endpoint
curl http://localhost:8080/shanjays-mart/api/v1/health
# Output: {"status":"UP","db":"UP"}

# AI Chatbot API Endpoint
curl -X POST http://localhost:8080/shanjays-mart/api/chat -H "Content-Type: application/json" -d "{\"message\":\"What is your shipping policy?\"}"
# Output: {"success":true,"data":{"reply":"🚚 SHAN MART offers Free Delivery on all eligible orders across India! Standard delivery typically takes 2 to 4 business days."}}
```
