package com.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dao.AttendanceDao;
import com.model.Attendance;

@WebServlet("/UserDashboardServlet")
public class UserDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Added doGet so the dashboard can be accessed via a simple link refresh
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");

        AttendanceDao attendanceDAO = new AttendanceDao();
        
        // Fetch specific attendance logs for this user to fill their personal chart
        List<Attendance> myAttendance = attendanceDAO.getAttendanceByUserId(userId);

        request.setAttribute("userAttendance", myAttendance);
        request.getRequestDispatcher("userDashboard.jsp").forward(request, response);
    }
}