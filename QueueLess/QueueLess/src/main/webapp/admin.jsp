<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<meta http-equiv="refresh" content="30">

<title>Admin Dashboard | QueueLess</title>

<link rel="stylesheet" href="css/style.css">

<style>

/* PAGE */

body {
    margin: 0;
    background: linear-gradient(135deg, #e0e7ff, #f3e8ff, #cffafe) !important;
    color: #1f2937 !important;
    font-family: Arial, sans-serif;
}


/* MAIN */

.admin-container {
    width: 94%;
    max-width: 1250px;
    margin: 35px auto;
}


/* HEADER */

.admin-header {
    background: linear-gradient(135deg, #312e81, #4f46e5);
    padding: 28px;
    border-radius: 18px;
    margin-bottom: 25px;
    box-shadow: 0 8px 25px rgba(79, 70, 229, 0.25);
}

.admin-header h1 {
    color: white !important;
    margin: 0 0 8px 0;
    font-size: 30px;
}

.admin-subtitle {
    color: #e0e7ff !important;
    margin: 0;
}


/* CARD */

.card {
    background: white !important;
    border-radius: 18px;
    padding: 24px;
    margin-bottom: 25px;
    border: 1px solid #ddd6fe;
    box-shadow: 0 8px 25px rgba(79, 70, 229, 0.12);
}

.card h2 {
    color: #312e81 !important;
    margin-top: 0;
    padding-left: 10px;
    border-left: 0px solid #6366f1;
}


/* TABLE */

.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

.orders-table,
.menu-table {
    width: 100%;
    border-collapse: collapse;
}


/* TABLE HEADER */

.orders-table th,
.menu-table th {
    background: #4338ca !important;
    color: white !important;
    padding: 15px;
    text-align: left;
    font-size: 13px;
}


/* TABLE DATA */

.orders-table td,
.menu-table td {
    background: white !important;
    color: #1f2937 !important;
    padding: 15px;
    border-bottom: 1px solid #e5e7eb;
}


/* HOVER */

.orders-table tbody tr:hover td,
.menu-table tbody tr:hover td {
    background: #eef2ff !important;
}


/* TOKEN */

.token-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;

    width: 42px;
    height: 42px;

    border-radius: 50%;

    background: #4f46e5 !important;
    color: white !important;

    font-weight: bold;
}


/* CANCELLED */

.cancelled-row td {
    background: #fff1f2 !important;
}

.cancelled-row .token-badge {
    background: #dc2626 !important;
}


/* CANCELLED STATUS */

.cancelled-status {
    display: inline-block;

    background: #fee2e2 !important;
    color: #b91c1c !important;

    padding: 8px 12px;

    border-radius: 8px;

    font-weight: bold;
    font-size: 12px;
}

.cancelled-label {
    display: block;

    color: #dc2626 !important;

    margin-top: 6px;

    font-size: 11px;
    font-weight: bold;
}


/* STATUS */

.status-select {
    min-width: 140px;

    padding: 9px 12px;

    background: white !important;
    color: #111827 !important;

    border: 2px solid #c7d2fe;

    border-radius: 8px;

    font-weight: bold;

    cursor: pointer;
}

.status-select:hover {
    border-color: #6366f1;
}

.status-select:focus {
    outline: none;
    border-color: #4f46e5;
}


/* MENU FORM */

.menu-form {
    display: flex;
    align-items: center;
    gap: 12px;
}


/* CHECKBOX */

.menu-form input[type="checkbox"] {
    width: 19px;
    height: 19px;

    accent-color: #16a34a;

    cursor: pointer;
}


/* AVAILABLE */

.available-text {
    color: #15803d !important;

    background: #dcfce7;

    padding: 7px 10px;

    border-radius: 7px;

    font-weight: bold;

    font-size: 12px;
}


/* UNAVAILABLE */

.unavailable-text {
    color: #dc2626 !important;

    background: #fee2e2;

    padding: 7px 10px;

    border-radius: 7px;

    font-weight: bold;

    font-size: 12px;
}


/* UPDATE */

.update-btn {
    border: none;

    background: #2563eb !important;

    color: white !important;

    padding: 9px 16px;

    border-radius: 8px;

    font-weight: bold;

    cursor: pointer;
}

.update-btn:hover {
    background: #1d4ed8 !important;
}


/* EMPTY */

.empty-orders {
    text-align: center;

    padding: 30px;

    color: #64748b !important;
}


/* REFRESH */

.refresh-note {
    color: #64748b !important;

    text-align: right;

    font-size: 12px;

    margin-top: 12px;
}


/* MOBILE */

@media (max-width: 700px) {

    .admin-container {
        width: 96%;
        margin: 20px auto;
    }

    .admin-header h1 {
        font-size: 24px;
    }

    .card {
        padding: 16px;
    }

    .menu-form {
        flex-wrap: wrap;
    }

}

</style>

</head>


<body>

<jsp:include page="_nav.jsp"/>


<div class="admin-container">


    <div class="admin-header">

        <h1>Admin Dashboard</h1>

        <p class="admin-subtitle">
            Manage today's orders and menu availability.
        </p>

    </div>


    <div class="card">

        <h2>Today's Orders</h2>

        <div class="table-wrapper">

            <table class="orders-table">

                <thead>

                    <tr>
                        <th>Token</th>
                        <th>Student</th>
                        <th>Items</th>
                        <th>Pickup</th>
                        <th>Total</th>
                        <th>Status</th>
                    </tr>

                </thead>


                <tbody>

                    <c:forEach var="o" items="${orders}">

                        <tr class="${o.status == 'CANCELLED' ? 'cancelled-row' : ''}">

                            <td>

                                <span class="token-badge">
                                    ${o.token_no}
                                </span>

                            </td>


                            <td>
                                <strong>${o.student_name}</strong>
                            </td>


                            <td>
                                ${o.items}
                            </td>


                            <td>
                                ${o.pickup_slot}
                            </td>


                            <td>
                                <strong>₹${o.total}</strong>
                            </td>


                            <td>

                                <c:choose>

                                    <c:when test="${o.status == 'CANCELLED'}">

                                        <span class="cancelled-status">
                                            ⚠ CANCELLED
                                        </span>

                                        <span class="cancelled-label">
                                            Cancelled by student
                                        </span>

                                    </c:when>


                                    <c:otherwise>

                                        <form method="post"
                                              action="admin">

                                            <input type="hidden"
                                                   name="action"
                                                   value="status">

                                            <input type="hidden"
                                                   name="id"
                                                   value="${o.id}">

                                            <input type="hidden"
                                                   name="order_id"
                                                   value="${o.id}">

                                            <select name="status"
                                                    class="status-select"
                                                    onchange="this.form.submit()">

                                                <option value="PLACED"
                                                    ${o.status == 'PLACED' ? 'selected' : ''}>
                                                    PLACED
                                                </option>

                                                <option value="PREPARING"
                                                    ${o.status == 'PREPARING' ? 'selected' : ''}>
                                                    PREPARING
                                                </option>

                                                <option value="READY"
                                                    ${o.status == 'READY' ? 'selected' : ''}>
                                                    READY
                                                </option>

                                                <option value="COMPLETED"
                                                    ${o.status == 'COMPLETED' ? 'selected' : ''}>
                                                    COMPLETED
                                                </option>

                                            </select>

                                        </form>

                                    </c:otherwise>

                                </c:choose>

                            </td>

                        </tr>

                    </c:forEach>

                </tbody>

            </table>

        </div>


        <c:if test="${empty orders}">

            <div class="empty-orders">
                No orders found for today.
            </div>

        </c:if>


        <div class="refresh-note">
            🔄 Automatically refreshes every 30 seconds.
        </div>

    </div>



    <div class="card">

        <h2>Menu Availability</h2>

        <div class="table-wrapper">

            <table class="menu-table">

                <thead>

                    <tr>
                        <th>Item</th>
                        <th>Price</th>
                        <th>Availability</th>
                    </tr>

                </thead>


                <tbody>

                    <c:forEach var="m" items="${menuItems}">

                        <tr>

                            <td>
                                <strong>${m.name}</strong>
                            </td>


                            <td>
                                <strong>₹${m.price}</strong>
                            </td>


                            <td>

                                <form method="post"
                                      action="admin"
                                      class="menu-form">

                                    <input type="hidden"
                                           name="action"
                                           value="menu">

                                    <input type="hidden"
                                           name="menu_id"
                                           value="${m.id}">


                                    <input type="checkbox"
                                           name="available"
                                           value="1"
                                           ${m.available ? 'checked' : ''}>


                                    <c:choose>

                                        <c:when test="${m.available}">

                                            <span class="available-text">
                                                ● Available
                                            </span>

                                        </c:when>


                                        <c:otherwise>

                                            <span class="unavailable-text">
                                                ● Unavailable
                                            </span>

                                        </c:otherwise>

                                    </c:choose>


                                    <button type="submit"
                                            class="update-btn">

                                        Update

                                    </button>

                                </form>

                            </td>

                        </tr>

                    </c:forEach>

                </tbody>

            </table>

        </div>

    </div>


</div>

</body>

</html>