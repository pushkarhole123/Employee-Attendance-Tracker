<%@page import="com.utility.DBUtility"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*, java.time.*, java.time.format.DateTimeFormatter"%>

<%
if (session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}

LocalDate today = LocalDate.now();
int daysInMonth = today.lengthOfMonth();
// Format for DB query and Display
String currentMonthYear = today.getMonth().name() + "-" + today.getYear();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Enterprise Attendance | PMS Core</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    
    <style>
        :root {
            --sidebar-width: 260px;
            --navy: #003366; 
            --royal: #0047AB;
            --accent: #6366F1;
            --absent-bg: #FFDADA;
            --weekend-bg: #E8F4FF;
            --late-bg: #FFF9C4;
        }

        body { font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; display: flex; background: #F8FAFC; transition: all 0.3s ease; }

        /* Fullscreen Dynamics */
        body.fullscreen-mode .sidebar { transform: translateX(-100%); width: 0; padding: 0; overflow: hidden; }
        body.fullscreen-mode .main-content { margin-left: 0; width: 100%; padding: 20px; }
        body.fullscreen-mode #exportBtn { display: flex !important; animation: fadeIn 0.5s ease; }

        .sidebar { width: var(--sidebar-width); background: #0F172A; color: white; height: 100vh; position: fixed; padding: 20px; z-index: 1000; transition: all 0.3s ease; }
        .main-content { margin-left: var(--sidebar-width); width: calc(100% - var(--sidebar-width)); padding: 40px; transition: all 0.3s ease; }

        .header-flex { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .btn-group { display: flex; gap: 12px; }
        
        .action-btn { 
            padding: 12px 24px; border: none; border-radius: 8px; cursor: pointer; 
            font-weight: 600; display: flex; align-items: center; gap: 10px; 
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); transition: all 0.2s;
        }
        .btn-fullscreen { background: var(--accent); color: white; }
        .btn-pdf { background: #10B981; color: white; display: none; }
        .action-btn:hover { transform: translateY(-2px); box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); }

        .table-card { background: white; border-radius: 12px; border: 1px solid #E2E8F0; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .table-wrapper { overflow-x: auto; width: 100%; }

        .att-table { width: 100%; border-collapse: collapse; font-size: 10px; table-layout: fixed; }
        .att-table th { background: var(--navy); color: white; padding: 10px 5px; text-align: center; font-weight: 600; border: 0.5px solid rgba(255,255,255,0.2); }
        .att-table td { border: 1px solid #E2E8F0; padding: 8px 4px; text-align: center; vertical-align: middle; height: 45px; }

        .sticky-col { position: sticky; left: 0; background: #F8FAFC !important; z-index: 10; width: 220px; min-width: 220px; text-align: left !important; padding-left: 15px !important; border-right: 2px solid #CBD5E1 !important; }
        
        /* Requirement Specific Visuals */
        .time-slot { display: block; font-weight: 700; color: #1E293B; margin-bottom: 2px; }
        .hour-slot { display: block; color: #3b82f6; font-size: 9px; font-weight: 500; }
        
        .bg-absent { background: var(--absent-bg) !important; color: #B91C1C !important; }
        .bg-weekend { background: var(--weekend-bg) !important; color: #475569 !important; }
        .bg-late { background: var(--late-bg) !important; }
        .bg-leave { background: #FEF9C3 !important; color: #854D0E !important; }
        
        .emp-name { font-weight: 700; font-size: 13px; color: #1E293B; display: block; }
        .emp-meta { font-size: 10px; color: #64748B; font-weight: 500; }

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div style="font-size: 1.5rem; font-weight: 800; border-bottom: 1px solid #1E293B; padding-bottom: 20px; margin-bottom: 20px;">
            <i class="fas fa-chart-pie"></i> PMS CORE
        </div>
        <nav>
            <a href="adminDashboard.jsp" style="color:#94A3B8; text-decoration:none; display:flex; align-items:center; gap:12px; padding:12px;"><i class="fas fa-home"></i> Dashboard</a>
            <a href="viewAttendance.jsp" style="color:white; text-decoration:none; display:flex; align-items:center; gap:12px; padding:12px; background:#1E293B; border-radius:8px;"><i class="fas fa-calendar-check"></i> Attendance Details</a>
        </nav>
    </aside>

    <div class="main-content">
        <div class="header-flex">
            <div>
                <h1 style="margin:0; color: #1E293B; font-size: 1.8rem;">Market Level Attendance Sheet</h1>
                <p style="color: #64748B; margin: 5px 0 0 0;">Report Period: <%=currentMonthYear%></p>
            </div>
            
            <div class="btn-group">
                <button onclick="toggleFullscreen()" class="action-btn btn-fullscreen" id="fullBtn">
                    <i class="fas fa-expand"></i> Full Screen
                </button>
                <button onclick="exportToPDF()" class="action-btn btn-pdf" id="exportBtn">
                    <i class="fas fa-file-pdf"></i> Export Detailed PDF
                </button>
            </div>
        </div>

        <div class="table-card" id="printable-area">
            <div class="table-wrapper">
                <table class="att-table" style="min-width: 1800px;">
                    <thead>
                        <tr>
                            <th class="sticky-col" style="background: var(--navy) !important;">Employee Details</th>
                            <% for(int i=1; i<=daysInMonth; i++) { %> <th style="width:45px;"><%=i%></th> <% } %>
                            <th style="background:#1E293B; width: 50px;">PRES.</th>
                            <th style="background:#1E293B; width: 50px;">ABS.</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        // UPDATED QUERY: Using the Summary and Logs relationship for specific daily details
                        String sql = "SELECT s.summary_id, s.emp_name, s.designation_dept, s.days_present, s.days_absent, " +
                                     "l.day_number, l.status, l.clock_in_out, l.work_hours " +
                                     "FROM attendance_summary s " +
                                     "LEFT JOIN attendance_logs l ON s.summary_id = l.summary_id " +
                                     "WHERE s.month_year = ? " +
                                     "ORDER BY s.summary_id, l.day_number";
                        
                        try (Connection con = DBUtility.getInstance().getDBConnection();
                             PreparedStatement ps = con.prepareStatement(sql)) {
                            ps.setString(1, currentMonthYear);
                            ResultSet rs = ps.executeQuery();
                            
                            int lastId = -1;
                            boolean rowStarted = false;
                            int dayCounter = 1;

                            while(rs.next()) {
                                int currentId = rs.getInt("summary_id");
                                
                                if(currentId != lastId) {
                                    if(rowStarted) { 
                                        // Fill missing days if any before closing row
                                        for(int j=dayCounter; j<=daysInMonth; j++) { out.print("<td></td>"); }
                                        out.print("</tr>"); 
                                    }
                                    
                                    lastId = currentId;
                                    dayCounter = 1;
                                    rowStarted = true;
                                    %>
                                    <tr>
                                        <td class="sticky-col">
                                            <span class="emp-name"><%=rs.getString("emp_name")%></span>
                                            <span class="emp-meta"><%=rs.getString("designation_dept")%></span>
                                        </td>
                                    <%
                                }

                                // Handle day gaps in data
                                int dbDay = rs.getInt("day_number");
                                while(dayCounter < dbDay) {
                                    out.print("<td></td>");
                                    dayCounter++;
                                }

                                String status = rs.getString("status");
                                String timeVal = rs.getString("clock_in_out");
                                double hrs = rs.getDouble("work_hours");
                                
                                String cssClass = "";
                                if("A".equals(status)) cssClass = "bg-absent";
                                else if("WO".equals(status)) cssClass = "bg-weekend";
                                else if("SL".equals(status) || "PL".equals(status)) cssClass = "bg-leave";
                                %>
                                <td class="<%=cssClass%>">
                                    <span class="time-slot"><%= (status.equals("P")) ? timeVal : status %></span>
                                    <% if(status.equals("P") || status.equals("A")) { %>
                                        <span class="hour-slot"><%=hrs%> hrs</span>
                                    <% } %>
                                </td>
                                <%
                                dayCounter++;
                                
                                // At the end of month days, add totals
                                if(dayCounter > daysInMonth) {
                                    %>
                                    <td style="font-weight:700; color:#059669; background: #ECFDF5;"><%=rs.getInt("days_present")%></td>
                                    <td style="font-weight:700; color:#DC2626; background: #FEF2F2;"><%=rs.getInt("days_absent")%></td>
                                    <%
                                }
                            }
                            if(rowStarted) out.print("</tr>");

                        } catch(Exception e) { 
                            out.print("<tr><td colspan='35' style='padding:20px; color:red;'>Data Error: " + e.getMessage() + "</td></tr>");
                        } 
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        function toggleFullscreen() {
            const body = document.body;
            const fullBtn = document.getElementById('fullBtn');
            body.classList.toggle('fullscreen-mode');
            
            if(body.classList.contains('fullscreen-mode')) {
                fullBtn.innerHTML = '<i class="fas fa-compress"></i> Exit Full Screen';
                if (body.requestFullscreen) body.requestFullscreen();
            } else {
                fullBtn.innerHTML = '<i class="fas fa-expand"></i> Full Screen';
                if (document.exitFullscreen) document.exitFullscreen();
            }
        }

        function exportToPDF() {
            const element = document.getElementById('printable-area');
            const opt = {
                margin:       0.2,
                filename:     'Attendance_Report_<%=currentMonthYear%>.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2, useCORS: true },
                jsPDF:        { unit: 'in', format: 'a3', orientation: 'landscape' }
            };
            html2pdf().set(opt).from(element).save();
        }

        document.addEventListener('fullscreenchange', () => {
            if (!document.fullscreenElement) {
                document.body.classList.remove('fullscreen-mode');
                document.getElementById('fullBtn').innerHTML = '<i class="fas fa-expand"></i> Full Screen';
            }
        });
    </script>
</body>
</html>