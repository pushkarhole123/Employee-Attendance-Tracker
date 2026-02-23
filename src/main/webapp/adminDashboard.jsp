<%@page import="com.utility.DBUtility"%>
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
// Session Security Check
if (session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))) {
	response.sendRedirect("login.jsp");
	return;
}

int totalEmployees = 0;
int totalProjects = 0;

try (Connection con = DBUtility.getInstance().getDBConnection(); Statement st = con.createStatement()) {

	// Stats Queries
	ResultSet rsEmp = st.executeQuery("SELECT COUNT(*) FROM users WHERE role='EMPLOYEE'");
	if (rsEmp.next())
		totalEmployees = rsEmp.getInt(1);

	ResultSet rsProj = st.executeQuery("SELECT COUNT(*) FROM projects");
	if (rsProj.next())
		totalProjects = rsProj.getInt(1);

} catch (Exception e) {
	e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard | ProTrack Professional</title>

<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

<style>
:root {
	--primary: #2563EB;
	--primary-soft: #EFF6FF;
	--dark: #0F172A;
	--bg: #F8FAFC;
	--card: #FFFFFF;
	--border: #E2E8F0;
	--text: #1E293B;
	--muted: #64748B;
	--success: #10B981;
	--danger: #EF4444;
	--warning: #F59E0B;
}

* {
	box-sizing: border-box;
	transition: all 0.2s ease;
}

body {
	margin: 0;
	font-family: 'Inter', sans-serif;
	background: var(--bg);
	color: var(--text);
	display: flex;
	overflow: hidden;
}

/* SIDEBAR */
.sidebar {
	width: 280px;
	height: 100vh;
	position: fixed;
	background: var(--dark);
	padding: 24px;
	display: flex;
	flex-direction: column;
	z-index: 100;
	overflow-y: auto;
}

.brand-box {
	padding: 12px;
	margin-bottom: 32px;
	border-left: 4px solid var(--primary);
}

.brand-box h2 {
	margin: 0;
	color: white;
	font-size: 1.5rem;
	letter-spacing: -1px;
}

.nav-label {
	font-size: 11px;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: 1px;
	color: #475569;
	margin: 24px 0 12px 12px;
}

.nav-link {
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 12px 16px;
	border-radius: 10px;
	text-decoration: none;
	color: #94A3B8;
	font-weight: 500;
	margin-bottom: 4px;
}

.nav-link:hover, .nav-link.active {
	background: rgba(255, 255, 255, 0.05);
	color: white;
}

.logout-link {
	margin-top: auto;
	color: #FCA5A5;
	border: 1px solid rgba(239, 68, 68, 0.2);
}

/* MAIN SECTION */
.main {
	margin-left: 280px;
	width: calc(100% - 280px);
	height: 100vh;
	overflow-y: auto;
}

.topbar {
	background: white;
	padding: 20px 40px;
	border-bottom: 1px solid var(--border);
	display: flex;
	justify-content: space-between;
	align-items: center;
	position: sticky;
	top: 0;
	z-index: 90;
}

.content {
	padding: 40px;
}

/* STATS */
.stats-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 24px;
	margin-bottom: 32px;
}

.stat-card {
	background: white;
	padding: 24px;
	border-radius: 16px;
	border: 1px solid var(--border);
	display: flex;
	align-items: center;
	gap: 20px;
}

.stat-icon {
	width: 54px;
	height: 54px;
	border-radius: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.5rem;
}

/* ATTENDANCE ACTION CARD */
.attendance-action-card {
	background: white;
	border: 1px solid var(--border);
	border-radius: 16px;
	padding: 24px;
	margin-bottom: 32px;
	display: flex;
	align-items: center;
	justify-content: space-between;
}

