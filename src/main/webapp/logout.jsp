<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logged Out</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .logout-card {
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            max-width: 400px;
            width: 100%;
            /* Animation */
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Green Icon Circle */
        .icon-circle {
            width: 80px;
            height: 80px;
            background-color: #D1FAE5; /* Light Green */
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px auto;
        }

        .icon-circle svg {
            width: 40px;
            height: 40px;
            color: #059669; /* Dark Green */
        }

        h2 { color: #111827; margin-bottom: 10px; font-weight: 600; }
        
        p { color: #6B7280; margin-bottom: 30px; line-height: 1.5; font-size: 14px; }

        .btn-login {
            display: block;
            width: 100%;
            text-decoration: none;
            background-color: #4F46E5; /* Indigo */
            color: white;
            padding: 12px 0;
            border-radius: 8px;
            font-weight: 600;
            transition: background-color 0.2s;
            box-sizing: border-box;
        }

        .btn-login:hover {
            background-color: #4338ca;
        }
        
        .timer-text {
            margin-top: 15px;
            font-size: 12px;
            color: #9CA3AF;
        }
    </style>
</head>
<body>

    <div class="logout-card">
        <div class="icon-circle">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
            </svg>
        </div>
        
        <h2>Signed Out</h2>
        <p>You have been securely logged out of your account.<br>We hope to see you again soon!</p>
        
        <a href="login.jsp" class="btn-login">Return to Login</a>
        
        <div class="timer-text">Redirecting automatically in <span id="countdown">5</span> seconds...</div>
    </div>

    <script>
        let seconds = 5;
        const countdownEl = document.getElementById('countdown');
        
        const interval = setInterval(() => {
            seconds--;
            countdownEl.textContent = seconds;
            if (seconds <= 0) {
                clearInterval(interval);
                window.location.href = "login.jsp"; 
            }
        }, 1000);
    </script>
</body>
</html>