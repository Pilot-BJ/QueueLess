package com.queueless.servlet;

import com.queueless.util.DB;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private boolean isAdmin(HttpServletRequest req) { return "ADMIN".equals(req.getSession().getAttribute("role")); }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if (!isAdmin(req)) { res.sendRedirect("login.jsp"); return; }
        req.setAttribute("orders", DB.query(
            "SELECT o.id, o.token_no, o.pickup_slot, o.total, o.status, u.name, " +
            "GROUP_CONCAT(CONCAT(i.name,' x',oi.qty) SEPARATOR ', ') AS items " +
            "FROM orders o JOIN users u ON u.id=o.user_id JOIN order_items oi ON oi.order_id=o.id JOIN menu_items i ON i.id=oi.item_id " +
            "WHERE o.order_date=CURDATE() GROUP BY o.id ORDER BY o.token_no"));
        req.setAttribute("items", DB.query("SELECT * FROM menu_items ORDER BY category, name"));
        req.getRequestDispatcher("admin.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        if (!isAdmin(req)) { res.sendRedirect("login.jsp"); return; }
        int id = Integer.parseInt(req.getParameter("id"));
        if ("status".equals(req.getParameter("action")))
            DB.update("UPDATE orders SET status=? WHERE id=?", req.getParameter("status"), id);
        else
            DB.update("UPDATE menu_items SET available = NOT available WHERE id=?", id);
        res.sendRedirect("admin");
    }
}
