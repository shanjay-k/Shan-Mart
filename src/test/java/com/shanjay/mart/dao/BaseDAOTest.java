package com.shanjay.mart.dao;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Statement;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;

public abstract class BaseDAOTest {
    protected JdbcDataSource dataSource;

    @BeforeEach
    public void setupDatabase() throws Exception {
        dataSource = new JdbcDataSource();
        dataSource.setURL("jdbc:h2:mem:testdb_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        dataSource.setUser("sa");
        dataSource.setPassword("");

        try (Connection c = dataSource.getConnection();
             Statement s = c.createStatement();
             InputStream in = getClass().getClassLoader().getResourceAsStream("schema.sql")) {
            if (in == null) {
                throw new IllegalStateException("schema.sql not found in test classpath");
            }
            String sql = new String(in.readAllBytes(), StandardCharsets.UTF_8);
            for (String part : sql.split(";")) {
                if (!part.trim().isEmpty()) {
                    s.execute(part);
                }
            }
        }
    }
}
