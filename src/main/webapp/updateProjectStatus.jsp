<%@page import="com.utility.DBUtility"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
// 1. Security & Parameter Check
if (session.getAttribute("role") == null || !session.getAttribute("role").equals("ADMIN")) {
	response.sendRedirect("login.jsp");
	return;
}

String projId = request.getParameter("id");
if (projId == null) {
	response.sendRedirect("manageProjects.jsp");
	return;
}

// 2. Fetch current data to show in the update form
String projName = "";
String currentStatus = "";

try {
	Connection con = DBUtility.getInstance().getDBConnection();
	PreparedStatement ps = con.prepareStatement("SELECT project_name, status FROM projects WHERE project_id = ?");
	ps.setInt(1, Integer.parseInt(projId));
	ResultSet rs = ps.executeQuery();

	if (rs.next()) {
		projName = rs.getString("project_name");
		currentStatus = rs.getString("status");
	}
	con.close();
} catch (Exception e) {
	e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Update Status | <%=projName%></title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root {
	--primary: #4F46E5;
	--bg: #F9FAFB;
}

body {
	font-family: 'Inter', sans-serif;
	background: var(--bg);
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
}

.update-card {
	background: white;
	padding: 40px;
	border-radius: 16px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
	width: 100%;
	max-width: 450px;
	text-align: center;
}

.icon-circle {
	width: 60px;
	height: 60px;
	background: #EEF2FF;
	color: var(--primary);
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 20px;
	font-size: 1.5rem;
}

select {
	width: 100%;
	padding: 12px;
	border: 1px solid #D1D5DB;
	border-radius: 8px;
	margin: 20px 0;
	font-size: 1rem;
}

.btn-save {
	background: var(--primary);
	color: white;
	border: none;
	padding: 12px 25px;
	border-radius: 8px;
	cursor: pointer;
	font-weight: 600;
	width: 100%;
	transition: 0.3s;
}

.btn-save:hover {
	background: #4338CA;
}

.back-link {
	display: block;
	margin-top: 20px;
	color: #6B7280;
	text-decoration: none;
	font-size: 0.9rem;
}
</style>
</head>
<body>

	<div class="update-card">
		<div class="icon-circle">
			<i class="fas fa-sync-alt"></i>
		</div>

		<h2 style="margin: 0; color: #111827;">Update Project Status</h2>
		<p style="color: #6B7280; font-size: 0.9rem; margin-top: 8px;">
			Changing status for: <strong><%=projName%></strong>
		</p>

		<form
			action="${pageContext.request.contextPath}/UpdateProjectStatusServlet"
			method="post">
			<input type="hidden" name="project_id" value="<%=projId%>"> <label
				style="display: block; text-align: left; font-size: 0.8rem; font-weight: 600; color: #374151;">Select
				New Status</label> <select name="status">
				<option value="Active"
					<%="Active".equals(currentStatus) ? "selected" : ""%>>Active</option>
				<option value="Temporary Hold"
					<%="Temporary Hold".equals(currentStatus) ? "selected" : ""%>>On
					Hold</option>
				<option value="Banned"
					<%="Banned".equals(currentStatus) ? "selected" : ""%>>Banned</option>
				<option value="Completed"
					<%="Completed".equals(currentStatus) ? "selected" : ""%>>Completed</option>
				<option value="Archived"
					<%="Archived".equals(currentStatus) ? "selected" : ""%>>Archived</option>
			</select>

			<button type="submit" class="btn-save">Confirm Update</button>
		</form>

		<a href="manageProject.jsp" class="back-link"> <i
			class="fas fa-times"></i> Cancel and go back
		</a>
	</div>

</body>
</html>