<%@page import="com.utility.DBUtility"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userId = request.getParameter("id");
    String fullName = "", username = "", role = "";

    try {
        Connection con = DBUtility.getInstance().getDBConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE user_id = ?");
        ps.setString(1, userId);
        ResultSet rs = ps.executeQuery();
        if(rs.next()) {
            fullName = rs.getString("full_name");
            username = rs.getString("username");
            role = rs.getString("role");
        }
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User | PMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #4F46E5; --bg: #F9FAFB; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .edit-card { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); width: 100%; max-width: 450px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-size: 0.85rem; font-weight: 600; color: #374151; margin-bottom: 8px; }
        input, select { width: 100%; padding: 12px; border: 1px solid #D1D5DB; border-radius: 8px; box-sizing: border-box; }
        .btn-update { background: var(--primary); color: white; border: none; padding: 12px; width: 100%; border-radius: 8px; font-weight: 600; cursor: pointer; margin-top: 10px; }
        .cancel-link { display: block; text-align: center; margin-top: 20px; color: #6B7280; text-decoration: none; font-size: 0.9rem; }
    </style>
</head>
<body>

    <div class="edit-card">
        <h2 style="margin-top: 0;">Edit User Profile</h2>
        <p style="color: #6B7280; font-size: 0.9rem; margin-bottom: 30px;">Update credentials or system access for <strong><%= username %></strong></p>

        <form action="UpdateUserServlet" method="post">
            <input type="hidden" name="userId" value="<%= userId %>">

            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" value="<%= fullName %>" required>
            </div>

            <div class="form-group">
                <label>System Role</label>
                <select name="role">
                    <option value="EMPLOYEE" <%= role.equals("EMPLOYEE") ? "selected" : "" %>>Employee</option>
                    <option value="ADMIN" <%= role.equals("ADMIN") ? "selected" : "" %>>Administrator</option>
                </select>
            </div>

            <div class="form-group">
                <label>New Password (Leave blank to keep current)</label>
                <input type="password" name="newPassword" placeholder="••••••••">
            </div>

            <button type="submit" class="btn-update">Save Changes</button>
            <a href="viewUsers.jsp" class="cancel-link">Cancel and Go Back</a>
        </form>
    </div>

</body>
</html>