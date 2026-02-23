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
<html>
<head>
<title>Payroll Management | PMS</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap"
	rel="stylesheet">
<style>
:root {
	--primary: #4F46E5;
	--bg: #F9FAFB;
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
	height: 100vh;
	position: fixed;
	padding: 20px;
	color: white;
}

.content {
	margin-left: 280px;
	padding: 40px;
	width: calc(100% - 280px);
}

.card {
	background: white;
	padding: 25px;
	border-radius: 12px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

/* Search Bar Styles */
.controls-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.search-box {
	padding: 10px 15px;
	width: 300px;
	border: 1px solid #D1D5DB;
	border-radius: 8px;
	font-size: 0.9rem;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th {
	background: #F3F4F6;
	padding: 12px;
	text-align: left;
	font-size: 0.75rem;
	color: #6B7280;
	text-transform: uppercase;
}

td {
	padding: 12px;
	border-bottom: 1px solid #F3F4F6;
	font-size: 0.9rem;
}

.hours-input {
	width: 80px;
	padding: 5px;
	border: 1px solid #D1D5DB;
	border-radius: 4px;
	text-align: center;
}

.status-paid {
	color: #059669;
	background: #DCFCE7;
	padding: 4px 8px;
	border-radius: 12px;
	font-size: 0.75rem;
}

.status-pending {
	color: #DC2626;
	background: #FEE2E2;
	padding: 4px 8px;
	border-radius: 12px;
	font-size: 0.75rem;
}

.btn-pay {
	background: var(--primary);
	color: white;
	padding: 8px 16px;
	border-radius: 6px;
	text-decoration: none;
	font-size: 0.8rem;
	font-weight: 600;
}
</style>
</head>
<body>
	<div class="sidebar">
		<h2 style="color: var(--primary)">Admin Console</h2>
		<a href="adminDashboard.jsp"
			style="color: #9CA3AF; text-decoration: none; display: block; padding: 10px;">←
			Back to Dashboard</a>
	</div>

	<div class="content">
		<h1>Payroll & Work Hours</h1>

		<div class="card">
			<div class="controls-row">
				<h3>Employee Disbursement List</h3>
				<input type="text" id="employeeSearch" class="search-box"
					placeholder="Search employee name..." onkeyup="filterEmployees()">
			</div>

			<table id="salaryTable">
				<thead>
					<tr>
						<th>Employee Name</th>
						<th>Working Hours</th>
						<th>Base Rate (Rs)</th>
						<th>Month</th>
						<th>Net Salary</th>
						<th>Status</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<%
                        try {
                            Connection con = DBUtility.getInstance().getDBConnection();
                            // Left join to show all employees even if they haven't been paid yet
                            String query = "SELECT u.user_id, u.full_name, s.base_salary, s.status, s.month_year, s.net_salary " +
                                           "FROM users u LEFT JOIN salary s ON u.user_id = s.user_id " +
                                           "WHERE u.role='EMPLOYEE' " +
                                           "ORDER BY u.full_name ASC";
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(query);
                            while(rs.next()){
                                String status = rs.getString("status") == null ? "PENDING" : rs.getString("status");
                                double netSalary = rs.getDouble("net_salary");
                    %>
					<tr class="employee-row">
						<td class="emp-name"><strong><%= rs.getString("full_name") %></strong></td>
						<td><input type="number" class="hours-input"
							placeholder="Hrs" min="0" id="hours_<%= rs.getInt("user_id") %>">
						</td>
						<td><%= rs.getDouble("base_salary") > 0 ? rs.getDouble("base_salary") : "0.00" %></td>
						<td><%= rs.getString("month_year") != null ? rs.getString("month_year") : "---" %></td>
						<td><strong><%= netSalary %></strong></td>
						<td><span
							class="<%= status.equals("PAID") ? "status-paid" : "status-pending" %>">
								<%= status %>
						</span></td>
						<td>
							<button onclick="processPay(<%= rs.getInt("user_id") %>)"
								class="btn-pay">Calculate Pay</button>
						</td>
					</tr>
					<% 
                            }
                        } catch(Exception e) { e.printStackTrace(); } 
                    %>
				</tbody>
			</table>
		</div>
	</div>

	<script>
        // Real-time Search Function
        function filterEmployees() {
            let input = document.getElementById('employeeSearch').value.toLowerCase();
            let rows = document.getElementsByClassName('employee-row');
            
            for (let row of rows) {
                let name = row.querySelector('.emp-name').textContent.toLowerCase();
                row.style.display = name.includes(input) ? "" : "none";
            }
        }

        // Redirect to process page with the hours entered
        function processPay(userId) {
            let hours = document.getElementById('hours_' + userId).value;
            if(!hours || hours <= 0) {
                alert("Please enter working hours first!");
                return;
            }
            // Passing ID and Hours to the processing page
            window.location.href = "processSalary.jsp?id=" + userId + "&hours=" + hours;
        }
    </script>
</body>
</html>