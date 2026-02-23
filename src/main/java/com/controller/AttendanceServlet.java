package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dao.AttendanceDao;
import com.model.Attendance;
import com.utility.DBUtility;
import com.utility.DatabaseService;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        LocalDate today = LocalDate.now();
        String monthYear = today.getMonth().toString() + "-" + today.getYear();

        try (Connection con = DBUtility.getInstance().getDBConnection()) {
            // 1. Get summaryId
            int summaryId = -1;
            String checkSql = "SELECT attendance_id FROM attendance WHERE user_id = ? AND month_year = ?";
            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setInt(1, userId);
                ps.setString(2, monthYear);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) summaryId = rs.getInt("attendance_id");
            }

            // 2. Initialize if new month
            if (summaryId == -1) {
                AttendanceDao dao = new AttendanceDao();
                Attendance att = new Attendance();
                att.setUserId(userId);
                att.setMonthYear(monthYear);
                summaryId = dao.createAttendanceSummary(att);
                new DatabaseService().initializeMonthlyLogs(summaryId, monthYear);
            }

            // 3. Mark Today's Attendance in Logs
            String updateSql = "UPDATE attendance_logs SET status = 'P', clock_in_out = '9:00-17:30', work_hours = 8.5 " +
                               "WHERE summary_id = ? AND day_number = ?";
            try (PreparedStatement psUpdate = con.prepareStatement(updateSql)) {
                psUpdate.setInt(1, summaryId); 
                psUpdate.setInt(2, today.getDayOfMonth());
                psUpdate.executeUpdate();
            }

            session.setAttribute("msg", "Attendance Marked Successfully!");
            session.setAttribute("msgType", "success");
            response.sendRedirect("userDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("userDashboard.jsp");
        }
    }
}