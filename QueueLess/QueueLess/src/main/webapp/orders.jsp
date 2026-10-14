<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">

<meta http-equiv="refresh" content="30">

<title>My tokens | QueueLess</title>

<link rel="stylesheet" href="css/style.css">

<style>

    /* Cancel Button */

    .cancel-form {
        margin-top: 15px;
    }

    .cancel-btn {
        background: #fff;
        color: #dc2626;
        border: 1px solid #dc2626;
        padding: 9px 16px;
        border-radius: 8px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
    }

    .cancel-btn:hover {
        background: #dc2626;
        color: white;
    }

    .cancelled-note {
        margin-top: 15px;
        padding: 10px 12px;
        background: #fff1f2;
        color: #be123c;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
    }


    /* READY POPUP */

    .popup-overlay {
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.55);
        display: none;
        align-items: center;
        justify-content: center;
        z-index: 9999;
    }

    .popup-box {
        width: 90%;
        max-width: 400px;
        background: white;
        border-radius: 18px;
        padding: 30px;
        text-align: center;
        box-shadow: 0 20px 50px rgba(0,0,0,0.25);
        animation: popupShow 0.25s ease;
    }

    .popup-icon {
        font-size: 48px;
        margin-bottom: 10px;
    }

    .popup-box h2 {
        margin: 0 0 10px;
        color: #222;
    }

    .popup-box p {
        margin: 0 0 20px;
        color: #666;
        line-height: 1.5;
    }

    .popup-btn {
        border: none;
        background: #4f46e5;
        color: white;
        padding: 10px 25px;
        border-radius: 8px;
        font-weight: 600;
        cursor: pointer;
    }

    .popup-btn:hover {
        background: #4338ca;
    }

    @keyframes popupShow {

        from {
            transform: scale(0.85);
            opacity: 0;
        }

        to {
            transform: scale(1);
            opacity: 1;
        }

    }

</style>

</head>


<body>

<jsp:include page="_nav.jsp"/>


<div class="wrap">

    <h1>My tokens</h1>

    <p class="sub">
        This page refreshes automatically. Show your token at the counter when it says Ready.
    </p>


    <c:forEach var="o" items="${orders}">

        <div class="ticket">

            <div class="stub">

                <small>Token</small>

                <b>${o.token_no}</b>

            </div>


            <div class="tbody">

                <span class="pill ${o.status}">
                    ${o.status}
                </span>


                <p class="items">
                    ${o.items}
                </p>


                <div class="order-info">

                    <strong>
                        ₹${o.total}
                    </strong>

                    <span>
                        Pickup ${o.pickup_slot}
                    </span>

                    <span class="cat">
                        ${o.order_date}
                    </span>

                </div>


                <c:if test="${o.status != 'READY'
                             && o.status != 'COMPLETED'
                             && o.status != 'CANCELLED'}">

                    <form method="post"
                          action="order"
                          class="cancel-form"
                          onsubmit="return confirm('Are you sure you want to cancel Token #${o.token_no}?');">

                        <input type="hidden"
                               name="action"
                               value="cancel">

                        <input type="hidden"
                               name="order_id"
                               value="${o.id}">

                        <button type="submit"
                                class="cancel-btn">

                            Cancel Token

                        </button>

                    </form>

                </c:if>


                <c:if test="${o.status == 'CANCELLED'}">

                    <div class="cancelled-note">

                        This order has been cancelled.

                    </div>

                </c:if>

            </div>

        </div>


        <c:if test="${o.status == 'READY'}">

            <div class="popup-overlay"
                 id="readyPopup${o.id}"
                 style="display:flex;">

                <div class="popup-box">

                    <div class="popup-icon">
                        🔔
                    </div>

                    <h2>
                        Order Ready!
                    </h2>

                    <p>
                        Your Token #${o.token_no} is ready for pickup.
                        Please collect your order from the counter.
                    </p>

                    <button class="popup-btn"
                            onclick="closePopup('readyPopup${o.id}')">

                        OK

                    </button>

                </div>

            </div>

        </c:if>

    </c:forEach>


    <c:if test="${empty orders}">

        <div class="empty">

            <p>
                No orders yet.
            </p>

            <a href="menu">
                Browse the menu
            </a>

            to get your first token.

        </div>

    </c:if>

</div>


<script>

    function closePopup(id) {

        const popup = document.getElementById(id);

        if (popup) {
            popup.style.display = "none";
        }

    }

</script>


</body>
</html>