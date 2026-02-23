<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
if (session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))) {
	response.sendRedirect("login.jsp?error=Unauthorized");
	return;
}
String status = request.getParameter("status");
String error = request.getParameter("error");
boolean showSuccess = "success".equals(status);
boolean showDuplicate = "duplicate".equals(error);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Provision Account | Admin Console</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">

<style>
:root {
	--brand: #4F46E5;
	--brand-soft: #EEF2FF;
	--surface: #FFFFFF;
	--text-main: #111827;
	--text-secondary: #6B7280;
	--border: #E5E7EB;
	--success: #10B981;
	--danger: #EF4444;
}

* {
	box-sizing: border-box;
	font-family: 'Plus Jakarta Sans', sans-serif;
}

body {
	margin: 0;
	display: flex;
	min-height: 100vh;
	background: #F9FAFB;
}

/* Split Screen Layout */
.hero-side {
	flex: 1.2;
	background: linear-gradient(135deg, #4F46E5 0%, #312E81 100%);
	display: flex;
	flex-direction: column;
	justify-content: center;
	padding: 80px;
	color: white;
}

.form-side {
	flex: 1;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 40px;
	background: var(--surface);
}

.form-container {
	width: 100%;
	max-width: 420px;
	animation: fadeIn 0.6s ease-out;
}

@
keyframes fadeIn {from { opacity:0;
	transform: translateX(20px);
}

to {
	opacity: 1;
	transform: translateX(0);
}

}

/* Typography */
.hero-side h1 {
	font-size: 3rem;
	font-weight: 800;
	margin-bottom: 20px;
	letter-spacing: -0.02em;
}

.hero-side p {
	font-size: 1.1rem;
	opacity: 0.9;
	line-height: 1.6;
}

.form-header h2 {
	font-size: 1.8rem;
	font-weight: 700;
	color: var(--text-main);
	margin: 0;
}

.form-header p {
	color: var(--text-secondary);
	margin: 8px 0 32px 0;
	font-size: 0.95rem;
}

/* Form Styling */
.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	font-size: 0.85rem;
	font-weight: 600;
	color: var(--text-main);
	margin-bottom: 8px;
}

.input-wrapper {
	position: relative;
}

.input-wrapper i {
	position: absolute;
	left: 16px;
	top: 50%;
	transform: translateY(-50%);
	color: var(--text-secondary);
	transition: 0.3s;
}

input, select {
	width: 100%;
	padding: 14px 16px 14px 48px;
	border: 1px solid var(--border);
	border-radius: 12px;
	font-size: 0.95rem;
	transition: 0.3s;
	background: #FBFBFB;
}

input:focus {
	outline: none;
	border-color: var(--brand);
	background: white;
	box-shadow: 0 0 0 4px var(--brand-soft);
}

input:focus+i {
	color: var(--brand);
}

/* Strength Checklist */
.checklist {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 8px;
	margin-top: 12px;
	padding: 0;
	list-style: none;
}

.checklist li {
	font-size: 0.75rem;
	color: var(--text-secondary);
	display: flex;
	align-items: center;
	gap: 6px;
}

.checklist li.valid {
	color: var(--success);
	font-weight: 600;
}

/* Alerts */
.alert {
	padding: 12px 16px;
	border-radius: 10px;
	margin-bottom: 24px;
	font-size: 0.9rem;
	display: flex;
	align-items: center;
	gap: 10px;
}

.alert-success {
	background: #ECFDF5;
	color: #065F46;
	border: 1px solid #A7F3D0;
}

.alert-error {
	background: #FEF2F2;
	color: #991B1B;
	border: 1px solid #FECACA;
}

/* Button */
.btn-primary {
	width: 100%;
	padding: 16px;
	background: var(--brand);
	color: white;
	border: none;
	border-radius: 12px;
	font-weight: 700;
	font-size: 1rem;
	cursor: pointer;
	transition: 0.3s;
	margin-top: 10px;
}

.btn-primary:hover {
	background: #4338CA;
	transform: translateY(-2px);
	box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3);
}

