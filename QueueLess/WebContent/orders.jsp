<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<meta http-equiv="refresh" content="20"><title>My tokens | QueueLess</title><link rel="stylesheet" href="css/style.css"></head><body>
<jsp:include page="_nav.jsp"/>
<div class="wrap">
  <h1>My tokens</h1><p class="sub">This page refreshes on its own. Show your token at the counter when it says Ready.</p>
  <c:forEach var="o" items="${orders}">
    <div class="ticket">
      <div class="stub"><small>Token</small><b>${o.token_no}</b></div>
      <div class="tbody">
        <span class="pill ${o.status}">${o.status}</span>
        <p class="items">${o.items}</p>
        <strong>₹${o.total}</strong> &nbsp; Pickup ${o.pickup_slot} &nbsp; <span class="cat">${o.order_date}</span>
      </div>
    </div>
  </c:forEach>
  <c:if test="${empty orders}"><div class="empty">No orders yet. <a href="menu"><u>Browse the menu</u></a> to get your first token.</div></c:if>
</div></body></html>
