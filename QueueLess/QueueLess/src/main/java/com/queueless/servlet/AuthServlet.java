package com.queueless.servlet;

import com.queueless.util.DB;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {   // logout
        HttpSession s = req.getSession(false);
        if (s != null) s.invalidate();
        res.sendRedirect("login.jsp");
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String action = req.getParameter("action");
        String email = req.getParameter("email").trim().toLowerCase();
        String pw = DB.hash(req.getParameter("password"));

        if ("register".equals(action)) {
            try {
                DB.update("INSERT INTO users(name,email,password) VALUES(?,?,?)", req.getParameter("name").trim(), email, pw);
                back(res, "Account created. Log in to order.");
            } catch (RuntimeException e) { back(res, "That email is already registered."); }
            return;
        }
        List<Map<String, Object>> u = DB.query("SELECT * FROM users WHERE email=? AND password=?", email, pw);
        if (u.isEmpty()) { back(res, "Wrong email or password."); return; }
        HttpSession s = req.getSession();
        s.setAttribute("uid", u.get(0).get("id"));
        s.setAttribute("name", u.get(0).get("name"));
        s.setAttribute("role", u.get(0).get("role"));
        res.sendRedirect("ADMIN".equals(u.get(0).get("role")) ? "admin" : "menu");
    }

    private void back(HttpServletResponse res, String msg) throws IOException {
        res.sendRedirect("login.jsp?msg=" + URLEncoder.encode(msg, "UTF-8"));
    }
}
