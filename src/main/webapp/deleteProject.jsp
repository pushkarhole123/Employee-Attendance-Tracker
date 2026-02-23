<%@page import="com.utility.DBUtility"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String projectId = request.getParameter("id");
    String projectName = "Unknown";
    
    // Fetch project details for confirmation
    try {
        Connection con = DBUtility.getInstance().getDBConnection();
        PreparedStatement ps = con.prepareStatement("SELECT project_name, status FROM projects WHERE project_id = ?");
        ps.setInt(1, Integer.parseInt(projectId));
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            projectName = rs.getString("project_name");
        }
        rs.close(); ps.close(); con.close();
    } catch (Exception e) {
        projectName = "Error loading project";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Confirm Delete | PMS</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap"
	rel="stylesheet">
<style>
:root {
	--primary: #4F46E5;
	--danger: #EF4444;
	--bg: #F9FAFB;
}

body {
	font-family: 'Inter', sans-serif;
	background: var(--bg);
	margin: 0;
	padding: 40px;
	display: flex;
	align-items: center;
	justify-content: center;
	min-height: 100vh;
}

.container {
	background: white;
	padding: 40px;
	border-radius: 12px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
	max-width: 500px;
	width: 100%;
}

.header {
	text-align: center;
	margin-bottom: 30px;
}

.header h1 {
	color: var(--danger);
	margin: 0 0 10px 0;
	font-size: 1.5rem;
}

.header p {
	color: #6B7280;
	margin: 0;
}

.project-details {
	background: #F9FAFB;
	padding: 20px;
	border-radius: 8px;
	margin-bottom: 30px;
	border-left: 4px solid var(--danger);
}

.project-details h3 {
	margin: 0 0 10px 0;
	color: #111827;
}

.detail-row {
	display: flex;
	justify-content: space-between;
	margin-bottom: 8px;
	font-size: 0.95rem;
}

.detail-label {
	font-weight: 500;
	color: #6B7280;
}

.detail-value {
	color: #111827;
	font-weight: 500;
}

.buttons {
	display: flex;
	gap: 12px;
}

.btn {
	flex: 1;
	padding: 12px 20px;
	border: none;
	border-radius: 6px;
	font-weight: 600;
	cursor: pointer;
	text-decoration: none;
	text-align: center;
	font-size: 0.95rem;
	display: inline-block;
	line-height: 1.5;
}

.btn-danger {
	background: var(--danger);
	color: white;
}

.btn-cancel {
	background: #F3F4F6;
	color: #6B7280;
}

.btn-danger:hover {
	background: #DC2626;
}

.btn-cancel:hover {
	background: #E5E7EB;
}
</style>
</head>
<body>
	<div class="container">
		<div class="header">
			<h1>⚠️ Delete Project</h1>
			<p>This action cannot be undone</p>
		</div>

		<div class="project-details">
			<h3>Project Information</h3>
			<div class="detail-row">
				<span class="detail-label">Project ID:</span> <span
					class="detail-value"><%= projectId %></span>
			</div>
			<div class="detail-row">
				<span class="detail-label">Project Name:</span> <span
					class="detail-value"><%= projectName %></span>
			</div>
		</div>

		<div class="buttons">
			<a href="DeleteProjectServlet?id=<%= projectId %>"
				class="btn btn-danger"> Yes, Delete Project </a> <a
				href="manageProject.jsp" class="btn btn-cancel"> Cancel </a>
		</div>
	</div>
</body>
</html>
