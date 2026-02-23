<%@page import="com.utility.DBUtility"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
// Security Guard: Check if user is logged in and is an Admin
if (session.getAttribute("role") == null || !session.getAttribute("role").equals("ADMIN")) {
	response.sendRedirect("login.jsp");
	return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Manage Projects | PMS CORE</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
	--primary: #4F46E5;
	--success: #10B981;
	--warning: #F59E0B;
	--danger: #EF4444;
	--bg: #F9FAFB;
	--card: #FFFFFF;
}

body {
	font-family: 'Inter', sans-serif;
	background: var(--bg);
	margin: 0;
	display: flex;
}

.sidebar {
	width: 260px;
	background: #111827;
	color: white;
	height: 100vh;
	padding: 25px;
	position: fixed;
}

.content {
	margin-left: 280px;
	padding: 40px;
	width: calc(100% - 280px);
}

.grid {
	display: grid;
	grid-template-columns: 1fr 2fr;
	gap: 30px;
}

.card {
	background: var(--card);
	padding: 25px;
	border-radius: 12px;
	border: 1px solid #E5E7EB;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	font-size: 0.85rem;
	font-weight: 600;
	margin-bottom: 8px;
	color: #374151;
}

.form-group input, .form-group textarea {
	width: 100%;
	padding: 12px;
	border: 1px solid #D1D5DB;
	border-radius: 8px;
	font-family: inherit;
	font-size: 0.9rem;
}

.btn {
	background: var(--primary);
	color: white;
	border: none;
	padding: 12px;
	border-radius: 8px;
	cursor: pointer;
	font-weight: 600;
	width: 100%;
	transition: 0.2s ease;
}

.btn:hover {
	background: #4338CA;
	transform: translateY(-1px);
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 10px;
}

th {
	text-align: left;
	font-size: 0.75rem;
	color: #6B7280;
	text-transform: uppercase;
	padding: 12px;
	border-bottom: 2px solid #F3F4F6;
}

td {
	padding: 16px 12px;
	border-bottom: 1px solid #F3F4F6;
	vertical-align: middle;
}

.status-select {
	padding: 6px 10px;
	border: 1px solid #D1D5DB;
	border-radius: 6px;
	font-size: 0.8rem;
	font-weight: 500;
	cursor: pointer;
	background: #fff;
}

/* Status Stripe Indicators */
.status-Active {
	border-left: 4px solid var(--success);
}

.status-Hold {
	border-left: 4px solid var(--warning);
}

.status-Banned {
	border-left: 4px solid var(--danger);
}

.status-Completed {
	border-left: 4px solid var(--primary);
}

.status-Archived {
	border-left: 4px solid #9CA3AF;
}

.toast {
	background: #D1FAE5;
	color: #065F46;
	padding: 14px;
	border-radius: 10px;
	margin-bottom: 25px;
	font-weight: 500;
	border: 1px solid #A7F3D0;
}
</style>
</head>
<body>

	<div class="sidebar">
		<h2
			style="color: var(--primary); font-weight: 800; letter-spacing: -1px;">PMS
			CORE</h2>
		<nav style="margin-top: 40px;">
			<a href="adminDashboard.jsp"
				style="color: #9CA3AF; text-decoration: none; display: flex; align-items: center; gap: 12px; font-weight: 500;">
				<i class="fas fa-arrow-left"></i> Back to Dashboard
			</a>
		</nav>
	</div>

	<div class="content">
		<h1 style="font-weight: 800; color: #111827;">Project Control
			Center</h1>

		<%
		if (request.getParameter("status") != null) {
		%>
		<div id="statusToast" class="toast">
			<i class="fas fa-check-circle"></i> Success: Project state has been
			updated in the database.
		</div>

		<script>
			setTimeout(function() {
				var toast = document.getElementById('statusToast');
				if (toast) {
					toast.style.transition = "opacity 0.5s ease";
					toast.style.opacity = "0";

					setTimeout(function() {
						toast.style.display = "none";
					}, 500);
				}
			}, 5000);
		</script>
		<%
		}
		%>

		<div class="grid">
			<div class="card">
				<h3 style="margin-top: 0;">
					<i class="fas fa-plus-circle" style="color: var(--primary)"></i>
					New Project
				</h3>
				<form action="AddProjectServlet" method="post">
					<div class="form-group">
						<label>Project Designation</label> <input type="text"
							name="projectName" placeholder="Enter unique project name"
							required>
					</div>
					<div class="form-group">
						<label>Scope / Description</label>
						<textarea name="description" rows="5"
							placeholder="Define project objectives..."></textarea>
					</div>
					<button type="submit" class="btn">Deploy Project</button>
				</form>
			</div>

			<div class="card">
				<h3 style="margin-top: 0;">
					<i class="fas fa-layer-group" style="color: var(--success)"></i>
					Operational Projects
				</h3>
				<table>
					<thead>
						<tr>
							<th>Project Metadata</th>
							<th>Current State</th>
							<th style="text-align: right;">Operations</th>
						</tr>
					</thead>
					<tbody>
						<%
						Connection con = null;
						try {
							con = DBUtility.getInstance().getDBConnection();
							Statement st = con.createStatement();
							// Query optimized for display
							ResultSet rs = st.executeQuery("SELECT project_id, project_name, status FROM projects ORDER BY project_id DESC");

							while (rs.next()) {
								int projId = rs.getInt("project_id");
								String currentStatus = rs.getString("status");
								if (currentStatus == null)
							currentStatus = "Active";

								// UI class mapping
								String rowClass = currentStatus.contains("Hold") ? "Hold" : currentStatus;
						%>
						<tr class="status-<%=rowClass%>">
							<td>
								<div style="font-weight: 700; color: #111827;"><%=rs.getString("project_name")%></div>
								<div
									style="font-size: 0.75rem; color: #6B7280; margin-top: 3px;">
									UUID:
									<%=projId%></div>
							</td>
							<td>
								<form action="updateProjectStatus.jsp" method="get"
									style="display: inline;">
									<input type="hidden" name="id" value="<%=projId%>"> <select
										name="status" onchange="this.form.submit()"
										class="status-select">
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
								</form>
							</td>
							<td style="text-align: right;"><a
								href="deleteProject.jsp?id=<%=projId%>"
								onclick="return confirm('CRITICAL ACTION: Are you sure you want to permanently delete this project?')"
								style="color: var(--danger); text-decoration: none; font-size: 0.85rem; font-weight: 600;">
									<i class="fas fa-trash-alt"></i> Delete
							</a></td>
						</tr>
						<%
						}
						rs.close();
						st.close();
						} catch (Exception e) {
						out.println("<tr><td colspan='3' style='color:var(--danger);'>Error: Connectivity issue detected.</td></tr>");
						} finally {
						if (con != null)
						try {
							con.close();
						} catch (SQLException se) {
						}
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>

</body>
</html>