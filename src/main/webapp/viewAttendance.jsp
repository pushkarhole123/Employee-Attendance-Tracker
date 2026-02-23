<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.utility.DBUtility"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
    // Logic to fetch detailed attendance and user data in one join to fix NULL values
    List<Map<String, Object>> attendanceList = new ArrayList<>();
    try (Connection con = DBUtility.getInstance().getDBConnection()) {
        String sql = "SELECT u.name as emp_name, a.* FROM attendance a " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "ORDER BY a.attendance_id DESC";
        
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(sql);
        while(rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("employeeName", rs.getString("emp_name"));
            row.put("userId", rs.getInt("user_id"));
            row.put("monthYear", rs.getString("month_year"));
            row.put("daysPresent", rs.getString("days_present"));
            row.put("leaveCount", rs.getInt("leave_count"));
            // Fetching analytics from the updated schema
            row.put("otHours", rs.getDouble("ot_hours"));
            row.put("totalHours", rs.getDouble("total_working_hours"));
            row.put("lateArrivals", rs.getInt("late_arrivals"));
            attendanceList.add(row);
        }
        request.setAttribute("attendanceData", attendanceList);
    } catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Enterprise Attendance | Market Level Analytics</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
	rel="stylesheet">

<style>
:root {
	--primary: #4F46E5;
	--primary-light: #EEF2FF;
	--secondary: #64748B;
	--bg: #F8FAFC;
	--card-bg: #FFFFFF;
	--text-main: #1E293B;
	--border: #E2E8F0;
	--success: #10B981;
	--danger: #EF4444;
	--wo-blue: #DBEAFE;
}

* {
	box-sizing: border-box;
	font-family: 'Plus Jakarta Sans', sans-serif;
}

body {
	background-color: var(--bg);
	color: var(--text-main);
	margin: 0;
	display: flex;
	min-height: 100vh;
}

/* --- Sidebar --- */
.sidebar {
	width: 260px;
	background: #0F172A;
	color: white;
	padding: 2rem 1.5rem;
	position: fixed;
	height: 100vh;
	z-index: 100;
}

.brand {
	display: flex;
	align-items: center;
	gap: 12px;
	font-size: 1.2rem;
	font-weight: 700;
	color: white;
	margin-bottom: 3rem;
	text-decoration: none;
}

.nav-link {
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 12px;
	color: #94A3B8;
	text-decoration: none;
	border-radius: 10px;
	margin-bottom: 8px;
	transition: 0.3s;
}

.nav-link.active {
	background: rgba(255, 255, 255, 0.05);
	color: white;
	border-left: 4px solid var(--primary);
}

/* --- Main Content & Grid --- */
.main-content {
	margin-left: 260px;
	padding: 2rem;
	width: calc(100% - 260px);
}

.data-card {
	background: var(--card-bg);
	border-radius: 12px;
	border: 1px solid var(--border);
	overflow: hidden;
	box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.table-container {
	overflow-x: auto;
	max-width: 100%;
}

table {
	width: 100%;
	border-collapse: collapse;
	white-space: nowrap;
}

th, td {
	padding: 12px 15px;
	border: 1px solid var(--border);
	text-align: center;
	font-size: 0.85rem;
}

th {
	background: #F8FAFC;
	color: var(--secondary);
	font-weight: 700;
	text-transform: uppercase;
	font-size: 0.7rem;
}

/* --- Sticky Employee Column --- */
.sticky-col {
	position: sticky;
	left: 0;
	background: white !important;
	z-index: 10;
	min-width: 220px;
	text-align: left;
	box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05);
}

.emp-info {
	display: flex;
	align-items: center;
	gap: 10px;
}

.avatar {
	width: 32px;
	height: 32px;
	background: var(--primary-light);
	color: var(--primary);
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 700;
}

/* --- Analytics Columns --- */
.analysis-header {
	background: #F1F5F9;
	color: var(--text-main);
	font-weight: 800;
}

.text-success {
	color: var(--success);
	font-weight: 700;
}

.text-danger {
	color: var(--danger);
	font-weight: 700;
}

/* --- Attendance States --- */
.status-p {
	color: var(--success);
	font-weight: 800;
}

.status-wo {
	background: var(--wo-blue);
	color: #1E40AF;
	font-size: 0.7rem;
	font-weight: 700;
}

.time-label {
	display: block;
	font-size: 0.65rem;
	color: var(--secondary);
	font-weight: 400;
}
</style>
</head>
<body>

	<aside class="sidebar">
		<a href="#" class="brand"><i class="fas fa-layer-group"></i> <span>PMS
				Admin</span></a>
		<nav>
			<a href="adminDashboard.jsp" class="nav-link"><i
				class="fas fa-house"></i> <span>Dashboard</span></a> <a
				href="viewAttendance.jsp" class="nav-link active"><i
				class="fas fa-calendar-check"></i> <span>Market Sheet</span></a>
		</nav>
	</aside>

	<main class="main-content">
		<header style="margin-bottom: 2rem;">
			<h1 style="font-size: 1.5rem; margin: 0;">Monthly Attendance
				Grid</h1>
			<p style="color: var(--secondary); margin: 5px 0 0 0;">Comprehensive
				31-day operational view and performance analytics.</p>
		</header>

		<div class="data-card">
			<div class="table-container">
				<table>
					<thead>
						<tr>
							<th class="sticky-col">Employee Profile</th>
							<% for(int i=1; i<=31; i++) { %>
							<th><%= (i < 10) ? "0"+i : i %></th>
							<% } %>
							<th class="analysis-header">Total Hrs</th>
							<th class="analysis-header">OT Hrs</th>
							<th class="analysis-header">Late</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${attendanceData}" var="r">
							<tr>
								<td class="sticky-col">
									<div class="emp-info">
										<div class="avatar">${r.employeeName.substring(0,1)}</div>
										<div>
											<div style="font-weight: 600;">${r.employeeName}</div>
											<div style="font-size: 0.7rem; color: var(--secondary);">ID:
												#${r.userId}</div>
										</div>
									</div>
								</td>

								<%-- Generating 31 Day Slots --%>
								<% for(int d=1; d<=31; d++) { 
                                    boolean isWeekend = (d % 7 == 0 || (d+1) % 7 == 0); // Simplified Weekend Logic
                                %>
								<td class="<%= isWeekend ? "status-wo" : "" %>">
									<% if(isWeekend) { %> WO <% } else { %> <span class="time-label">09:00</span>
									<span class="status-p">P</span> <% } %>
								</td>
								<% } %>

								<%-- Analytics data from Database --%>
								<td class="text-success">${r.totalHours}</td>
								<td style="font-weight: 600;">${r.otHours}</td>
								<td class="text-danger">${r.lateArrivals}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</main>

</body>
</html>