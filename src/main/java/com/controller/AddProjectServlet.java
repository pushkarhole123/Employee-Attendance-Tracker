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

@WebServlet("/AddProjectServlet")
public class AddProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Match your actual table columns [file:26]
        String projectName = request.getParameter("projectName");
        String description = request.getParameter("description");
        
        // Validate input
        if (projectName == null || projectName.trim().isEmpty()) {
            response.sendRedirect("manageProjects.jsp?error=Project name is required");
            return;
        }

        try (Connection con = DBUtility.getInstance().getDBConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO projects (project_name, description, status) VALUES (?, ?, 'Active')")) {
            
            ps.setString(1, projectName);      // Fixed: index 1 for project_name
            ps.setString(2, description != null ? description : "");  // Fixed: index 2 for description
            ps.executeUpdate();
            
            response.sendRedirect("manageProject.jsp?msg=Project created successfully");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageProject.jsp?error=Database error: " + e.getMessage());
        }
    }
}
