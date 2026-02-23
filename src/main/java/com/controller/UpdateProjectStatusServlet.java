package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.utility.DBUtility;

@WebServlet("/UpdateProjectStatusServlet")
public class UpdateProjectStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. Security Check (Only Admins can update project health)
		HttpSession session = request.getSession(false);
		if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
			response.sendRedirect("login.jsp?error=Unauthorized");
			return;
		}

		String projectId = request.getParameter("project_id");
		String newStatus = request.getParameter("status");

		try {
			Connection con = DBUtility.getInstance().getDBConnection();
			// Removed 'updated_at' to match your current database structure
			String sql = "UPDATE projects SET status = ? WHERE project_id = ?";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, newStatus);
			ps.setInt(2, Integer.parseInt(projectId)); // Ensure this is index 2

			ps.executeUpdate();

			// Redirect back to the management page with a success flag
			response.sendRedirect("manageProject.jsp?status=updated");

			ps.close();
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("manageProject.jsp?error=db");
		}

	}
}