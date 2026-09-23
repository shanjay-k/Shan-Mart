package com.shanjay.mart.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.shanjay.mart.model.User;

public class UserDAOTest extends BaseDAOTest {
    private UserDAO userDAO;

    @BeforeEach
    public void initDAO() {
        userDAO = new UserDAO(dataSource);
    }

    @Test
    public void testCreateAndFindUser() throws Exception {
        userDAO.create("Test Buyer", "test.buyer@example.com", "hashed_pwd", "BUYER");

        User u = userDAO.findByEmail("test.buyer@example.com");
        assertNotNull(u);
        assertEquals("Test Buyer", u.name);
        assertEquals("BUYER", u.role);
        assertTrue(userDAO.emailExists("test.buyer@example.com"));

        List<User> users = userDAO.all();
        assertEquals(1, users.size());
    }
}
