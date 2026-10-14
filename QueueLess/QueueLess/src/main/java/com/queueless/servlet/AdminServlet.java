package com.queueless.servlet;

import com.queueless.util.DB;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private boolean isAdmin(HttpServletRequest req) {
        return "ADMIN".equals(req.getSession().getAttribute("role"));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            res.sendRedirect("login.jsp");
            return;
        }

        /*
         * Get today's orders
         */
        req.setAttribute("orders", DB.query(
            "SELECT o.id, o.token_no, o.pickup_slot, o.total, o.status, " +
            "u.name AS student_name, " +
            "GROUP_CONCAT(CONCAT(i.name, ' x', oi.qty) SEPARATOR ', ') AS items " +
            "FROM orders o " +
            "JOIN users u ON u.id = o.user_id " +
            "JOIN order_items oi ON oi.order_id = o.id " +
            "JOIN menu_items i ON i.id = oi.item_id " +
            "WHERE o.order_date = CURDATE() " +
            "GROUP BY o.id " +
            "ORDER BY o.token_no"
        ));

        /*
         * Get menu items
         */
        req.setAttribute("menuItems", DB.query(
            "SELECT * FROM menu_items ORDER BY category, name"
        ));

        /*
         * Open admin dashboard
         */
        req.getRequestDispatcher("admin.jsp").forward(req, res);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        if (!isAdmin(req)) {
            res.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");


        /*
         * UPDATE ORDER STATUS
         */
        if ("status".equals(action)) {

            String idParameter = req.getParameter("id");

            /*
             * Support order_id also, in case another form uses it.
             */
            if (idParameter == null || idParameter.trim().isEmpty()) {
                idParameter = req.getParameter("order_id");
            }

            if (idParameter == null || idParameter.trim().isEmpty()) {
                res.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Order ID is missing."
                );
                return;
            }

            int id = Integer.parseInt(idParameter);

            String status = req.getParameter("status");

            if (status == null || status.trim().isEmpty()) {
                res.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Order status is missing."
                );
                return;
            }

            DB.update(
                "UPDATE orders SET status=? WHERE id=?",
                status,
                id
            );
        }


        /*
         * UPDATE MENU AVAILABILITY
         */
        else if ("menu".equals(action)) {

            String menuIdParameter = req.getParameter("menu_id");

            /*
             * Support id also for compatibility.
             */
            if (menuIdParameter == null || menuIdParameter.trim().isEmpty()) {
                menuIdParameter = req.getParameter("id");
            }

            if (menuIdParameter == null || menuIdParameter.trim().isEmpty()) {
                res.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Menu ID is missing."
                );
                return;
            }

            int menuId = Integer.parseInt(menuIdParameter);

            /*
             * The checkbox sends available=1 when checked.
             * If unchecked, no parameter is sent.
             */
            String available = req.getParameter("available");

            if ("1".equals(available)) {

                DB.update(
                    "UPDATE menu_items SET available=1 WHERE id=?",
                    menuId
                );

            } else {

                DB.update(
                    "UPDATE menu_items SET available=0 WHERE id=?",
                    menuId
                );
            }
        }


        /*
         * UNKNOWN ACTION
         */
        else {

            res.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid admin action."
            );

            return;
        }


        /*
         * Return to admin dashboard
         */
        res.sendRedirect("admin");
    }
}