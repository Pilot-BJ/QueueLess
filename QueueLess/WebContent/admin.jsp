<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<meta http-equiv="refresh" content="30"><title>Kitchen | QueueLess</title><link rel="stylesheet" href="css/style.css"></head><body>
<jsp:include page="_nav.jsp"/>
<div class="wrap" style="padding-bottom:40px">
  <h1>Today's orders</h1><p class="sub">Update the status and students see it on their token.</p>
  <c:choose><c:when test="${empty orders}"><div class="empty">No orders yet today.</div></c:when>
  <c:otherwise>
  <div style="overflow-x:auto"><table>
    <tr><th>Token</th><th>Student</th><th>Items</th><th>Pickup</th><th>Total</th><th>Status</th></tr>
    <c:forEach var="o" items="${orders}">
      <tr><td><strong>#${o.token_no}</strong></td><td>${o.name}</td><td>${o.items}</td><td>${o.pickup_slot}</td><td>₹${o.total}</td>
        <td><form method="post" action="admin">
          <input type="hidden" name="action" value="status"><input type="hidden" name="id" value="${o.id}">
          <select name="status" onchange="this.form.submit()">
            <c:forEach var="s" items="PLACED,PREPARING,READY,COLLECTED">
              <option ${o.status == s ? 'selected' : ''}>${s}</option>
            </c:forEach>
          </select></form></td></tr>
    </c:forEach>
  </table></div></c:otherwise></c:choose>

  <h2>Menu availability</h2>
  <div class="grid">
    <c:forEach var="i" items="${items}">
      <form method="post" action="admin" class="item ${i.available ? '' : 'off'}">
        <input type="hidden" name="action" value="toggle"><input type="hidden" name="id" value="${i.id}">
        <strong>${i.name}</strong>
        <button class="btn ghost">${i.available ? 'Mark sold out' : 'Mark available'}</button>
      </form>
    </c:forEach>
  </div>
</div></body></html>
