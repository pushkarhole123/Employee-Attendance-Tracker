<%@page import="com.utility.DBUtility"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Task Engine | Admin Console</title>
<link
	href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
	--brand: #6366f1;
	--brand-soft: #eef2ff;
	--surface: #ffffff;
	--bg-main: #fcfcfd;
	--text-heading: #1e293b;
	--text-body: #475569;
	--sidebar-width: 260px;
}

* {
	box-sizing: border-box;
}

body {
	font-family: 'Plus Jakarta Sans', sans-serif;
	background: var(--bg-main);
	color: var(--text-body);
	margin: 0;
	display: flex;
	min-height: 100vh;
}

/* Sidebar */
.sidebar {
	width: var(--sidebar-width);
	background: #111827;
	color: #f8fafc;
	padding: 2rem 1.5rem;
	position: fixed;
	height: 100vh;
	display: flex;
	flex-direction: column;
	z-index: 1000;
}

.nav-item {
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 0.875rem 1rem;
	color: #94a3b8;
	text-decoration: none;
	border-radius: 12px;
	margin-bottom: 0.5rem;
	transition: all 0.2s;
	font-weight: 500;
}

.nav-item:hover, .nav-item.active {
	background: rgba(255, 255, 255, 0.1);
	color: white;
}

/* Viewport Logic */
.viewport {
	margin-left: var(--sidebar-width);
	flex: 1;
	padding: 40px;
	min-height: 100vh;
	display: block;
}

.dashboard-header {
	margin-bottom: 3rem;
	padding-bottom: 1.5rem;
	border-bottom: 1px solid #e2e8f0;
}

/* Cards */
.action-card {
	background: var(--surface);
	border: 1px solid #e2e8f0;
	border-radius: 20px;
	padding: 2rem;
	margin-bottom: 2.5rem;
	box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
}

.input-group {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 1.5rem;
	margin-bottom: 1.5rem;
}

.field label {
	display: block;
	font-size: 0.875rem;
	font-weight: 600;
	color: var(--text-heading);
	margin-bottom: 0.5rem;
}

.field input, .field select {
	width: 100%;
	padding: 0.75rem 1rem;
	border: 1px solid #cbd5e1;
	border-radius: 10px;
	font-family: inherit;
	font-size: 0.935rem;
}

.btn-submit {
	background: var(--brand);
	color: white;
	padding: 0.875rem 2rem;
	border: none;
	border-radius: 10px;
	font-weight: 700;
	cursor: pointer;
	transition: 0.3s;
}

.btn-submit:hover {
	transform: translateY(-2px);
	box-shadow: 0 10px 15px -3px rgba(99, 102, 241, 0.3);
}

/* Table */
.table-card {
	background: var(--surface);
	border: 1px solid #e2e8f0;
	border-radius: 20px;
	overflow: hidden;
}

.table-header {
	padding: 1.5rem 2rem;
	border-bottom: 1px solid #f1f5f9;
	background: #f8fafc;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th {
	text-align: left;
	padding: 1rem 2rem;
	font-size: 0.75rem;
	font-weight: 700;
	text-transform: uppercase;
	color: #64748b;
}

td {
	padding: 1.25rem 2rem;
	border-bottom: 1px solid #f1f5f9;
}

.badge {
	padding: 4px 12px;
	border-radius: 6px;
	font-size: 0.75rem;
	font-weight: 700;
}

.status-pending {
	background: #fef3c7;
	color: #92400e;
}

.status-completed {
	background: #dcfce7;
	color: #166534;
}

.user-meta {
	display: flex;
	align-items: center;
	gap: 12px;
}

