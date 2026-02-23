<%@page import="com.utility.DBUtility"%>
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
    // Security check: Only Admins should see the audit logs
    if (session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
<title>Activity Audit | ProTrack</title>
<link
	href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
<style>
body {
	font-family: 'Plus Jakarta Sans', sans-serif;
	background: #f1f5f9;
	color: #1e293b;
	padding: 40px;
}

.container {
	max-width: 900px;
	margin: 0 auto;
}

/* Timeline styling */
.timeline {
	position: relative;
	padding-left: 40px;
}

.timeline::before {
	content: '';
	position: absolute;
	left: 15px;
	top: 0;
	bottom: 0;
	width: 2px;
	background: #cbd5e1;
}

.log-card {
	background: white;
	border-radius: 16px;
	padding: 20px;
	margin-bottom: 25px;
	border: 1px solid #e2e8f0;
	position: relative;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
}

.log-card::before {
	content: '';
	position: absolute;
	left: -31px;
	top: 22px;
	width: 14px;
	height: 14px;
	background: #2563eb;
	border: 3px solid #f1f5f9;
	border-radius: 50%;
	z-index: 2;
}

.header-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.employee-name {
	font-weight: 700;
	font-size: 1rem;
	color: #0f172a;
}

/* Status Badges */
.status-badge {
	font-size: 0.7rem;
	font-weight: 700;
	padding: 4px 10px;
	border-radius: 20px;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.status-completed {
	background: #dcfce7;
	color: #166534;
	border: 1px solid #bbf7d0;
}

.status-progress {
	background: #fef9c3;
	color: #854d0e;
	border: 1px solid #fef08a;
}

.project-tag {
	font-size: 0.75rem;
	color: #64748b;
	font-weight: 600;
}

.description {
	margin: 12px 0;
	color: #475569;
	font-size: 0.9rem;
	line-height: 1.6;
}

.meta-footer {
	display: flex;
	gap: 20px;
	font-size: 0.8rem;
	color: #94a3b8;
	border-top: 1px solid #f1f5f9;
	padding-top: 12px;
}
</style>
</head>
<body>

	<div class="container">
		<div
			style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;">
			<div>
				<h1 style="margin: 0; font-size: 1.8rem;">Recent Activity Audit</h1>
				<p style="color: #64748b; margin-top: 5px;">Tracking all
					employee task completions and work logs.</p>
			</div>
			<a href="adminDashboard.jsp"
				style="text-decoration: none; color: #2563eb; font-weight: 600;">
				<i class="fa-solid fa-arrow-left"></i> Back to Dashboard
			</a>
		</div>

		<div class="timeline">
			<%
            try (Connection con = DBUtility.getInstance().getDBConnection();
                 PreparedStatement ps = con.prepareStatement(
                    "SELECT u.full_name, p.project_name, w.task_description, w.hours_worked, w.log_date, t.status " +
                    "FROM work_log w " +
                    "JOIN users u ON w.user_id = u.user_id " +
                    "JOIN projects p ON w.project_id = p.project_id " +
                    "LEFT JOIN tasks t ON t.user_id = w.user_id AND t.project_id = w.project_id " +
                    "ORDER BY w.log_id DESC")) {
                
                ResultSet rs = ps.executeQuery();
                boolean dataFound = false;
                while(rs.next()) {
                    dataFound = true;
                    String status = rs.getString("status");
                    if(status == null) status = "In Progress"; // Default if not found in tasks table
        %>
			<div class="log-card">
				<div class="header-row">
					<span class="employee-name"><i
						class="fa-solid fa-user-circle"></i> <%= rs.getString("full_name") %></span>
					<% if("Completed".equalsIgnoreCase(status)) { %>
					<span class="status-badge status-completed"><i
						class="fa-solid fa-check-double"></i> Completed</span>
					<% } else { %>
					<span class="status-badge status-progress"><i
						class="fa-solid fa-spinner fa-spin"></i> In Progress</span>
					<% } %>
				</div>

				<div class="project-tag">
					<i class="fa-solid fa-folder-open"></i>
					<%= rs.getString("project_name") %></div>

				<div class="description"><%= rs.getString("task_description") %></div>

				<div class="meta-footer">
					<span><i class="fa-regular fa-clock"></i> <%= rs.getDouble("hours_worked") %>
						Hours Worked</span> <span><i class="fa-regular fa-calendar"></i>
						Logged on: <%= rs.getDate("log_date") %></span>
				</div>
			</div>
			<% 
                } 
                if(!dataFound) {
                    out.println("<p style='text-align:center; color:#94a3b8;'>No activity logs recorded yet.</p>");
                }
            } catch(Exception e) { 
                e.printStackTrace(); 
                out.println("<p style='color:red;'>Error loading logs: " + e.getMessage() + "</p>");
            } 
        %>
		</div>
	</div>

</body>
</html>