package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.utility.DBUtility;


@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String issueType = request.getParameter("issue_type");
        String message = request.getParameter("message");

        try (Connection con = DBUtility.getInstance().getDBConnection()) {
            String sql = "INSERT INTO support_tickets (name, email, issue_type, message) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, issueType);
            ps.setString(4, message);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                // Success: Redirect back with a success flag
                response.sendRedirect("contactAdmin.jsp?status=success");
            } else {
                // Database didn't update for some reason
                response.sendRedirect("contactAdmin.jsp?status=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("contactAdmin.jsp?status=error");
        }
    }
}