# QueueLess
Pre-order + token-based canteen system (JSP, Servlet, Tomcat 9, MySQL).

## Setup
1. Run `sql/schema.sql` in MySQL (creates DB, tables, sample menu, admin user).
2. Edit DB user/password in `src/main/java/com/queueless/util/DB.java`.
3. Eclipse: New > Dynamic Web Project (Tomcat 9, Servlet 4.0). Copy `src` and `WebContent` contents into it.
4. Put `mysql-connector-j-8.x.jar` and `jstl-1.2.jar` in `WEB-INF/lib`.
5. Run on Tomcat 9, open http://localhost:8080/QueueLess/

## Logins
Admin: admin@queueless.com / admin123 (students sign up on the login page)
