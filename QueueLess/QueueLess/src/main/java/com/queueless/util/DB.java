package com.queueless.util;

import java.security.MessageDigest;
import java.sql.*;
import java.util.*;

public class DB {
    private static final String URL = "jdbc:mysql://localhost:3306/queueless?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root", PASS = "root"; // change to your MySQL credentials

    static { try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (Exception e) { throw new RuntimeException(e); } }

    public static Connection get() throws SQLException { return DriverManager.getConnection(URL, USER, PASS); }

    public static List<Map<String, Object>> query(String sql, Object... p) {
        try (Connection c = get(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (int i = 0; i < p.length; i++) ps.setObject(i + 1, p[i]);
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                List<Map<String, Object>> out = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    for (int i = 1; i <= md.getColumnCount(); i++) m.put(md.getColumnLabel(i), rs.getObject(i));
                    out.add(m);
                }
                return out;
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public static int update(String sql, Object... p) {
        try (Connection c = get(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (int i = 0; i < p.length; i++) ps.setObject(i + 1, p[i]);
            return ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public static String hash(String s) {
        try {
            StringBuilder sb = new StringBuilder();
            for (byte b : MessageDigest.getInstance("SHA-256").digest(s.getBytes("UTF-8"))) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) { throw new RuntimeException(e); }
    }
}
