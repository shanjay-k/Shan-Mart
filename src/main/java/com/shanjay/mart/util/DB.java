package com.shanjay.mart.util;
import com.zaxxer.hikari.HikariDataSource; import javax.sql.DataSource;
public final class DB { private DB(){} public static DataSource ds(HikariDataSource d){return d;} }
