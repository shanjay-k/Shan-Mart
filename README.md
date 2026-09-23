# SHAN MART — E-Commerce Marketplace Platform

A production-ready Maven + Java 17 + Servlet 4.0/JSP + Apache Tomcat 9 e-commerce capstone application implementing all specifications through **Week 8 (Full Build & Deploy Checkpoint)**.

---

## Architecture Overview

SHAN MART follows a clean, layered architectural pattern:
- **Presentation Layer**: JSP views styled with modern CSS (Meesho & Amazon aesthetics), responsive design, and dynamic AJAX modal interactions for reviews and catalog search.
- **Controller Layer**: Front-facing Servlets (`ShopServlet`, `CartServlet`, `CheckoutServlet`, `OrdersServlet`, `ProductServlet`, `ReviewServlet`, `DashboardServlet`, `HealthServlet`, `AuthServlet`).
- **Service Layer**: `ShopService`, `AuthService` enforcing business rules, cart calculation, validation, stock tracking, and payment processing.
- **Data Access Layer (DAO)**: `UserDAO`, `ProductDAO`, `CartDAO`, `OrderDAO`, `ReviewDAO` using parameterized JDBC `PreparedStatement` with HikariCP connection pooling.
- **Persistence Layer**: Embedded/Server H2 Database (`~/shan_mart_v7.mv.db`) with automatic schema migration and seed data.

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
  │  ShopServlet    │       │ CheckoutServlet │      │  ReviewServlet  │
  │  (Catalog & UI) │       │ (Multi-Payment) │      │ (Rating Engine) │
  └────────┬────────┘       └────────┬────────┘      └────────┬────────┘
           │                         │                        │
           └─────────────────────────┼────────────────────────┘
                                     │
                                     ▼
                  ┌─────────────────────────────────────┐
                  │             ShopService             │
                  └──────────────────┬──────────────────┘
                                     │
         ┌───────────────┬───────────┴───────────┬──────────────┐
         ▼               ▼                       ▼              ▼
   ┌───────────┐   ┌───────────┐           ┌───────────┐  ┌───────────┐
   │ ProductDAO│   │  CartDAO  │           │ OrderDAO  │  │ ReviewDAO │
   └─────┬─────┘   └─────┬─────┘           └─────┬─────┘  └─────┬─────┘
         │               │                       │              │
         └───────────────┴───────────┬───────────┴──────────────┘
                                     │ JDBC (HikariCP)
                                     ▼
                  ┌─────────────────────────────────────┐
                  │          H2 Database (~/shan_mart)  │
                  └─────────────────────────────────────┘
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
| **Testing** | JUnit 5 Jupiter + In-Memory H2 | 5.10.3 |
| **Styling** | Vanilla CSS3 Design System | Responsive, Glassmorphism, Micro-interactions |

---

## Features Implemented (Weeks 1 to 8 Checkpoints)

### Week 1: Authentication & Base DAO (F1)
- User Registration & Login supporting **Buyer** and **Seller** roles.
- Seeded **Admin** account (`admin@shanjaymart.local` / `1234`).
- Secure password hashing using **jBCrypt** (no plaintext passwords).
- Session fixation protection & explicit session timeouts.
- Global `EncodingFilter` (UTF-8) and `AuthFilter` for protected route security.
- Central HikariCP connection pool managed in `AppListener`.

### Week 2: Core Shopping Flow (F2, F3, F4, F5)
- **F2**: Seller product listings creation, stock tracking, and category assignments.
- **F3**: Instant keyword search and multi-category browsing.
- **F4**: Shopping cart with quantity updates, item removals, and running total.
- **F5**: Checkout flow with mock payment confirmation and stock deduction.
- **Curated Catalog**: 25 realistic products with verified, high-definition images matching product names across Electronics, Fashion, Home & Kitchen, Books, and Sports.

### Week 3 & 4: Dashboards, Orders & Admin Panel (F6, F7)
- **Seller Inventory Central**: Active listings table, stock level indicators (In Stock / Low Stock / Out of Stock), in-line edit modal, and listing deletion.
- **F6 (Seller view)**: Incoming customer orders for seller's products with customer delivery address and status updates.
- **F6 (Buyer view)**: Comprehensive order history showing ordered line items, thumbnails, unit prices, delivery details, and payment badges.
- **F7 (Admin Panel)**: User account auditing, platform KPI summaries, and product catalog moderation.

### Week 5 & 6: Order Status Workflow & Reviews / Ratings (F8, O2)
- **O2 Order Status Transitions**: PENDING → CONFIRMED → SHIPPED → DELIVERED → CANCELLED.
- **F8 Product Reviews & Star Ratings**:
  - Interactive 5-star rating submission modal on completed order items.
  - Calculated real average rating badges and review counts on the storefront.
  - Interactive "View Reviews" modal dynamically fetching genuine customer feedback via AJAX.
  - Strict input validation rejecting ratings outside 1–5 stars.

### Week 7 & 8: Multi-Payment Checkout, Security & Full Build (F5, Week 8)
- **Multi-Method Checkout**:
  1. 💳 **Credit / Debit Card** (Visa, MasterCard, RuPay with CVV & expiry validation).
  2. 📱 **UPI / QR Code** (Google Pay, PhonePe, Paytm, BHIM with instant verification).
  3. 🏦 **Net Banking** (Major Indian banks selection).
  4. 💵 **Cash on Delivery (COD)** (Doorstep payment with zero advance fee).
- **Health Check Endpoint**: `GET /api/v1/health` returning `{"status":"UP","db":"UP"}` with active database ping.
- **Automated Test Suite**: JUnit 5 tests covering all DAOs (`UserDAO`, `ProductDAO`, `ReviewDAO`) and `ShopService` business logic with clean in-memory H2 test databases.

---

## Seed Accounts

| Role | Email | Password | Access Rights |
|---|---|---|---|
| **Buyer** | `buyer@shanjaymart.local` | `1234` | Browse, Cart, Checkout, Reviews, Order Tracking |
| **Seller** | `seller@shanjaymart.local` | `1234` | Inventory Dashboard, Add/Edit Listings, Manage Orders |
| **Admin** | `admin@shanjaymart.local` | `1234` | Platform KPIs, User Audit, Catalog Moderation |

---

## How to Run Locally

### Prerequisites
- JDK 17 installed and on `PATH`
- Apache Maven 3.8+ installed and on `PATH`
- Apache Tomcat 9.0.x installed

### Build & Test
```bash
# Run unit & DAO tests
mvn clean test

# Build production WAR package
mvn clean package
```

### Deploy to Tomcat
1. Copy `target/shanjays-mart.war` to your Tomcat's `webapps/` folder.
2. Run Tomcat:
   - Windows: `bin/startup.bat`
   - Linux/Mac: `bin/startup.sh`
3. Navigate to: `http://localhost:8080/shanjays-mart/`

### Health Check Verification
```bash
curl http://localhost:8080/shanjays-mart/api/v1/health
# Response: {"status":"UP","db":"UP"}
```
