<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Employee Registration | PMS</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
	rel="stylesheet">

<style>
:root {
	--primary: #4F46E5;
	--primary-dark: #3730A3;
	--success: #10B981;
	--error: #EF4444;
	--text-main: #1F2937;
	--text-muted: #6B7280;
	--bg: #F3F4F6;
}

body {
	font-family: 'Inter', sans-serif;
	background-color: var(--bg);
	background-image: radial-gradient(circle at 0% 0%, rgba(79, 70, 229, 0.05)
		0%, transparent 50%),
		radial-gradient(circle at 100% 100%, rgba(16, 185, 129, 0.05) 0%,
		transparent 50%);
	margin: 0;
	display: flex;
	align-items: center;
	justify-content: center;
	min-height: 100vh;
}

.reg-card {
	background: white;
	width: 100%;
	max-width: 480px;
	padding: 2.5rem;
	border-radius: 24px;
	box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px
		rgba(0, 0, 0, 0.04);
	position: relative;
	overflow: hidden;
}

.header {
	text-align: center;
	margin-bottom: 2rem;
}

.header .icon-box {
	width: 64px;
	height: 64px;
	background: rgba(79, 70, 229, 0.1);
	color: var(--primary);
	border-radius: 16px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.8rem;
	margin: 0 auto 1rem;
}

.header h2 {
	margin: 0;
	color: var(--text-main);
	font-size: 1.75rem;
}

.header p {
	color: var(--text-muted);
	margin-top: 5px;
	font-size: 0.95rem;
}

.form-group {
	margin-bottom: 1.25rem;
}

.form-group label {
	display: block;
	font-size: 0.85rem;
	font-weight: 600;
	color: #374151;
	margin-bottom: 6px;
}

.input-box {
	position: relative;
}

.input-box i {
	position: absolute;
	left: 14px;
	top: 50%;
	transform: translateY(-50%);
	color: #9CA3AF;
	transition: 0.3s;
}

.input-box input, .input-box select {
	width: 100%;
	padding: 12px 12px 12px 42px;
	border: 2px solid #E5E7EB;
	border-radius: 12px;
	font-size: 0.95rem;
	box-sizing: border-box;
	transition: all 0.3s;
}

.input-box input:focus, .input-box select:focus {
	border-color: var(--primary);
	outline: none;
	box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
}

.input-box input:focus+i {
	color: var(--primary);
}

/* Security Requirements */
.requirements {
	font-size: 0.75rem;
	color: #6B7280;
	margin-top: 8px;
	padding: 0;
	list-style: none;
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 4px;
}

.requirements li {
	display: flex;
	align-items: center;
	gap: 6px;
	transition: 0.3s;
}

.requirements li.valid {
	color: var(--success);
	font-weight: 600;
}

.btn-register {
	width: 100%;
	padding: 14px;
	background: var(--primary);
	color: white;
	border: none;
	border-radius: 12px;
	font-weight: 700;
	font-size: 1rem;
	cursor: pointer;
	margin-top: 1rem;
	transition: 0.3s;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
}

.btn-register:hover {
	background: var(--primary-dark);
	transform: translateY(-1px);
	box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3);
}

