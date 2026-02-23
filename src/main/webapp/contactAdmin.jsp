<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Contact Administrator</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap"
	rel="stylesheet">

<style>
:root {
	--primary: #4F46E5;
	--primary-dark: #4338ca;
	--text-dark: #1F2937;
	--text-gray: #6B7280;
	--bg-gradient: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
}

body {
	font-family: 'Inter', sans-serif;
	background: var(--bg-gradient);
	margin: 0;
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 20px;
}

.contact-card {
	background: white;
	border-radius: 16px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
	overflow: hidden;
	display: flex;
	width: 100%;
	max-width: 900px;
	flex-wrap: wrap; /* Makes it responsive */
}

/* --- Left Side: Info --- */
.info-panel {
	background: var(--primary);
	color: white;
	flex: 1;
	min-width: 300px;
	padding: 40px;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}

.info-panel h3 {
	font-size: 24px;
	margin-bottom: 10px;
}

.info-panel p {
	opacity: 0.9;
	line-height: 1.6;
}

.contact-details div {
	margin-bottom: 20px;
	display: flex;
	align-items: center;
	gap: 10px;
}

.back-link {
	color: white;
	text-decoration: none;
	font-size: 14px;
	opacity: 0.8;
	transition: opacity 0.3s;
	display: inline-flex;
	align-items: center;
	gap: 5px;
}

.back-link:hover {
	opacity: 1;
}

/* --- Right Side: Form --- */
.form-panel {
	flex: 1.5;
	min-width: 350px;
	padding: 40px;
}

.form-group {
	margin-bottom: 20px;
}

.form-label {
	display: block;
	margin-bottom: 8px;
	color: var(--text-dark);
	font-weight: 500;
	font-size: 14px;
}

.form-input, .form-select, .form-textarea {
	width: 100%;
	padding: 12px;
	border: 1px solid #E5E7EB;
	border-radius: 8px;
	font-family: inherit;
	font-size: 14px;
	transition: all 0.2s;
	box-sizing: border-box;
}

.form-input:focus, .form-select:focus, .form-textarea:focus {
	outline: none;
	border-color: var(--primary);
	box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

.form-textarea {
	resize: vertical;
	min-height: 120px;
}

.btn-submit {
	background-color: var(--primary);
	color: white;
	border: none;
	padding: 12px 24px;
	border-radius: 8px;
	font-weight: 600;
	cursor: pointer;
	width: 100%;
	transition: background 0.2s;
}

.btn-submit:hover {
	background-color: var(--primary-dark);
}

/* Responsive Fix for Mobile */
@media ( max-width : 768px) {
	.contact-card {
		flex-direction: column;
	}
	.info-panel {
		padding: 30px;
	}
	.form-panel {
		padding: 30px;
	}
}
</style>
</head>
<body>

	<div class="contact-card">
		<div class="info-panel">
			<div>
				<h3>Need Help?</h3>
				<p>Having trouble logging in or facing a technical issue? Fill
					out the form and the IT Admin will reach out to you.</p>

				<div class="contact-details" style="margin-top: 30px;">
					<div>
						<span>📧</span> support@company.com
					</div>
					<div>
						<span>📞</span> +91 ----- -----
					</div>
					<div>
						<span>📍</span> ----------
					</div>
				</div>
			</div>

			<a href="login.jsp" class="back-link"> &larr; Back to Login </a>
		</div>
		<% 
    String status = request.getParameter("status");
    if ("success".equals(status)) {
%>
		<div
			style="background: #D1FAE5; color: #065F46; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #6EE7B7;">
			✅ Message sent successfully! The admin will contact you soon.</div>
		<% 
    } else if ("error".equals(status)) {
%>
		<div
			style="background: #FEE2E2; color: #991B1B; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #F87171;">
			⚠ Something went wrong. Please try again later.</div>
		<% } %>

		<div class="form-panel">
			<form action="ContactServlet" method="post">
				<div class="form-group">
					<label class="form-label">Your Name</label> <input type="text"
						name="name" class="form-input" placeholder="John Doe" required>
				</div>

				<div class="form-group">
					<label class="form-label">Email Address</label> <input type="email"
						name="email" class="form-input" placeholder="@company.com"
						required>
				</div>

				<div class="form-group">
					<label class="form-label">Issue Type</label> <select
						name="issue_type" class="form-select">
						<option value="login">Login / Password Issue</option>
						<option value="access">Project Access Request</option>
						<option value="bug">Report a Bug</option>
						<option value="other">Other</option>
					</select>
				</div>

				<div class="form-group">
					<label class="form-label">Message</label>
					<textarea name="message" class="form-textarea"
						placeholder="Describe your issue..." required></textarea>
				</div>

				<button type="submit" class="btn-submit">Send Message</button>
			</form>
		</div>
	</div>

</body>
</html>