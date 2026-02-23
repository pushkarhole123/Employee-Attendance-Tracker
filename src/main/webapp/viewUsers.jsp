<%@page import="com.utility.DBUtility"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
    // 1. Market-Level Security: Role Validation
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
<title>Manage Users | PMS Console</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
	rel="stylesheet">

<style>
:root {
	--primary: #4F46E5;
	--dark: #0f172a;
	--bg: #f8fafc;
}

body {
	font-family: 'Inter', sans-serif;
	background: var(--bg);
	margin: 0;
	display: flex;
}

/* Sidebar Styling - Consistent with Admin Dashboard */
.sidebar {
	width: 260px;
	background: var(--dark);
	color: white;
	height: 100vh;
	padding: 20px;
	position: fixed;
	box-sizing: border-box;
}

.sidebar h2 {
	font-size: 1.2rem;
	color: #818cf8;
	margin-bottom: 30px;
	display: flex;
	align-items: center;
	gap: 10px;
}

.nav-link {
	color: #94a3b8;
	text-decoration: none;
	display: block;
	padding: 12px;
	border-radius: 8px;
	margin-bottom: 5px;
	transition: 0.3s;
}

.nav-link:hover, .nav-link.active {
	background: #1e293b;
	color: white;
}

.nav-link.active {
	border-left: 4px solid var(--primary);
	color: white;
}

/* Main Content Styling */
.content {
	margin-left: 260px;
	padding: 40px;
	width: calc(100% - 260px);
	box-sizing: border-box;
}

.header-flex {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
}

.search-box {
	width: 100%;
	max-width: 400px;
	padding: 12px 15px;
	border: 1px solid #e2e8f0;
	border-radius: 10px;
	font-size: 0.95rem;
	outline: none;
	transition: 0.2s;
	box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.search-box:focus {
	border-color: var(--primary);
	box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

/* User Card Grid */
.user-card-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
	gap: 24px;
}

.user-card {
	background: white;
	border-radius: 16px;
	padding: 24px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
	border: 1px solid #E5E7EB;
	transition: 0.3s;
}

.user-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.user-header {
	display: flex;
	align-items: center;
	gap: 15px;
	margin-bottom: 15px;
}

.avatar {
	width: 48px;
	height: 48px;
	background: #E0E7FF;
	color: #4338CA;
	border-radius: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 700;
	font-size: 1.2rem;
}

.role-pill {
	font-size: 0.75rem;
	padding: 4px 10px;
	border-radius: 8px;
	font-weight: 600;
	text-transform: uppercase;
	display: inline-block;
	margin-top: 10px;
}

.role-ADMIN {
	background: #FEF3C7;
	color: #92400E;
}

.role-EMPLOYEE {
	background: #DBEAFE;
	color: #1E40AF;
}

.actions {
	display: flex;
	border-top: 1px solid #F3F4F6;
	margin-top: 20px;
	padding-top: 15px;
	gap: 20px;
}

.btn-edit {
	color: var(--primary);
	text-decoration: none;
	font-size: 0.85rem;
	font-weight: 600;
	display: flex;
	align-items: center;
	gap: 5px;
}

.btn-delete {
	color: #EF4444;
	text-decoration: none;
	font-size: 0.85rem;
	font-weight: 600;
	display: flex;
	align-items: center;
	gap: 5px;
}
</style>
</head>
<body>

	<div class="sidebar">
		<h2>
			<i class="fas fa-layer-group"></i> PMS Admin
		</h2>
		<a href="adminDashboard.jsp" class="nav-link"><i
			class="fas fa-home"></i> Dashboard</a>  <a
			href="viewUsers.jsp" class="nav-link active"><i
			class="fas fa-users-cog"></i> Manage Users</a> 
	</div>

	<div class="content">
		<div class="header-flex">
			<div>
				<h1 style="margin: 0;">User Management</h1>
				<p style="color: #6B7280; margin: 5px 0 0;">Manage permissions
					and account status.</p>
			</div>
			<p style="font-weight: 600; color: var(--primary);">
				Total Active Users: <span id="userCount">0</span>
			</p>
		</div>

		<input type="text" class="search-box"
			placeholder="Search by name, role or username..." id="userInput">

		<div class="user-card-grid" id="userContainer">
			<%
                int count = 0;
                try (Connection con = DBUtility.getInstance().getDBConnection();
                     Statement st = con.createStatement();
                     ResultSet rs = st.executeQuery("SELECT * FROM users ORDER BY full_name ASC")) {
                    
                    while(rs.next()) {
                        count++;
                        String role = rs.getString("role");
                        String fullName = rs.getString("full_name");
                        String username = rs.getString("username");
                        int userId = rs.getInt("user_id");
                        
                        // FIX: Defensive Programming for Null Values
                        String initials = "?"; 
                        if (fullName != null && !fullName.trim().isEmpty()) {
                            initials = fullName.substring(0, 1).toUpperCase();
                        } else {
                            fullName = "Unknown User"; 
                        }
            %>
			<div class="user-card"
				data-search="<%= fullName.toLowerCase() %> <%= username.toLowerCase() %> <%= role.toLowerCase() %>">
				<div class="user-header">
					<div class="avatar"><%= initials %></div>
					<div>
						<div style="font-weight: 600; color: #111827;"><%= fullName %></div>
						<div style="font-size: 0.85rem; color: #6B7280;">
							@<%= username %></div>
					</div>
				</div>

				<span class="role-pill role-<%= role.toUpperCase() %>"> <i
					class="fas fa-shield-alt"></i> <%= role %>
				</span>

				<div class="actions">
					<a href="editUser.jsp?id=<%= userId %>" class="btn-edit"> <i
						class="fas fa-user-edit"></i> Edit
					</a> <a href="deleteUser.jsp?id=<%= userId %>" class="btn-delete"
						onclick="return confirm('Are you sure you want to delete this user?')">
						<i class="fas fa-trash-alt"></i> Delete
					</a>
				</div>
			</div>
			<% 
                    }
                } catch(Exception e) { 
                    e.printStackTrace(); 
                } 
            %>
		</div>
	</div>

	<script>
        // Update the visual count
        document.getElementById('userCount').innerText = '<%= count %>';

        // Real-time Market Level Search Functionality
        document.getElementById('userInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const cards = document.querySelectorAll('.user-card');
            
            cards.forEach(card => {
                const searchData = card.getAttribute('data-search');
                if (searchData.includes(searchTerm)) {
                    card.style.display = "block";
                } else {
                    card.style.display = "none";
                }
            });
        });
    </script>
</body>
</html>