/* Success Overlay */
.success-overlay {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: white;
	z-index: 100;
	display: flex;
	align-items: center;
	justify-content: center;
	text-align: center;
	padding: 2rem;
	box-sizing: border-box;
	animation: slideIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

@
keyframes slideIn {from { transform:translateY(100%);
	
}

to {
	transform: translateY(0);
}

}
.success-icon {
	width: 80px;
	height: 80px;
	background: #DCFCE7;
	color: var(--success);
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 2.5rem;
	margin: 0 auto 1.5rem;
}

.btn-login-now {
	display: inline-flex;
	align-items: center;
	gap: 10px;
	padding: 14px 32px;
	background: linear-gradient(135deg, var(--primary) 0%,
		var(--primary-dark) 100%);
	color: white;
	text-decoration: none;
	border-radius: 12px;
	font-weight: 700;
	box-shadow: 0 10px 15px rgba(79, 70, 229, 0.3);
	transition: 0.3s;
}

.btn-login-now:hover {
	transform: translateY(-3px);
	box-shadow: 0 15px 20px rgba(79, 70, 229, 0.4);
}
</style>
</head>
<body>

	<div class="reg-card">
		<%-- Registration Success View --%>
		<% if ("success".equals(request.getParameter("status"))) { %>
		<div class="success-overlay">
			<div>
				<div class="success-icon">
					<i class="fas fa-check-circle"></i>
				</div>
				<h3 style="font-size: 1.8rem; margin-bottom: 0.5rem;">Registration
					Complete!</h3>
				<p style="color: var(--text-muted); margin-bottom: 2rem;">Your
					account is ready. You can now access the employee portal.</p>
				<a href="login.jsp" class="btn-login-now"> Proceed to Login <i
					class="fas fa-arrow-right"></i>
				</a>
			</div>
		</div>
		<% } %>

		<%-- Form Header --%>
		<div class="header">
			<div class="icon-box">
				<i class="fas fa-user-plus"></i>
			</div>
			<h2>Create Account</h2>
			<p>Register as a member of the organization</p>
		</div>

		<%-- Registration Form --%>
		<form action="<%=request.getContextPath()%>/RegisterServlet"
			method="post">
			<div class="form-group">
				<label>Full Name</label>
				<div class="input-box">
					<i class="fas fa-address-card"></i> <input type="text"
						name="full_name" placeholder="John Doe" required>
				</div>
			</div>

			<div class="form-group">
				<label>Username</label>
				<div class="input-box">
					<i class="fas fa-user-tag"></i> <input type="text" name="username"
						id="username" placeholder="johndoe123" required>
				</div>
			</div>

			<div class="form-group">
				<label>Password</label>
				<div class="input-box">
					<i class="fas fa-shield-halved"></i> <input type="password"
						name="password" id="password" placeholder="••••••••" required
						onkeyup="checkStrength()">
				</div>
				<ul class="requirements" id="reqList">
					<li id="len"><i class="fas fa-circle" style="font-size: 6px;"></i>
						8+ Characters</li>
					<li id="upper"><i class="fas fa-circle"
						style="font-size: 6px;"></i> Uppercase</li>
					<li id="num"><i class="fas fa-circle" style="font-size: 6px;"></i>
						Number</li>
					<li id="spec"><i class="fas fa-circle" style="font-size: 6px;"></i>
						Special Char</li>
				</ul>
			</div>

			<div class="form-group">
				<label>Access Role</label>
				<div class="input-box">
					<i class="fas fa-user-shield"></i> <select name="role" required>
						<option value="EMPLOYEE">Employee</option>
						<option value="ADMIN">Administrator</option>
					</select>
				</div>
			</div>

			<button type="submit" class="btn-register">
				Create Professional Profile <i class="fas fa-paper-plane"></i>
			</button>

			<p
				style="text-align: center; margin-top: 1.5rem; font-size: 0.85rem; color: var(--text-muted);">
				Already have an account? <a href="login.jsp"
					style="color: var(--primary); font-weight: 600; text-decoration: none;">Sign
					In</a>
			</p>
		</form>
	</div>

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
                el.querySelector('i').className = "fas fa-circle";
            }
        }
    }

    function validateForm() {
        const u = document.getElementById('username').value;
        const p = document.getElementById('password').value;
        
        const userRegex = /^[a-zA-Z0-9_]{4,}$/;
        const passRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;

        if (!userRegex.test(u)) {
            alert("Username must be 4+ characters (letters, numbers, underscores).");
            return false;
        }
        if (!passRegex.test(p)) {
            alert("Password does not meet the security requirements.");
            return false;
        }
        return true;
    }
</script>

</body>
</html>