<%@page import="com.utility.DBUtility"%>
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    // Security Check: Only Admin can access
    if (session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Cumulative Timesheet Summary | ProTrack</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
<style>
:root {
	--primary: #2563EB;
	--dark: #0F172A;
	--bg: #F8FAFC;
	--border: #E2E8F0;
	--text: #1E293B;
	--muted: #64748B;
}

body {
	font-family: 'Inter', sans-serif;
	background: var(--bg);
	color: var(--text);
	padding: 40px;
	margin: 0;
}

.report-header {
	background: white;
	padding: 30px;
	border-radius: 12px 12px 0 0;
	border: 1px solid var(--border);
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
}

.stats-banner {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 20px;
	margin: 20px 0;
}

.stat-box {
	background: white;
	padding: 20px;
	border-radius: 12px;
	border: 1px solid var(--border);
	text-align: center;
}

.stat-box h3 {
	margin: 0;
	font-size: 2rem;
	color: var(--primary);
}

.stat-box p {
	margin: 5px 0 0;
	color: var(--muted);
	font-size: 0.9rem;
	font-weight: 600;
}

.table-container {
	background: white;
	border: 1px solid var(--border);
	border-radius: 0 0 12px 12px;
	overflow: hidden;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th {
	background: #F1F5F9;
	padding: 15px 20px;
	text-align: left;
	font-size: 0.8rem;
	text-transform: uppercase;
	color: var(--muted);
}

td {
	padding: 15px 20px;
	border-bottom: 1px solid var(--border);
	font-size: 0.95rem;
}

.total-row {
	background: var(--dark) !important;
	color: white !important;
	font-weight: 700;
}

.btn-print {
	background: var(--primary);
	color: white;
	padding: 10px 20px;
	border-radius: 8px;
	text-decoration: none;
	border: none;
	cursor: pointer;
}

@media print {
	.no-print {
		display: none;
	}
	body {
		padding: 0;
		background: white;
	}
	.report-header, .table-container {
		border: none;
	}
}
</style>
</head>
<body>

	<div class="no-print" style="margin-bottom: 20px;">
		<a href="adminDashboard.jsp"
			style="color: var(--muted); text-decoration: none; font-weight: 600;">
			<i class="fa-solid fa-arrow-left"></i> Back to Dashboard
		</a>
	</div>

	<div class="report-header">
		<div>
			<h1 style="margin: 0;">Mahendra's Timesheet Summary</h1>
			<p style="color: var(--muted); margin: 5px 0 0;">Cumulative
				Report Year 2025</p>
		</div>
		<div style="text-align: right;">
			<p style="font-size: 0.85rem; color: var(--muted);">
				Report Date: <strong>2025-11-22</strong>
			</p>
			<button class="btn-print" onclick="window.print()">
				<i class="fa-solid fa-file-pdf"></i> Download Report
			</button>
		</div>
	</div>

	<%
        double grandTotalHrs = 0;
        int grandTotalDays = 0;
    %>

	<div class="table-container">
		<table>
			<thead>
				<tr>
					<th>Job # (Project ID)</th>
					<th>Project Name</th>
					<th>Sum of Invoice Total Hrs</th>
					<th>Sum of Work Days</th>
					<th style="text-align: right;">Average Hrs/Day</th>
				</tr>
			</thead>
			<tbody>
				<%
                    try (Connection con = DBUtility.getInstance().getDBConnection();
                         PreparedStatement ps = con.prepareStatement(
                            "SELECT p.project_id, p.project_name, " +
                            "SUM(w.hours_worked) as total_hrs, " +
                            "COUNT(DISTINCT w.log_date) as work_days " +
                            "FROM work_log w " +
                            "JOIN projects p ON w.project_id = p.project_id " +
                            "GROUP BY p.project_id, p.project_name " +
                            "ORDER BY total_hrs DESC")) {
                        
                        ResultSet rs = ps.executeQuery();
                        while(rs.next()) {
                            double hrs = rs.getDouble("total_hrs");
                            int days = rs.getInt("work_days");
                            grandTotalHrs += hrs;
                            grandTotalDays += days;
                %>
				<tr>
					<td><strong><%= rs.getInt("project_id") %></strong></td>
					<td><%= rs.getString("project_name") %></td>
					<td><%= hrs %> Hrs</td>
					<td><%= days %> Days</td>
					<td style="text-align: right; color: var(--muted);"><%= String.format("%.2f", (hrs/days)) %>
					</td>
				</tr>
				<% 
                        }
                    } catch(Exception e) { e.printStackTrace(); } 
                %>

				<tr class="total-row">
					<td colspan="2" style="text-align: right;">GRAND TOTAL</td>
					<td><%= grandTotalHrs %> Hrs</td>
					<td><%= grandTotalDays %> Days</td>
					<td style="text-align: right;">-</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="stats-banner no-print">
		<div class="stat-box">
			<h3><%= grandTotalHrs %></h3>
			<p>TOTAL HOURS BILLED</p>
		</div>
		<div class="stat-box">
			<h3><%= grandTotalDays %></h3>
			<p>TOTAL UTILIZED DAYS</p>
		</div>
		<div class="stat-box">
			<h3><%= String.format("%.1f%%", (grandTotalHrs/2080)*100) %></h3>
			<p>ANNUAL CAPACITY UTILIZATION</p>
		</div>
	</div>

</body>
</html>