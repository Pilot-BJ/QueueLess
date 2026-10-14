<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Menu | QueueLess</title><link rel="stylesheet" href="css/style.css"></head><body>
<jsp:include page="_nav.jsp"/>
<form method="post" action="order" class="wrap">
  <h1>Today's menu</h1><p class="sub">Pick your items and a pickup time. Your token is ready the moment you order.</p>
  <div class="grid">
    <c:forEach var="i" items="${items}">
      <div class="item ${i.available ? '' : 'off'}">
        <span class="cat">${i.category}</span><strong>${i.name}</strong><span class="price">₹${i.price}</span>
        <c:choose>
          <c:when test="${i.available}">
            <div class="step" data-price="${i.price}">
              <button type="button" data-d="-1" aria-label="Remove one">−</button><span>0</span>
              <button type="button" data-d="1" aria-label="Add one">+</button>
              <input type="hidden" name="qty_${i.id}" value="0">
            </div>
          </c:when>
          <c:otherwise><span class="cat">Sold out</span></c:otherwise>
        </c:choose>
      </div>
    </c:forEach>
  </div>
  <div class="bar">
    <div class="total">Total ₹<span id="total">0</span></div>
    <select name="slot" aria-label="Pickup time">
      <option>10:30 AM</option><option>11:30 AM</option><option>12:30 PM</option><option>1:30 PM</option><option>3:30 PM</option>
    </select>
    <button class="btn" id="go" disabled>Get my token</button>
  </div>
</form>
<script>
const total=document.getElementById('total'),go=document.getElementById('go');
document.querySelectorAll('.step').forEach(s=>{
  const n=s.querySelector('span'),h=s.querySelector('input');
  s.addEventListener('click',e=>{
    const d=+e.target.dataset.d; if(!d)return;
    h.value=n.textContent=Math.max(0,Math.min(10,+h.value+d)); sum();
  });
});
function sum(){let t=0;document.querySelectorAll('.step').forEach(s=>t+=s.dataset.price*s.querySelector('input').value);total.textContent=t;go.disabled=t===0}
</script></body></html>
