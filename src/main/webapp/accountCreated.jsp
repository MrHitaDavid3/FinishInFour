<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
String message = "";
boolean success = false;

String sjsuId = request.getParameter("sjsuId");
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String preferredName = request.getParameter("preferredName");
String email = request.getParameter("email");
String passwordValue = request.getParameter("password");
String confirmPassword = request.getParameter("confirmPassword");

if (sjsuId == null || firstName == null || lastName == null || email == null ||
    passwordValue == null || confirmPassword == null ||
    sjsuId.trim().isEmpty() || firstName.trim().isEmpty() ||
    lastName.trim().isEmpty() || email.trim().isEmpty() ||
    passwordValue.trim().isEmpty() || confirmPassword.trim().isEmpty()) {

    message = "All required fields must be filled in.";

} else if (!passwordValue.equals(confirmPassword)) {

    message = "Password and confirm password do not match.";

} else {

    String dbUser = "root";
    String dbPassword = "FoxyDoxy12!";

    Connection con = null;
    PreparedStatement checkStmt = null;
    PreparedStatement insertStmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/finishinfour?useSSL=false&serverTimezone=UTC",
            dbUser,
            dbPassword
        );

        String checkSql =
            "SELECT * FROM `user` " +
            "WHERE SJSU_ID = ? OR SJSU_Email_Address = ?";

        checkStmt = con.prepareStatement(checkSql);
        checkStmt.setString(1, sjsuId);
        checkStmt.setString(2, email);

        rs = checkStmt.executeQuery();

        if (rs.next()) {

            message = "An account with that SJSU ID or email already exists.";

        } else {

            String insertSql =
                "INSERT INTO `user` " +
                "(SJSU_ID, password, SJSU_Email_Address, firstName, lastName, preferredName) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

            insertStmt = con.prepareStatement(insertSql);

            insertStmt.setString(1, sjsuId);
            insertStmt.setString(2, passwordValue);
            insertStmt.setString(3, email);
            insertStmt.setString(4, firstName);
            insertStmt.setString(5, lastName);

            if (preferredName == null || preferredName.trim().isEmpty()) {
                insertStmt.setNull(6, java.sql.Types.VARCHAR);
            } else {
                insertStmt.setString(6, preferredName);
            }

            int rowsInserted = insertStmt.executeUpdate();

            if (rowsInserted > 0) {
                success = true;
                message = "Account created successfully.";
            } else {
                message = "Account creation failed.";
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        message = "Error: " + e.getMessage();

    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (checkStmt != null) checkStmt.close(); } catch (Exception e) {}
        try { if (insertStmt != null) insertStmt.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Account Created</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/studentHome.css">
</head>
<body>

<div class="page-container">
    <div class="home-card">

        <h1>Account Status</h1>
        <p class="subtitle">Your account request has been processed</p>

        <div class="section">

            <p class="message"><%= message %></p>

            <div class="action-row">
                <% if (success) { %>

                    <a href="<%= request.getContextPath() %>/login.jsp"
                       class="secondary-btn create-btn">
                        Go to Login
                    </a>

                <% } else { %>

                    <a href="<%= request.getContextPath() %>/createAccount.jsp"
                       class="secondary-btn create-btn">
                        Try Again
                    </a>

                    <a href="<%= request.getContextPath() %>/login.jsp"
                       class="secondary-btn">
                        Back to Login
                    </a>

                <% } %>
            </div>

        </div>

    </div>
</div>

</body>
</html>