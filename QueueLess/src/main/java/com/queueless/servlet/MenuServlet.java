package com.queueless.servlet;

import com.queueless.util.DB;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if (req.getSession().getAttribute("uid") == null) { res.sendRedirect("login.jsp"); return; }
        req.setAttribute("items", DB.query("SELECT * FROM menu_items ORDER BY category, name"));
        req.getRequestDispatcher("menu.jsp").forward(req, res);
    }
}
