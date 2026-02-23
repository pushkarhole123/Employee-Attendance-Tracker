<%@page import="com.utility.DBUtility"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

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
<title>Performance Intelligence | Admin</title>
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

.report-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 25px;
	margin-top: 30px;
}

.report-card {
	background: var(--card);
	padding: 25px;
	border-radius: 16px;
	border: 1px solid #E5E7EB;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
}

.progress-container {
	background: #E5E7EB;
	border-radius: 10px;
	height: 8px;
	width: 100%;
	margin: 10px 0;
	overflow: hidden;
}

.progress-fill {
	height: 100%;
	transition: width 1s ease-in-out;
}

.badge {
	padding: 4px 10px;
	border-radius: 20px;
	font-size: 0.7rem;
	font-weight: 700;
	text-transform: uppercase;
	display: inline-flex;
	align-items: center;
	gap: 5px;
}

.bg-success-light {
	background: #D1FAE5;
	color: #065F46;
}

.bg-warning-light {
	background: #FEF3C7;
	color: #92400E;
}

.bg-danger-light {
	background: #FEE2E2;
	color: #991B1B;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

th {
	text-align: left;
	font-size: 0.75rem;
	color: #6B7280;
	text-transform: uppercase;
	padding: 12px 0;
	border-bottom: 2px solid #F3F4F6;
}

td {
	padding: 15px 0;
	border-bottom: 1px solid #F3F4F6;
	font-size: 0.9rem;
}

/* SIDE PANEL STYLES */
.side-panel {
	position: fixed;
	top: 0;
	right: -450px;
	width: 400px;
	height: 100vh;
	background: white;
	box-shadow: -10px 0 30px rgba(0, 0, 0, 0.1);
	z-index: 1000;
	transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
	padding: 30px;
	overflow-y: auto;
}

.side-panel.active {
	transform: translateX(-450px);
}

.panel-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100vw;
	height: 100vh;
	background: rgba(0, 0, 0, 0.3);
	backdrop-filter: blur(2px);
	z-index: 999;
	display: none;
}

.panel-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1px solid #f0f0f0;
	padding-bottom: 20px;
	margin-bottom: 25px;
}

.panel-avatar {
	width: 50px;
	height: 50px;
	background: #EEF2FF;
	color: var(--primary);
	border-radius: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 700;
	font-size: 1.2rem;
}

.btn-export {
	background: white;
	border: 1px solid #D1D5DB;
	padding: 8px 16px;
	border-radius: 8px;
	cursor: pointer;
	font-weight: 600;
	display: flex;
	align-items: center;
	gap: 8px;
}