.avatar {
	width: 36px;
	height: 36px;
	background: linear-gradient(135deg, #6366f1, #a855f7);
	color: white;
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 700;
	font-size: 0.8rem;
}
</style>
</head>
<body>

	<aside class="sidebar">
		<div
			style="font-size: 1.5rem; font-weight: 800; margin-bottom: 3rem; color: white;">
			<i class="fas fa-cubes"></i> PRO<span style="color: var(--brand)">TRACK</span>
		</div>
		<nav>
			<a href="adminDashboard.jsp" class="nav-item"><i
				class="fas fa-chart-pie"></i> Dashboard</a>

		</nav>
	</aside>

	<main class="viewport">
		<header class="dashboard-header">
			<div class="header-content">
				<h1
					style="color: var(--text-heading); margin: 0; font-size: 2.25rem; font-weight: 800; letter-spacing: -0.025em;">
					Task Assignments</h1>
				<p
					style="margin-top: 0.75rem; font-size: 1.1rem; color: #64748b; font-weight: 500;">
					Manage and monitor team performance metrics</p>
			</div>
		</header>

		<section class="action-card">
			<h3
				style="margin-top: 0; margin-bottom: 2rem; font-size: 1.25rem; color: var(--text-heading);">
				<i class="fas fa-plus-circle"
					style="color: var(--brand); margin-right: 8px;"></i> Dispatch New
				Directive
			</h3>
			<form action="AddTaskServlet" method="post">
				<div class="input-group">
					<div class="field">
						<label>Active Project</label> <select name="projectId" required>
							<option value="" disabled selected>Select Scope</option>
							<%
                                try (Connection con = DBUtility.getInstance().getDBConnection();
                                     Statement stProj = con.createStatement();
                                     ResultSet rsProj = stProj.executeQuery("SELECT project_id, project_name FROM projects")) {
                                    while(rsProj.next()){
                            %>
							<option value="<%= rsProj.getInt("project_id") %>"><%= rsProj.getString("project_name") %></option>
							<% } } catch(Exception e) {} %>
						</select>
					</div>
					<div class="field">
						<label>Lead Personnel</label> <select name="userId" required>
							<option value="" disabled selected>Select Assignee</option>
							<%
                                try (Connection con = DBUtility.getInstance().getDBConnection();
                                     Statement stUser = con.createStatement();
                                     ResultSet rsUser = stUser.executeQuery("SELECT user_id, full_name FROM users WHERE role = 'EMPLOYEE'")) {
                                    while(rsUser.next()){
                            %>
							<option value="<%= rsUser.getInt("user_id") %>"><%= rsUser.getString("full_name") %></option>
							<% } } catch(Exception e) {} %>
						</select>
					</div>
					<div class="field">
						<label>Target Deadline</label> <input type="date" name="dueDate"
							required>
					</div>
				</div>

				<div class="field" style="margin-bottom: 2rem;">
					<label>Task Specification</label> <input type="text"
						name="taskTitle" placeholder="Detail the objective briefly..."
						required>
				</div>

				<button type="submit" class="btn-submit">
					<i class="fas fa-paper-plane" style="margin-right: 8px;"></i>
					Commit Assignment
				</button>
			</form>
		</section>

		<section class="table-card">
			<div class="table-header">
				<h3
					style="margin: 0; font-size: 1.1rem; color: var(--text-heading);">Operational
					Queue</h3>
			</div>
			<table>
				<thead>
					<tr>
						<th>Personnel</th>
						<th>Project Entity</th>
						<th>Directive Title</th>
						<th>Schedule</th>
						<th>Current State</th>
					</tr>
				</thead>
				<tbody>
					<%
                        try (Connection con = DBUtility.getInstance().getDBConnection();
                             Statement stTask = con.createStatement();
                             ResultSet rsTask = stTask.executeQuery("SELECT t.title, t.due_date, t.status, p.project_name, u.full_name " +
                                                                   "FROM tasks t JOIN projects p ON t.project_id = p.project_id " +
                                                                   "JOIN users u ON t.user_id = u.user_id ORDER BY t.due_date DESC")) {
                            while(rsTask.next()){
                                String status = rsTask.getString("status").toLowerCase();
                                String statusClass = status.equals("completed") ? "status-completed" : "status-pending";
                    %>
					<tr>
						<td>
							<div class="user-meta">
								<div class="avatar"><%= rsTask.getString("full_name").substring(0,1).toUpperCase() %></div>
								<span style="font-weight: 600; color: var(--text-heading);"><%= rsTask.getString("full_name") %></span>
							</div>
						</td>
						<td><span style="font-weight: 500; color: var(--brand);"><%= rsTask.getString("project_name") %></span></td>
						<td style="font-weight: 500;"><%= rsTask.getString("title") %></td>
						<td style="color: #64748b;"><i class="far fa-calendar-alt"
							style="margin-right: 6px;"></i><%= rsTask.getDate("due_date") %></td>
						<td><span class="badge <%= statusClass %>"><%= status %></span></td>
					</tr>
					<% } } catch(Exception e) { } %>
				</tbody>
			</table>
		</section>
	</main>
</body>
</html>