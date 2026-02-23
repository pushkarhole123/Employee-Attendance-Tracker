<%@page import="com.utility.DBUtility"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
    // Session check
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String id = request.getParameter("id");
    String hoursWorked = request.getParameter("hours"); // Captured from Manage Salary
    if(hoursWorked == null) hoursWorked = "0";

    String fullName = "";
    try {
        Connection con = DBUtility.getInstance().getDBConnection();
        PreparedStatement ps = con.prepareStatement("SELECT full_name FROM users WHERE user_id = ?");
        ps.setString(1, id);
        ResultSet rs = ps.executeQuery();
        if(rs.next()) fullName = rs.getString("full_name");
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
<title>Calculate Disbursement | PMS</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap"
	rel="stylesheet">
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
	min-height: 100vh;
	margin: 0;
}

.form-card {
	background: white;
	padding: 40px;
	border-radius: 16px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
	width: 100%;
	max-width: 450px;
}

.header {
	margin-bottom: 25px;
	border-bottom: 1px solid #F3F4F6;
	padding-bottom: 15px;
}

.group {
	margin-bottom: 20px;
}

label {
	display: block;
	font-size: 0.85rem;
	font-weight: 600;
	color: #374151;
	margin-bottom: 8px;
}

input {
	width: 100%;
	padding: 12px;
	border: 1px solid #D1D5DB;
	border-radius: 8px;
	box-sizing: border-box;
	font-size: 1rem;
}

.readonly-info {
	background: #F3F4F6;
	color: #6B7280;
	cursor: not-allowed;
}

.btn-submit {
	background: var(--primary);
	color: white;
	border: none;
	padding: 14px;
	width: 100%;
	border-radius: 8px;
	font-weight: 600;
	cursor: pointer;
	margin-top: 10px;
	font-size: 1rem;
}

.btn-back {
	display: block;
	text-align: center;
	margin-top: 20px;
	color: #6B7280;
	text-decoration: none;
	font-size: 0.9rem;
	font-weight: 500;
}

.btn-back:hover {
	color: var(--primary);
}

.calculation-box {
	background: #EEF2FF;
	padding: 15px;
	border-radius: 8px;
	margin-bottom: 20px;
	border: 1px dashed var(--primary);
}
</style>
</head>
<body>

	<div class="form-card">
		<div class="header">
			<h2 style="margin: 0;">Process Salary</h2>
			<p style="color: #6B7280; font-size: 0.9rem;">
				Finalizing payment for <strong><%= fullName %></strong>
			</p>
		</div>

		<form action="SalaryServlet" method="post">
			<input type="hidden" name="userId" value="<%= id %>">

			<div class="calculation-box">
				<label>Reported Work Hours</label> <input type="text" name="hours"
					value="<%= hoursWorked %>" class="readonly-info" readonly>
				<small style="color: var(--primary); font-size: 0.75rem;">Calculated
					based on your input in the previous screen.</small>
			</div>

			<div class="group">
				<label>Month & Year</label> <input type="text" name="monthYear"
					placeholder="e.g. January 2026" required>
			</div>

			<div class="group">
				<label>Hourly Rate (Rs)</label> <input type="number"
					name="baseSalary" id="rate" placeholder="e.g. 25"
					oninput="calculateTotal()" required>
			</div>

			<div class="group">
				<label>Bonus (Rs)</label> <input type="number" name="bonus"
					id="bonus" value="0" oninput="calculateTotal()">
			</div>

			<div class="group">
				<label>Estimated Net Pay (Rs)</label> <input type="number"
					id="netPay" class="readonly-info" readonly>
			</div>

			<button type="submit" class="btn-submit">Confirm and
				Disburse</button>

			<a href="manageSalary.jsp" class="btn-back">← Cancel and Back to
				List</a>
		</form>
	</div>

	<script>
        function calculateTotal() {
            const hours = parseFloat("<%= hoursWorked %>");
            const rate = parseFloat(document.getElementById('rate').value) || 0;
            const bonus = parseFloat(document.getElementById('bonus').value) || 0;
            
            const total = (hours * rate) + bonus;
            document.getElementById('netPay').value = total.toFixed(2);
        }
    </script>

</body>
</html>