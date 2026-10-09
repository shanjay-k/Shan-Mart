# Contributing to SHAN MART

Thank you for contributing to **SHAN MART**! This guide outlines setup, code style standards, commit conventions, and step-by-step instructions to get your local environment running.

---

## 🛠️ Step-by-Step Local Setup Guide

### 1. Prerequisites
Ensure you have the following installed:
- **Java Development Kit (JDK 17)**: Run `java -version` to verify JDK 17+.
- **Apache Maven 3.8+**: Run `mvn -version` to verify Maven installation.
- **Apache Tomcat 9.0.x**: Servlet 4.0 (`javax.servlet.*`) compatible web server.
- **Git**: For source version control.

### 2. Clone the Repository
```bash
git clone https://github.com/shanjay-k/Shan-Mart.git
cd Shan-Mart
```

### 3. Build & Run Tests
Run the automated test suite to ensure all DAO, Service, and AI Chatbot unit tests pass:
```bash
mvn clean test
```

### 4. Build the WAR File
Package the project into a web application archive (`.war`):
```bash
mvn clean package
```
The compiled archive will be created at `target/shanjays-mart.war`.

### 5. Deploy to Apache Tomcat
1. Copy `target/shanjays-mart.war` to your Tomcat installation's `webapps/` directory.
2. Start Tomcat server:
   - **Windows**: Executing `bin/startup.bat`
   - **Linux/macOS**: Executing `bin/startup.sh`
3. Access the web application in your browser at:
   `http://localhost:8080/shanjays-mart/`

---

## 📐 Conventional Commit Format

We follow standard conventional commit messages for all pull requests:
- `feat: <description>` for new user features (e.g. `feat: add AI chatbot widget`)
- `fix: <description>` for bug fixes (e.g. `fix: resolve stock quantity validation bug`)
- `test: <description>` for adding unit or integration tests (e.g. `test: add ChatService test coverage`)
- `docs: <description>` for documentation updates (e.g. `docs: update sequence diagram in README`)

---

## 🔐 Security & Configuration Guidelines

- **Environment Variables**: Never commit `.env` or `config.properties` files containing secrets or production API keys.
- **Database PreparedStatements**: All SQL queries MUST use parameterized `PreparedStatement` to prevent SQL Injection.
- **Password Hashing**: Passwords must ALWAYS be hashed with `Password.hash()` using **jBCrypt**.
