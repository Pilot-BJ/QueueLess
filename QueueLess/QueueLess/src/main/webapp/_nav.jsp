<%@ page contentType="text/html;charset=UTF-8" %>
<nav class="nav">
  <a class="brand" href="menu">Queue<b>Less</b></a>
  <% if ("ADMIN".equals(session.getAttribute("role"))) { %>
    <a href="admin">Kitchen</a>
  <% } else { %>
    <a href="menu">Menu</a><a href="order">My tokens</a>
  <% } %>
  <span class="who"><%= session.getAttribute("name") %></span>
  <a href="auth">Log out</a>
</nav>
