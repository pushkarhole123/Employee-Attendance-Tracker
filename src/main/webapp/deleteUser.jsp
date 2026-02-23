<%@page import="com.utility.DBUtility"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }
    String userId = request.getParameter("id");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Confirm Deletion | PMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #F9FAFB; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .confirm-card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; max-width: 400px; }
        .warning-icon { color: #EF4444; font-size: 3rem; margin-bottom: 10px; }
        .btn-container { display: flex; gap: 10px; justify-content: center; margin-top: 20px; }
        .btn { padding: 10px 20px; border-radius: 6px; text-decoration: none; font-weight: 600; cursor: pointer; border: none; }
        .btn-danger { background: #EF4444; color: white; }
        .btn-cancel { background: #E5E7EB; color: #374151; }
    </style>
</head>
<body>

    <div class="confirm-card">
        <div class="warning-icon">⚠️</div>
        <h2>Confirm Deletion</h2>
        <p>Are you sure you want to permanently delete this user? This action cannot be undone and may affect task history.</p>
        
        <div class="btn-container">
            <form action="DeleteUserServlet" method="post">
                <input type="hidden" name="userId" value="<%= userId %>">
                <button type="submit" class="btn btn-danger">Yes, Delete User</button>
            </form>
            <a href="viewUsers.jsp" class="btn btn-cancel">No, Keep User</a>
        </div>
    </div>

</body>
</html>