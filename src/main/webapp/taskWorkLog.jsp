<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.utility.DBUtility"%>
<%
    if (session == null || session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (Integer) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Log Work | ProTrack</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root {
	--primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	--glass: rgba(255, 255, 255, 0.08);
	--glass-border: rgba(255, 255, 255, 0.15);
	--accent: #00d2ff;
	--success: #22c55e;
}

body {
	font-family: 'Inter', sans-serif;
	background: radial-gradient(circle at top right, #1e293b, #0f172a);
	color: white;
	min-height: 100vh;
	display: flex;
	justify-content: center;
	align-items: center;
	margin: 0;
}

.log-container {
	background: var(--glass);
	backdrop-filter: blur(15px);
	border: 1px solid var(--glass-border);
	border-radius: 24px;
	width: 90%;
	max-width: 550px;
	padding: 40px;
	box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
}

.header {
	text-align: center;
	margin-bottom: 30px;
}

.form-group {
	margin-bottom: 20px;
}

.form-label {
	display: block;
	margin-bottom: 8px;
	font-size: 0.85rem;
	color: var(--accent);
	font-weight: 600;
	text-transform: uppercase;
}

.form-control {
	width: 100%;
	padding: 14px;
	background: rgba(15, 23, 42, 0.7);
	border: 1px solid var(--glass-border);
	border-radius: 12px;
	color: white;
	box-sizing: border-box;
}

/* Completion Toggle */
.completion-box {
	background: rgba(34, 197, 94, 0.1);
	border: 1px dashed var(--success);
	padding: 15px;
	border-radius: 12px;
	display: flex;
	align-items: center;
	gap: 12px;
	margin-top: 25px;
}

.btn-submit {
	width: 100%;
	padding: 16px;
	background: var(--primary-gradient);
	border: none;
	border-radius: 12px;
	color: white;
	font-weight: 700;
	cursor: pointer;
	margin-top: 20px;
}
</style>
</head>
<body>

	<div class="log-container">
		<div class="header">
			<h1>
				<i class="fas fa-file-signature"></i> Work Submission
			</h1>
			<p style="color: #94a3b8;">
				Log your daily progress,
				<%=userName%></p>
		</div>

		<form action="TaskLogServlet" method="post">
			<div class="form-group">
				<label class="form-label">Select Task / Project</label> <select
					name="project_id" class="form-control" required>
					<option value="" disabled selected>Select an active
						task...</option>
					<%
                        try (Connection con = DBUtility.getInstance().getDBConnection();
                             PreparedStatement ps = con.prepareStatement("SELECT project_id, project_name FROM projects");
                             ResultSet rs = ps.executeQuery()) {
                            while(rs.next()) {
                    %>
					<option value="<%=rs.getInt("project_id")%>"><%=rs.getString("project_name")%></option>
					<% } } catch(Exception e) { e.printStackTrace(); } %>
				</select>
			</div>

			<div class="form-group">
				<label class="form-label">Effort (Hours)</label> <input
					type="number" step="0.1" name="hours" class="form-control"
					placeholder="0.0" required>
			</div>

			<div class="form-group">
				<label class="form-label">Work Summary</label>
				<textarea name="task_desc" class="form-control"
					style="height: 100px;" placeholder="What did you achieve today?"
					required></textarea>
			</div>

			<div class="completion-box">
				<input type="checkbox" name="is_completed" value="true"
					style="width: 20px; height: 20px; cursor: pointer;">
				<div>
					<strong style="color: var(--success); display: block;">Mark
						Task as Completed</strong> <span
						style="font-size: 0.75rem; color: #94a3b8;">This will
						finalize the task in your dashboard.</span>
				</div>
			</div>

			<button type="submit" class="btn-submit">
				<i class="fas fa-paper-plane"></i> Submit Work Log
			</button>
		</form>

		<a href="userDashboard.jsp"
			style="display: block; text-align: center; margin-top: 20px; color: #94a3b8; text-decoration: none; font-size: 0.9rem;">
			<i class="fas fa-chevron-left"></i> Back to Dashboard
		</a>
	</div>
</body>
</html>