<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Employee Portal | Login</title>

<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap"
	rel="stylesheet">

<style>
/* --- 1. Global Reset & Background --- */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: 'Poppins', sans-serif;
}

body {
	height: 100vh;
	display: flex;
	justify-content: center;
	align-items: center;
	/* Modern Gradient Background */
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	background-size: cover;
	overflow: hidden; /* Prevent scrollbars from popups */
}

/* --- 2. The Login Card (Glassmorphism) --- */
.login-container {
	background: rgba(255, 255, 255, 0.95);
	padding: 40px 50px;
	border-radius: 15px;
	box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
	width: 100%;
	max-width: 400px;
	text-align: center;
	transition: transform 0.3s ease;
	position: relative;
	z-index: 10;
}

.login-container:hover {
	transform: translateY(-5px);
}

/* --- 3. Header & Text --- */
.login-container h2 {
	color: #333;
	margin-bottom: 10px;
	font-weight: 600;
}

.login-container p {
	color: #666;
	font-size: 14px;
	margin-bottom: 30px;
}

/* --- 4. Input Fields --- */
.input-group {
	margin-bottom: 20px;
	text-align: left;
}

.input-group label {
	display: block;
	margin-bottom: 5px;
	color: #555;
	font-size: 13px;
	font-weight: 500;
}

.input-group input {
	width: 100%;
	padding: 12px 15px;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-size: 14px;
	outline: none;
	transition: all 0.3s ease;
	background: #f9f9f9;
}

/* Input Focus Effect */
.input-group input:focus {
	border-color: #764ba2;
	box-shadow: 0 0 8px rgba(118, 75, 162, 0.2);
	background: #fff;
}

/* --- 5. The Button --- */
.login-btn {
	width: 100%;
	padding: 14px;
	background: linear-gradient(to right, #667eea, #764ba2);
	color: white;
	border: none;
	border-radius: 8px;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
	transition: background 0.3s ease;
	margin-top: 10px;
}

.login-btn:hover {
	background: linear-gradient(to right, #5a6fd6, #683f91);
	box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

/* --- 6. Popup Overlay & Modal --- */
.popup-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.6);
	backdrop-filter: blur(5px);
	display: none;
	justify-content: center;
	align-items: center;
	z-index: 1000;
	animation: fadeIn 0.3s ease-out;
}

.popup-overlay.active {
	display: flex;
}

@
keyframes fadeIn {from { opacity:0;
	
}

to {
	opacity: 1;
}

}
.popup-modal {
	background: rgba(255, 255, 255, 0.98);
	padding: 30px 40px;
	border-radius: 20px;
	box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
	max-width: 450px;
	width: 90%;
	text-align: center;
	transform: scale(0.8);
	animation: popupSlideIn 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55)
		forwards;
	position: relative;
}

@
keyframes popupSlideIn {to { transform:scale(1);
	
}

}
.popup-modal h3 {
	color: #333;
	margin-bottom: 15px;
	font-weight: 600;
	font-size: 22px;
}

.popup-content {
	color: #555;
	line-height: 1.6;
	margin-bottom: 25px;
	font-size: 15px;
}

/* Success Popup */
.success-popup .popup-content {
	color: #155724;
}

.success-popup {
	border: 2px solid #28a745;
}

.success-popup .popup-icon {
	color: #28a745;
	font-size: 48px;
	margin-bottom: 15px;
	animation: bounce 0.6s ease-out;
}

@
keyframes bounce { 0%, 20%, 50%, 80%, 100% {
	transform: translateY(0);
}

40
%
{
transform
:
translateY(
-10px
);
}
60
%
{
transform
:
translateY(
-5px
);
}
}

/* Error Popup */
.error-popup .popup-content {
	color: #721c24;
}

.error-popup {
	border: 2px solid #dc3545;
}

.error-popup .popup-icon {
	color: #dc3545;
	font-size: 48px;
	margin-bottom: 15px;
	animation: shake 0.5s ease-in-out;
}

@
keyframes shake { 0%, 100% {
	transform: translateX(0);
}

10
%
,
30
%
,
50
%
,
70
%
,
90
%
{
transform
:
translateX(
-5px
);
}
20
%
,
40
%
,
60
%
,
80
%
{
transform
:
translateX(
5px
);
}
}
.not-registered-popup .popup-content {
	color: #856404;
}

