package com.queueless.servlet;

import com.queueless.util.DB;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    /** Student's own orders with their tokens. */
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Object uid = req.getSession().getAttribute("uid");
        if (uid == null) { res.sendRedirect("login.jsp"); return; }
        req.setAttribute("orders", DB.query(
            "SELECT o.token_no, o.pickup_slot, o.total, o.status, o.order_date, " +
            "GROUP_CONCAT(CONCAT(i.name,' x',oi.qty) SEPARATOR ', ') AS items " +
            "FROM orders o JOIN order_items oi ON oi.order_id=o.id JOIN menu_items i ON i.id=oi.item_id " +
            "WHERE o.user_id=? GROUP BY o.id ORDER BY o.id DESC", uid));
        req.getRequestDispatcher("orders.jsp").forward(req, res);
    }

    /** Place an order: validate cart, generate today's next token, save in one transaction. */
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Object uid = req.getSession().getAttribute("uid");
        if (uid == null) { res.sendRedirect("login.jsp"); return; }
        try (Connection c = DB.get()) {
            c.setAutoCommit(false);
            double total = 0;
            List<Object[]> lines = new ArrayList<>();
            try (Statement st = c.createStatement(); ResultSet rs = st.executeQuery("SELECT id, price FROM menu_items WHERE available=1")) {
                while (rs.next()) {
                    String q = req.getParameter("qty_" + rs.getInt(1));
                    int qty = (q == null || q.isEmpty()) ? 0 : Integer.parseInt(q);
                    if (qty > 0) { lines.add(new Object[]{rs.getInt(1), qty, rs.getDouble(2)}); total += qty * rs.getDouble(2); }
                }
            }
            if (lines.isEmpty()) { res.sendRedirect("menu"); return; }

            int token;
            try (Statement st = c.createStatement();
                 ResultSet rs = st.executeQuery("SELECT COALESCE(MAX(token_no),0)+1 FROM orders WHERE order_date=CURDATE() FOR UPDATE")) {
                rs.next(); token = rs.getInt(1);
            }
            long oid;
            try (PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO orders(user_id,token_no,order_date,pickup_slot,total) VALUES(?,?,CURDATE(),?,?)", Statement.RETURN_GENERATED_KEYS)) {
                ps.setObject(1, uid); ps.setInt(2, token); ps.setString(3, req.getParameter("slot")); ps.setDouble(4, total);
                ps.executeUpdate();
                try (ResultSet k = ps.getGeneratedKeys()) { k.next(); oid = k.getLong(1); }
            }
            try (PreparedStatement ps = c.prepareStatement("INSERT INTO order_items(order_id,item_id,qty,price) VALUES(?,?,?,?)")) {
                for (Object[] l : lines) { ps.setLong(1, oid); ps.setInt(2, (int) l[0]); ps.setInt(3, (int) l[1]); ps.setDouble(4, (double) l[2]); ps.addBatch(); }
                ps.executeBatch();
            }
            c.commit();
            res.sendRedirect("order");
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
}
