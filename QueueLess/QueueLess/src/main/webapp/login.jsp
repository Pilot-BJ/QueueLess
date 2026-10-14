<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>QueueLess</title><link rel="stylesheet" href="css/style.css"></head><body>
<div class="auth">
  <h1>Queue<b>Less</b></h1>
  <p class="sub">Order ahead. Get a token. Skip the line.</p>
  <c:if test="${not empty param.msg}"><div class="msg"><c:out value="${param.msg}"/></div></c:if>
  <div class="tabs"><button class="btn" id="tl" type="button">Log in</button><button class="btn ghost" id="tr" type="button">Sign up</button></div>
  <form id="login" method="post" action="auth">
    <input type="hidden" name="action" value="login">
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password" placeholder="Password" required>
    <button class="btn">Log in</button>
  </form>
  <form id="reg" method="post" action="auth" style="display:none">
    <input type="hidden" name="action" value="register">
    <input name="name" placeholder="Full name" required>
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password" placeholder="Password (min 6 characters)" minlength="6" required>
    <button class="btn">Create account</button>
  </form>
</div>
<script>
const L=document.getElementById('login'),R=document.getElementById('reg'),tl=document.getElementById('tl'),tr=document.getElementById('tr');
function show(login){L.style.display=login?'flex':'none';R.style.display=login?'none':'flex';tl.className='btn'+(login?'':' ghost');tr.className='btn'+(login?' ghost':'')}
tl.onclick=()=>show(true);tr.onclick=()=>show(false);
</script></body></html>