.not-registered-popup {
	border: 2px solid #ffc107;
}

.not-registered-popup .popup-icon {
	color: #ffc107;
	font-size: 48px;
	margin-bottom: 15px;
}

/* Buttons in Popup */
.popup-btn {
	padding: 12px 30px;
	border: none;
	border-radius: 10px;
	font-size: 15px;
	font-weight: 600;
	cursor: pointer;
	margin: 0 10px;
	transition: all 0.3s ease;
	text-decoration: none;
	display: inline-block;
}

.btn-primary {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	color: white;
}

.btn-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
}

.btn-secondary {
	background: #f8f9fa;
	color: #495057;
	border: 2px solid #dee2e6;
}

.btn-secondary:hover {
	background: #e9ecef;
	transform: translateY(-2px);
}

/* Footer Links */
.footer-link {
	margin-top: 20px;
	font-size: 12px;
	color: #888;
}

.footer-link a {
	color: #764ba2;
	text-decoration: none;
}

.footer-link a:hover {
	text-decoration: underline;
}
</style>
</head>
<body>

	<!-- Login Form -->
	<div class="login-container">
		<h2>Welcome Back</h2>
		<p>Please enter your details to sign in.</p>

		<form action="LoginPageServlet" method="post" id="loginForm">
			<div class="input-group">
				<label for="username">Username</label> <input type="text"
					id="username" name="username" placeholder="Enter your username"
					required>
			</div>

			<div class="input-group">
				<label for="password">Password</label> <input type="password"
					id="password" name="password" placeholder="••••••••" required>
			</div>

			<button type="submit" class="login-btn">Sign In</button>

			<div style="margin-top: 15px; text-align: center; font-size: 14px;">
				New employee <a href="register.jsp"
					style="color: #4F46E5; text-decoration: none;">Create an
					account</a>
			</div>
		</form>

		<div class="footer-link">
			Need help? <a href="contactAdmin.jsp">Contact Admin</a>
		</div>
	</div>

	<!-- Success Popup -->
	<div id="successPopup" class="popup-overlay success-popup">
		<div class="popup-modal">
			<div class="popup-icon">✅</div>
			<h3>Login Successful!</h3>
			<div class="popup-content">Welcome back to the Employee Portal.
				You have been successfully logged in.</div>
			<a href="dashboard.jsp" class="popup-btn btn-primary">Go to
				Dashboard</a>
			<button onclick="closePopup('successPopup')"
				class="popup-btn btn-secondary">Stay Here</button>
		</div>
	</div>

	<!-- Error Popup (Invalid Credentials) -->
	<div id="errorPopup" class="popup-overlay error-popup">
		<div class="popup-modal">
			<div class="popup-icon">⚠️</div>
			<h3>Login Failed!</h3>
			<div class="popup-content">Invalid Username or Password. Please
				check your credentials and try again.</div>
			<button onclick="closePopup('errorPopup')"
				class="popup-btn btn-primary">Try Again</button>
		</div>
	</div>

	<!-- Not Registered Popup -->
	<div id="notRegisteredPopup" class="popup-overlay not-registered-popup">
		<div class="popup-modal">
			<div class="popup-icon">👤</div>
			<h3>Employee Not Found!</h3>
			<div class="popup-content">This username is not registered in
				our system. Please create an account first or contact HR if you
				believe this is an error.</div>
			<a href="register.jsp" class="popup-btn btn-primary">Create
				Account</a>
			<button onclick="closePopup('notRegisteredPopup')"
				class="popup-btn btn-secondary">Try Different Username</button>
		</div>
	</div>

	<script>
<%String status = request.getParameter("status");
String error = request.getParameter("error");%>
    
// Show appropriate popup on page load
window.onload = function() {
    <%if ("success".equals(status)) {%>
        document.getElementById('successPopup').classList.add('active');
    <%} else if ("InvalidCredentials".equals(error)) {%>
        document.getElementById('errorPopup').classList.add('active');
    <%} else if ("NotRegistered".equals(error)) {%>
        document.getElementById('notRegisteredPopup').classList.add('active');
    <%}%>
};

function closePopup(popupId) {
    document.getElementById(popupId).classList.remove('active');
}

 </script>

</body>
</html>
