# SHAN MART — Weekly Sprint Retrospectives (RETRO.md)

| Sprint / Week | Dates | What Worked | What Didn't | One Change for Next Sprint |
|---|---|---|---|---|
| **Kickoff** | Jul 24 – Jul 27 | Project skeleton, Maven POM, H2 schema initialized cleanly. | Initial directory layout lacked DTO packages. | Standardized package structure (`dto`, `dao`, `service`, `filter`). |
| **Week 1** | Jul 27 – Aug 2 | jBCrypt password hashing & HikariCP pooling working end-to-end. | Servlet redirects broke clean error state sharing. | Added request-scope error messages and session regeneration. |
| **Week 2** | Aug 3 – Aug 9 | Core shopping cart and checkout flow operating smoothly. | Demo catalog lacked high-res product images. | Synchronized 25 authentic Unsplash catalog images in `AppListener`. |
| **Week 3** | Aug 10 – Aug 16 | DTO separation (`UserResponseDTO`) preventing password hash leakage. | Mockito dependencies were missing in initial `pom.xml`. | Configured `mockito-core` and `mockito-junit-jupiter` in Maven. |
| **Week 4** | Aug 17 – Aug 23 | Seller dashboard inventory management and Admin moderation active. | Form modal state management needed cleaner JavaScript. | Refactored inline modal scripts to use standard DOM helpers. |
| **Week 5** | Aug 24 – Aug 30 | O2 Order status workflow transitions (Pending → Confirmed → Delivered). | Search filtering by category needed keyword combination logic. | Refactored `ShopService.search` to cleanly combine query and category parameters. |
| **Week 6** | Aug 31 – Sep 6 | F8 Product reviews and 5-star ratings with real-time AJAX modal. | Form validations touched DAO before checking parameters. | Enforced top-of-method input validation across all Service methods. |
| **Week 7** | Sep 7 – Sep 13 | Security audit complete: all queries parameterized, custom error pages added. | Checkstyle and SpotBugs plugins were not tied to CI build. | Configured `maven-checkstyle-plugin` and `spotbugs-maven-plugin` in `pom.xml`. |
| **Week 8** | Sep 14 – Sep 20 | `/api/v1/health` endpoint returning `{"status":"UP","db":"UP"}`. | Multi-payment checkout needed clearer panel toggling UI. | Built tabbed payment selector for Card, UPI, Net Banking, and COD. |
| **Week 9** | Sep 21 – Sep 27 | `ChatProvider` interface, `MockChatProvider`, and `GeminiChatProvider` implemented. | Gemini API key handling needed fallback strategy. | Added automatic fallback to `MockChatProvider` on network errors. |
| **Week 10** | Sep 28 – Oct 4 | Floating AI Chatbot UI widget integrated on all pages with FAQ quick chips. | Rate limiting per session required synchronization. | Implemented sliding window per-session rate limiter (10 msgs/min). |
| **Week 11** | Oct 5 – Oct 10 | Full regression pass clean, all 15 JUnit tests passing, final docs updated. | N/A - Final delivery ready! | Maintain production monitoring and CI pipeline status. |