/* TABLE STYLES */
.table-container {
	background: white;
	border: 1px solid var(--border);
	border-radius: 16px;
	overflow: hidden;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
	margin-bottom: 32px;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th {
	background: #F8FAFC;
	padding: 16px 24px;
	text-align: left;
	font-size: 12px;
	text-transform: uppercase;
	color: var(--muted);
	border-bottom: 1px solid var(--border);
}

td {
	padding: 16px 24px;
	border-bottom: 1px solid #F1F5F9;
	font-size: 0.9rem;
}

.badge {
	padding: 4px 10px;
	border-radius: 12px;
	font-size: 0.75rem;
	font-weight: 600;
}

.avatar {
	width: 36px;
	height: 36px;
	background: var(--primary-soft);
	color: var(--primary);
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 700;
}

.badge-role {
	background: #DBEAFE;
	color: #1E40AF;
	padding: 4px 10px;
	border-radius: 12px;
	font-size: 0.75rem;
	font-weight: 600;
}

/* Enhanced Button Styling */
.btn {
	display: inline-flex;
	align-items: center;
	gap: 10px;
	padding: 12px 22px;
	border-radius: 12px;
	text-decoration: none;
	font-weight: 700;
	font-size: 0.85rem;
	border: none;
	cursor: pointer;
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn-activity {
	background: #ffffff;
	color: var(--dark);
	border: 1px solid var(--border);
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
}

.btn-activity:hover {
	background: var(--primary-soft);
	border-color: var(--primary);
	color: var(--primary);
	transform: translateY(-2px);
}

/* Pulsing Status Icon */
.status-dot {
	width: 8px;
	height: 8px;
	background-color: var(--warning);
	border-radius: 50%;
	display: inline-block;
	position: relative;
}

.status-dot::after {
	content: '';
	position: absolute;
	width: 100%;
	height: 100%;
	background-color: var(--warning);
	border-radius: 50%;
	animation: pulse 2s infinite;
}

@
keyframes pulse { 0% {
	transform: scale(1);
	opacity: 0.8;
}

70
%
{
transform
:
scale(
3
);
opacity
:
0;
}
100
%
{
transform
:
scale(
1
);
opacity
:
0;
}
}
.btn-primary {
	background: linear-gradient(135deg, var(--primary), #1e40af);
	color: white;
	box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
}

.btn-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 15px rgba(37, 99, 235, 0.4);
}

.btn-outline {
	border: 1px solid var(--border);
	background: white;
	color: var(--text);
	padding: 8px 16px;
	font-size: 0.75rem;
}
</style>
</head>

<body>

	<aside class="sidebar">
		<div class="brand-box">
			<h2>ProTrack</h2>
		</div>

		<div class="nav-label">Overview</div>
		<a href="adminDashboard.jsp" class="nav-link active"><i
			class="fa-solid fa-house"></i> Dashboard</a>

		<div class="nav-label">Management</div>
		<a href="addUser.jsp" class="nav-link"><i
			class="fa-solid fa-user-plus"></i> Add Employee</a> <a
			href="viewUsers.jsp" class="nav-link"><i
			class="fa-solid fa-users-gear"></i> Manage Staff</a> <a
			href="manageProject.jsp" class="nav-link"><i
			class="fa-solid fa-folder-tree"></i> Projects</a> <a
			href="manageTask.jsp" class="nav-link"><i
			class="fa-solid fa-clipboard-list"></i> Tasks</a>

		<div class="nav-label">Financial & HR</div>
		<a href="manageSalary.jsp" class="nav-link"><i
			class="fa-solid fa-wallet"></i> Payroll System</a> <a
			href="viewAttendance.jsp" class="nav-link"><i
			class="fa-solid fa-calendar-check"></i> Attendance</a> <a
			href="viewTimesheetDetails.jsp" class="nav-link"><i
			class="fa-solid fa-file-invoice"></i> Timesheet</a> <a
			href="viewReports.jsp" class="nav-link"><i
			class="fa-solid fa-chart-pie"></i> Reports</a> <a
			href="LogoutPageServlet" class="nav-link logout-link"><i
			class="fa-solid fa-power-off"></i> Logout</a>
	</aside>

	<main class="main">
		<header class="topbar">
			<div>
				<h2 style="margin: 0; font-size: 1.4rem;">Admin Control Center</h2>
				<span style="font-size: 0.85rem; color: var(--muted);"> <i
					class="fa-solid fa-circle-check" style="color: var(--success);"></i>
					System Active
				</span>
			</div>
			<div style="display: flex; gap: 15px; align-items: center;">
				<a href="viewActivityLogs.jsp" class="btn btn-activity"> <span
					class="status-dot"></span> <i class="fa-solid fa-clock-rotate-left"></i>
					Check Recent Activity
				</a> <a href="addUser.jsp" class="btn btn-primary"> <i
					class="fa-solid fa-user-plus"></i> Add Personnel
				</a>
			</div>
		</header>

		<div class="content">
			<div class="stats-grid">
				<div class="stat-card">
					<div class="stat-icon"
						style="background: #DBEAFE; color: var(--primary);">
						<i class="fa-solid fa-users"></i>
					</div>
					<div class="stat-info">
						<h4>Total Employees</h4>
						<p><%=totalEmployees%></p>
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon" style="background: #F3E8FF; color: #9333EA;">
						<i class="fa-solid fa-briefcase"></i>
					</div>
					<div class="stat-info">
						<h4>Active Projects</h4>
						<p><%=totalProjects%></p>
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon"
						style="background: #DCFCE7; color: var(--success);">
						<i class="fa-solid fa-shield-heart"></i>
					</div>
					<div class="stat-info">
						<h4>System Status</h4>
						<p style="color: var(--success); font-weight: 700;">LIVE</p>
					</div>
				</div>
			</div>

			<div class="attendance-action-card">
				<div style="display: flex; align-items: center; gap: 20px;">
					<i class="fa-solid fa-file-import"
						style="font-size: 2rem; color: var(--primary);"></i>
					<div>
						<h3 style="margin: 0; font-size: 1.1rem;">Import Daily
							Attendance</h3>
						<p
							style="margin: 5px 0 0; color: var(--muted); font-size: 0.85rem;">Upload
							monthly logs via Excel (.xlsx)</p>
					</div>
				</div>
				<form action="ExcelUploadServlet" method="post"
					enctype="multipart/form-data"
					style="display: flex; gap: 15px; align-items: center;">
					<input type="file" name="attendanceFile" required
						style="font-size: 0.8rem;">
					<button class="btn btn-primary">Process File</button>
				</form>
			</div>

			<div
				style="display: flex; justify-content: space-between; align-items: center; margin: 30px 0 20px 0;">
				<h3 style="margin: 0;">
					<i class="fa-solid fa-file-invoice-dollar"
						style="color: var(--primary);"></i> Employee Timesheet Summary
				</h3>
				<a href="allTimesheets.jsp" class="btn btn-outline">View Full
					Cumulative Report</a>
			</div>

			<div class="table-container">
				<table>
					<thead>
						<tr>
							<th>Job #</th>
							<th>Project Name</th>
							<th>Employee</th>
							<th>Week 1 Hrs</th>
							<th>Week 2 Hrs</th>
							<th style="text-align: right;">Invoice Total</th>
						</tr>
					</thead>
					<tbody>
						<%
						try (Connection con = DBUtility.getInstance().getDBConnection();
								PreparedStatement ps = con.prepareStatement("SELECT p.project_id, p.project_name, u.full_name, "
								+ "SUM(CASE WHEN w.log_date BETWEEN '2025-10-27' AND '2025-11-02' THEN w.hours_worked ELSE 0 END) as week1, "
								+ "SUM(CASE WHEN w.log_date BETWEEN '2025-11-03' AND '2025-11-09' THEN w.hours_worked ELSE 0 END) as week2 "
								+ "FROM work_log w " + "JOIN projects p ON w.project_id = p.project_id "
								+ "JOIN users u ON w.user_id = u.user_id " + "GROUP BY p.project_id, u.user_id LIMIT 5")) {

							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
								double total = rs.getDouble("week1") + rs.getDouble("week2");
						%>
						<tr>
							<td><code style="color: var(--primary); font-weight: bold;"><%=rs.getInt("project_id")%></code></td>
							<td><%=rs.getString("project_name")%></td>
							<td><%=rs.getString("full_name")%></td>
							<td><%=rs.getDouble("week1")%></td>
							<td><%=rs.getDouble("week2")%></td>
							<td style="text-align: right;"><span class="badge"
								style="background: var(--dark); color: white;"> <%=total%>
									Hrs
							</span></td>
						</tr>
						<%
						}
						} catch (Exception e) {
						e.printStackTrace();
						}
						%>
					</tbody>
				</table>
			</div>

			<div
				style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
				<h3 style="margin: 0;">Personnel Overview</h3>
				<a href="viewUsers.jsp"
					style="font-size: 0.85rem; color: var(--primary); text-decoration: none; font-weight: 600;">Manage
					All</a>
			</div>

			<div class="table-container">
				<table>
					<thead>
						<tr>
							<th>Personnel</th>
							<th>Username</th>
							<th>Access Level</th>
							<th style="text-align: right;">Actions</th>
						</tr>
					</thead>
					<tbody>
						<%
						try (Connection con = DBUtility.getInstance().getDBConnection();
								PreparedStatement ps = con
								.prepareStatement("SELECT * FROM users WHERE role != 'ADMIN' ORDER BY user_id DESC LIMIT 5")) {
							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
								String name = rs.getString("full_name");
						%>
						<tr>
							<td>
								<div style="display: flex; align-items: center; gap: 12px;">
									<div class="avatar"><%=name.substring(0, 1).toUpperCase()%></div>
									<div style="font-weight: 600;"><%=name%></div>
								</div>
							</td>
							<td><code
									style="background: #F1F5F9; padding: 4px 8px; border-radius: 6px;">
									@<%=rs.getString("username")%></code></td>
							<td><span class="badge-role"><%=rs.getString("role")%></span></td>
							<td style="text-align: right;"><a
								href="editUser.jsp?id=<%=rs.getInt("user_id")%>"
								style="color: var(--primary); margin-right: 15px;"><i
									class="fa-solid fa-pen"></i></a> <a
								href="deleteUser.jsp?id=<%=rs.getInt("user_id")%>"
								style="color: var(--danger);"><i class="fa-solid fa-trash"></i></a>
							</td>
						</tr>
						<%
						}
						} catch (Exception e) {
						e.printStackTrace();
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</main>
</body>
</html>