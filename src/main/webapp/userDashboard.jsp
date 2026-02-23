<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.LocalDate, com.utility.DBUtility"%>
<%
    if (session == null || session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (Integer) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("name");
    LocalDate today = LocalDate.now();
    
    Connection con = null;
    boolean attendanceMarked = false;
    int completedTasks = 0;
    double totalHours = 0.0;

    try {
        con = DBUtility.getInstance().getDBConnection();
        
        // 1. Check Attendance
        String checkQuery = "SELECT COUNT(*) FROM attendance WHERE user_id=? AND days_present=?";
        PreparedStatement psCheck = con.prepareStatement(checkQuery);
        psCheck.setInt(1, userId);
        psCheck.setString(2, today.toString());
        ResultSet rsCheck = psCheck.executeQuery();
        if(rsCheck.next()) { attendanceMarked = rsCheck.getInt(1) > 0; }
        
        // 2. Fetch Stats for better UI
        PreparedStatement psStat = con.prepareStatement("SELECT COUNT(*) FROM tasks WHERE user_id=? AND status='Completed'");
        psStat.setInt(1, userId);
        ResultSet rsStat = psStat.executeQuery();
        if(rsStat.next()) completedTasks = rsStat.getInt(1);

        PreparedStatement psHrs = con.prepareStatement("SELECT SUM(hours_worked) FROM work_log WHERE user_id=?");
        psHrs.setInt(1, userId);
        ResultSet rsHrs = psHrs.executeQuery();
        if(rsHrs.next()) totalHours = rsHrs.getDouble(1);
        
    } catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ProTrack | Enterprise Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-deep: #0f172a;
            --sidebar-color: #1e293b;
            --accent: #38bdf8;
            --success: #10b981;
            --warning: #fbbf24;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --glass-bg: rgba(30, 41, 59, 0.7);
            --border: rgba(255, 255, 255, 0.08);
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-deep);
            color: var(--text-main);
            margin: 0;
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styling */
        .sidebar {
            width: 280px;
            background: var(--sidebar-color);
            border-right: 1px solid var(--border);
            padding: 2.5rem 1.5rem;
            display: flex;
            flex-direction: column;
            position: fixed;
            height: 100vh;
            box-sizing: border-box;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--accent);
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 3rem;
        }

        .nav-menu { flex-grow: 1; }
        .nav-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 14px 18px;
            color: var(--text-muted);
            text-decoration: none;
            border-radius: 12px;
            transition: all 0.3s;
            margin-bottom: 8px;
        }
        .nav-item:hover, .nav-item.active {
            background: rgba(56, 189, 248, 0.1);
            color: var(--accent);
        }

        /* Main Content Styling */
        .main-content {
            margin-left: 280px;
            padding: 3rem;
            width: calc(100% - 280px);
            box-sizing: border-box;
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 3rem;
        }

        .welcome-msg h1 { font-size: 2.2rem; margin: 0; letter-spacing: -1px; }
        .welcome-msg p { color: var(--text-muted); margin: 5px 0 0; }

        /* Dashboard Grid & Cards */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
        }

        .card {
            background: var(--glass-bg);
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 1.8rem;
            backdrop-filter: blur(12px);
            position: relative;
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 1.5rem;
        }
        .card-header i { color: var(--accent); font-size: 1.2rem; }
        .card-header h3 { font-size: 1.1rem; margin: 0; font-weight: 600; }

        .stat-val { font-size: 2rem; font-weight: 700; display: block; }
        .stat-label { color: var(--text-muted); font-size: 0.85rem; }

        .full-width { grid-column: span 3; }
        .span-2 { grid-column: span 2; }

        /* Task & Table Styles */
        .task-list { max-height: 300px; overflow-y: auto; }
        .task-item {
            background: rgba(15, 23, 42, 0.5);
            padding: 16px;
            border-radius: 16px;
            margin-bottom: 12px;
            border: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .task-info h4 { margin: 0 0 4px; font-size: 0.95rem; }
        .task-info span { font-size: 0.75rem; color: var(--text-muted); }

        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; color: var(--text-muted); font-size: 0.75rem; padding: 15px; text-transform: uppercase; letter-spacing: 1px; }
        td { padding: 18px 15px; border-bottom: 1px solid var(--border); font-size: 0.9rem; }

        .status-badge {
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.7rem;
            font-weight: 700;
            display: inline-block;
        }
        .badge-completed { background: rgba(16, 185, 129, 0.15); color: var(--success); }
        .badge-pending { background: rgba(251, 191, 36, 0.1); color: var(--warning); }

        .locked-overlay {
            position: absolute;
            inset: 0;
            background: rgba(15, 23, 42, 0.96);
            z-index: 20;
            border-radius: 24px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(8px);
        }

        .btn-primary {
            background: var(--accent);
            color: #000;
            padding: 14px 24px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.9rem;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: 0.3s;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(56, 189, 248, 0.2); }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo">
            <i class="fas fa-cube"></i> ProTrack
        </div>
        <nav class="nav-menu">
            <a href="#" class="nav-item active"><i class="fas fa-home"></i> Overview</a>
        </nav>
        <a href="LogoutPageServlet" class="nav-item" style="color: #f87171;">
            <i class="fas fa-power-off"></i> Logout
        </a>
    </aside>

    <main class="main-content">
        <div class="header-section">
            <div class="welcome-msg">
                <h1>Hi, <%= userName %>!</h1>
                <p>Welcome back. Here is what's happening today, <%= today %>.</p>
            </div>
            <% if (!attendanceMarked) { %>
            <form action="AttendanceServlet" method="post">
                <button type="submit" class="btn-primary"><i class="fas fa-play"></i> Attendance </button>
            </form>
            <% } else { %>
                <span style="color: var(--success); font-weight: 600;"><i class="fas fa-circle" style="font-size: 8px;"></i> Session Active</span>
            <% } %>
        </div>

        <div class="dashboard-grid">
            <div class="card">
                <div class="card-header"><i class="fas fa-check-double"></i><h3>Completed</h3></div>
                <span class="stat-val"><%= completedTasks %></span>
                <span class="stat-label">Tasks Finished</span>
            </div>
            <div class="card">
                <div class="card-header"><i class="fas fa-hourglass-half"></i><h3>Logged</h3></div>
                <span class="stat-val"><%= String.format("%.1f", totalHours) %></span>
                <span class="stat-label">Total Hours Contributed</span>
            </div>
            <div class="card">
                <div class="card-header"><i class="fas fa-calendar-check"></i><h3>Date</h3></div>
                <span class="stat-val"><%= today.getDayOfMonth() %></span>
                <span class="stat-label"><%= today.getMonth() %>, <%= today.getYear() %></span>
            </div>

            <div class="card span-2">
                <% if (!attendanceMarked) { %>
                <div class="locked-overlay">
                    <i class="fas fa-lock" style="font-size: 2rem; color: var(--accent); margin-bottom: 1rem;"></i>
                    <p style="font-weight: 600;">Initialize session to view tasks</p>
                </div>
                <% } %>
                <div class="card-header"><i class="fas fa-tasks"></i><h3>Assigned Directives</h3></div>
                <div class="task-list">
                    <%
                        try {
                            String sql = "SELECT t.title, p.project_name FROM tasks t JOIN projects p ON t.project_id = p.project_id " +
                                         "WHERE t.user_id = ? AND (t.status IS NULL OR t.status != 'Completed')";
                            PreparedStatement ps = con.prepareStatement(sql);
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();
                            boolean hasTasks = false;
                            while(rs.next()){
                                hasTasks = true;
                    %>
                    <div class="task-item">
                        <div class="task-info">
                            <h4><%= rs.getString("title") %></h4>
                            <span><i class="far fa-folder"></i> <%= rs.getString("project_name") %></span>
                        </div>
                        <i class="fas fa-circle-notch fa-spin" style="color: var(--accent);"></i>
                    </div>
                    <% } 
                       if(!hasTasks) { out.println("<p style='color:var(--text-muted);'>No active tasks found.</p>"); }
                    } catch(Exception e){} %>
                </div>
                <div style="margin-top: 20px; text-align: right;">
                    <a href="taskWorkLog.jsp" style="color: var(--accent); text-decoration: none; font-size: 0.9rem; font-weight: 600;">Update Progress →</a>
                </div>
            </div>

            <div class="card full-width">
                <% if (!attendanceMarked) { %><div class="locked-overlay"><i class="fas fa-shield-alt"></i><p>Access Restricted</p></div><% } %>
                <div class="card-header"><i class="fas fa-stream"></i><h3>Recent Activity Logs</h3></div>
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Project</th>
                            <th>Achievements</th>
                            <th>Hours</th>
                            <th style="text-align: right;">Final Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                String hist = "SELECT w.log_date, p.project_name, w.task_description, w.hours_worked, t.status " +
                                              "FROM work_log w JOIN projects p ON w.project_id = p.project_id " +
                                              "LEFT JOIN tasks t ON t.project_id = p.project_id AND t.user_id = w.user_id " +
                                              "WHERE w.user_id = ? ORDER BY w.log_id DESC LIMIT 5";
                                PreparedStatement psH = con.prepareStatement(hist);
                                psH.setInt(1, userId);
                                ResultSet rsH = psH.executeQuery();
                                while(rsH.next()){
                        %>
                        <tr>
                            <td style="color: var(--text-muted);"><%= rsH.getString("log_date") %></td>
                            <td style="font-weight: 600;"><%= rsH.getString("project_name") %></td>
                            <td><%= rsH.getString("task_description") %></td>
                            <td><span style="color: var(--accent); font-weight: 700;"><%= rsH.getDouble("hours_worked") %>h</span></td>
                            <td style="text-align: right;">
                                <% if("Completed".equals(rsH.getString("status"))) { %> 
                                    <span class="status-badge badge-completed">COMPLETED</span> 
                                <% } else { %>
                                    <span class="status-badge badge-pending">IN PROGRESS</span> 
                                <% } %>
                            </td>
                        </tr>
                        <% } } catch(Exception e){} %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</body>
</html>