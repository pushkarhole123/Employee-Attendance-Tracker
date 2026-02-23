package com.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.AttendanceDao;
import com.model.Attendance;

@WebServlet("/ViewAttendanceServlet")
public class ViewAttendanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        AttendanceDao dao = new AttendanceDao();
        
        // Logic: Fetch all attendance summaries for the market-level sheet
        List<Attendance> attendanceList = dao.getAllAttendance();
        
        // Pass the list to the JSP to be rendered in the horizontal grid
        request.setAttribute("attendanceData", attendanceList);
        
        // Forward to the professional view page we created earlier
        request.getRequestDispatcher("viewAttendance.jsp").forward(request, response);
    }
}