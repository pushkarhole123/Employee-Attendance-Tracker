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

@WebServlet("/AddTaskServlet")
public class AddTaskServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String projectIdStr = request.getParameter("projectId");
		String userIdStr = request.getParameter("userId");
		String title = request.getParameter("taskTitle");
		String dueDateStr = request.getParameter("dueDate");

		System.out.println("Assigning Task: " + title + " to User ID: " + userIdStr);

		try {
			int projectId = Integer.parseInt(projectIdStr);
			int userId = Integer.parseInt(userIdStr);

			Connection con = DBUtility.getInstance().getDBConnection();

			String sql = "INSERT INTO tasks (project_id, user_id, title, due_date, status) VALUES (?, ?, ?, ?, 'PENDING')";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, projectId);
			ps.setInt(2, userId);
			ps.setString(3, title);
			ps.setDate(4, java.sql.Date.valueOf(dueDateStr)); // Converts YYYY-MM-DD string to SQL Date

			int rows = ps.executeUpdate();

			if (rows > 0) {
				response.sendRedirect("manageTask.jsp?msg=Task Assigned Successfully");
			} else {
				response.sendRedirect("manageTask.jsp?error=Could not insert task");
			}

			ps.close();
		} catch (NumberFormatException e) {
			System.err.println("ID Parsing Error: " + e.getMessage());
			response.sendRedirect("manageTask.jsp?error=Invalid Project or User ID");
		} catch (SQLException e) {
			e.printStackTrace(); // This will show the exact SQL error in your IDE console
			response.sendRedirect("manageTask.jsp?error=Database Error: " + e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("manageTask.jsp?error=Unexpected Error");
		}
	}
}