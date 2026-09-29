<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/welcomeStyles.css">
</head>
<body>

<%
String user = (String) session.getAttribute("user");

if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<div class="welcome-container">
    
    <div class="card">
        <h1>Welcome, <span><%= user %></span> 👋</h1>
        <p>You’ve successfully logged in.</p>

        <div class="actions">
            <a href="#" class="btn">Go to Dashboard</a>
            <a href="<%= request.getContextPath() %>/logout" class="btn logout">Logout</a>
        </div>
    </div>

</div>

</body>
</html>