.back-btn {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	margin-top: 24px;
	color: var(--text-secondary);
	text-decoration: none;
	font-size: 0.9rem;
	font-weight: 500;
}

.back-btn:hover {
	color: var(--brand);
}

@media ( max-width : 900px) {
	.hero-side {
		display: none;
	}
}
</style>
</head>
<body>

	<section class="hero-side">
		<div style="max-width: 500px;">
			<i class="fas fa-shield-halved"
				style="font-size: 3rem; margin-bottom: 30px;"></i>
			<h1>Scale your team with security.</h1>
			<p>Every new profile is provisioned with enterprise-grade
				encryption. Ensure the right roles are assigned to maintain
				workspace integrity.</p>
		</div>
	</section>

	<section class="form-side">
		<div class="form-container">
			<div class="form-header">
				<h2>Create Account</h2>
				<p>Enter details to provision a new staff profile.</p>
			</div>

			<%
			if (showSuccess) {
			%>
			<div class="alert alert-success">
				<i class="fas fa-check-circle"></i> Profile created successfully!
			</div>
			<%
			}
			%>
			<%
			if (showDuplicate) {
			%>
			<div class="alert alert-error">
				<i class="fas fa-warning"></i> This username is already taken.
			</div>
			<%
			}
			%>

			<form action="AddUserServlet" method="post" id="employeeForm"
				onsubmit="return validateForm()">

				<div class="form-group">
					<label>Full Name</label>
					<div class="input-wrapper">
						<i class="fas fa-signature"></i> <input type="text"
							name="full_name" placeholder="Full legal name" required>
					</div>
				</div>

				<div class="form-group">
					<label>Workspace Username</label>
					<div class="input-wrapper">
						<i class="fas fa-at"></i> <input type="text" name="username"
							id="username" placeholder="e.g. john_doe" required>
					</div>
				</div>

				<div class="form-group">
					<label>Security Password</label>
					<div class="input-wrapper">
						<i class="fas fa-key"></i> <input type="password" name="password"
							id="password" placeholder="••••••••" required
							onkeyup="checkStrength()">
					</div>
					<ul class="checklist" id="reqList">
						<li id="len"><i class="fas fa-circle-dot"></i> 8+ Characters</li>
						<li id="upper"><i class="fas fa-circle-dot"></i> Uppercase</li>
						<li id="num"><i class="fas fa-circle-dot"></i> Number</li>
						<li id="spec"><i class="fas fa-circle-dot"></i> Special Char</li>
					</ul>
				</div>

				<div class="form-group">
					<label>Access Level & Permissions</label>
					<div class="input-wrapper">
						<i class="fas fa-user-gear"></i> 
							<option value="EMPLOYEE" name="Employee" readonly> Employee (Restricted)</option>
						
						<div class="select-arrow">
							<i class="fas fa-chevron-down"></i>
						</div>
					</div>
				</div>

				<button type="submit" class="btn-primary" id="submitBtn">
					Confirm & Provision Profile</button>

				<a href="adminDashboard.jsp" class="back-btn"> <i
					class="fas fa-arrow-left"></i> Exit to Control Center
				</a>
			</form>
		</div>
	</section>

	<script>
        function checkStrength() {
            const p = document.getElementById('password').value;
            const checks = {
                len: p.length >= 8,
                upper: /[A-Z]/.test(p),
                num: /[0-9]/.test(p),
                spec: /[!@#$%^&*]/.test(p)
            };

            for (const [id, valid] of Object.entries(checks)) {
                const el = document.getElementById(id);
                if (valid) {
                    el.classList.add('valid');
                    el.querySelector('i').className = "fas fa-check-circle";
                } else {
                    el.classList.remove('valid');
                    el.querySelector('i').className = "fas fa-circle-dot";
                }
            }
        }

        function validateForm() {
            const btn = document.getElementById('submitBtn');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Initializing Account...';
            btn.style.opacity = '0.7';
            return true;
        }
    </script>
</body>
</html>