@media print {
	.sidebar, .btn-export, .side-panel {
		display: none;
	}
	.content {
		margin-left: 0;
		width: 100%;
	}
}
</style>
</head>
<body>

	<div class="sidebar">
		<h2 style="color: var(--primary); font-weight: 800;">PMS CORE</h2>
		<nav style="margin-top: 40px;">
			<a href="adminDashboard.jsp"
				style="color: #9CA3AF; text-decoration: none; display: flex; align-items: center; gap: 10px;">
				<i class="fas fa-arrow-left"></i> Dashboard
			</a>
		</nav>
	</div>

	<div class="content">
		<div
			style="display: flex; justify-content: space-between; align-items: center;">
			<div>
				<h1 style="margin: 0; font-weight: 800; letter-spacing: -0.025em;">Performance
					Intelligence</h1>
				<p style="color: #6B7280; margin-top: 5px;">Analytical summary
					of organizational health.</p>
			</div>
			<button class="btn-export" onclick="window.print()">
				<i class="fas fa-file-pdf"></i> Export Report
			</button>
		</div>

		<div class="report-grid">
			<div class="report-card">
				<h3 style="margin-top: 0;">
					<i class="fas fa-diagram-project" style="color: var(--primary)"></i>
					Project Progress
				</h3>
				<%
                    Connection con = null;
                    try {
                        con = DBUtility.getInstance().getDBConnection();
                        String sql = "SELECT p.project_name, COUNT(t.task_id) AS total, SUM(CASE WHEN t.status = 'COMPLETED' THEN 1 ELSE 0 END) AS done FROM projects p LEFT JOIN tasks t ON p.project_id = t.project_id GROUP BY p.project_id, p.project_name";
                        Statement st = con.createStatement();
                        ResultSet rs = st.executeQuery(sql);
                        while (rs.next()) {
                            int total = rs.getInt("total"); int done = rs.getInt("done"); int percent = (total > 0) ? (done * 100 / total) : 0;
                            String color = (percent < 40) ? "var(--danger)" : (percent < 80 ? "var(--warning)" : "var(--success)");
                %>
				<div style="margin-bottom: 22px;">
					<div
						style="display: flex; justify-content: space-between; font-size: 0.85rem; margin-bottom: 5px;">
						<span style="font-weight: 600;"><%= rs.getString("project_name") %></span>
						<span style="color: <%= color %>; font-weight: 700;"><%= percent %>%</span>
					</div>
					<div class="progress-container">
						<div class="progress-fill"
							style="width:<%= percent %>%; background: <%= color %>"></div>
					</div>
				</div>
				<% } rs.close(); st.close(); } catch (Exception e) { e.printStackTrace(); } %>
			</div>

			<div class="report-card">
				<h3 style="margin-top: 0;">
					<i class="fas fa-user-check" style="color: var(--success)"></i>
					Attendance Efficiency
				</h3>
				<table>
					<thead>
						<tr>
							<th>Employee</th>
							<th>Trend</th>
							<th>Score</th>
							<th>Reliability</th>
						</tr>
					</thead>
					<tbody>
						<%
                            try {
                                String attSql = "SELECT u.full_name, COUNT(a.attendance_id) AS days FROM users u JOIN attendance a ON u.user_id = a.user_id WHERE a.status = 'Present' GROUP BY u.user_id, u.full_name LIMIT 6";
                                Statement stAtt = con.createStatement();
                                ResultSet rsAtt = stAtt.executeQuery(attSql);
                                while (rsAtt.next()) {
                                    int days = rsAtt.getInt("days");
                                    int efficiency = (days * 100) / 22; if(efficiency > 100) efficiency = 100;
                                    String badgeClass = (efficiency >= 90) ? "bg-success-light" : (efficiency >= 70 ? "bg-warning-light" : "bg-danger-light");
                                    String status = (efficiency >= 90) ? "Optimal" : (efficiency >= 70 ? "Stable" : "Review");
                        %>
						<tr style="cursor: pointer;"
							onclick="openPanel('<%= rsAtt.getString("full_name") %>', '<%= efficiency %>', '<%= status %>')">
							<td style="font-weight: 600;">
								<div style="display: flex; align-items: center; gap: 10px;">
									<div class="panel-avatar"
										style="width: 30px; height: 30px; font-size: 10px;"><%= rsAtt.getString("full_name").substring(0, 1) %></div>
									<%= rsAtt.getString("full_name") %>
								</div>
							</td>
							<td><i class="fas fa-caret-up text-success"></i> <span
								style="font-size: 11px; color: #6B7280;">+2%</span></td>
							<td><div style="font-size: 11px; font-weight: 700;"><%= efficiency %>%
								</div></td>
							<td><span class="badge <%= badgeClass %>"><%= status %></span></td>
						</tr>
						<% } rsAtt.close(); stAtt.close(); } catch (Exception e) { e.printStackTrace(); } finally { if(con != null) con.close(); } %>
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<div id="sidePanel" class="side-panel">
		<div class="panel-header">
			<div style="display: flex; align-items: center; gap: 15px;">
				<div id="panelAvatar" class="panel-avatar"></div>
				<div>
					<h2 id="panelUserName" style="margin: 0; font-size: 1.2rem;"></h2>
					<span id="panelStatus" style="font-size: 0.8rem; color: #6B7280;"></span>
				</div>
			</div>
			<button onclick="closePanel()"
				style="background: none; border: none; cursor: pointer; font-size: 1.2rem; color: #9CA3AF;">
				<i class="fas fa-times"></i>
			</button>
		</div>
		<div class="panel-body">
			<h4 style="color: #374151; margin-bottom: 15px;">
				<i class="fas fa-history"></i> Recent Activity
			</h4>
			<div id="panelContent"></div>
		</div>
	</div>
	<div id="panelOverlay" class="panel-overlay" onclick="closePanel()"></div>

	<script>
        function openPanel(name, score, status) {
            document.getElementById('panelUserName').innerText = name;
            document.getElementById('panelAvatar').innerText = name.substring(0, 1);
            document.getElementById('panelStatus').innerText = "Efficiency Score: " + score + "% (" + status + ")";
            
            // In a real app, you would fetch this dynamic data via AJAX
            document.getElementById('panelContent').innerHTML = `
                <div style="background:#F9FAFB; padding:15px; border-radius:12px; border:1px solid #E5E7EB;">
                    <p style="margin:0; font-size:0.9rem; color:#4B5563;">Status: <b style="color:var(--success)">Active</b></p>
                    <p style="margin:5px 0 0; font-size:0.8rem; color:#6B7280;">Last check-in: Today, 09:15 AM</p>
                </div>
            `;
            
            document.getElementById('sidePanel').classList.add('active');
            document.getElementById('panelOverlay').style.display = 'block';
        }

        function closePanel() {
            document.getElementById('sidePanel').classList.remove('active');
            document.getElementById('panelOverlay').style.display = 'none';
        }
    </script>
</body>
</html>