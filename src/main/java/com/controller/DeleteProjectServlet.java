package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.utility.DBUtility;

@WebServlet("/DeleteProjectServlet")
public class DeleteProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("manageProjects.jsp?error=Invalid project ID");
            return;
        }

        int projectId;
        try {
            projectId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("manageProjects.jsp?error=Invalid project ID");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBUtility.getInstance().getDBConnection();
            String sql = "DELETE FROM projects WHERE project_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
            
            int rows = ps.executeUpdate();
            
            String message = rows > 0 ? "msg=Project deleted successfully" : "error=Project not found";
            response.sendRedirect("manageProject.jsp?" + message);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manageProject.jsp?error=Database error");
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
