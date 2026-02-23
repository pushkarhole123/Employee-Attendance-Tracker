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

import com.utility.*;

@WebServlet("/TaskLogServlet")
public class TaskLogServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user_id") == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		int userId = (Integer) session.getAttribute("user_id");
		String projectIdStr = request.getParameter("project_id");
		String taskDesc = request.getParameter("task_desc");
		String hoursStr = request.getParameter("hours");
		String isCompleted = request.getParameter("is_completed"); // From the new checkbox

		if (projectIdStr == null || taskDesc == null || hoursStr == null) {
			response.sendRedirect("userDashboard.jsp?status=error");
			return;
		}

		Connection con = null;
		PreparedStatement psLog = null;
		PreparedStatement psUpdateTask = null;

		try {
			int projectId = Integer.parseInt(projectIdStr);
			double hours = Double.parseDouble(hoursStr);

			con = DBUtility.getInstance().getDBConnection();

			con.setAutoCommit(false);

			String logSql = "INSERT INTO work_log (user_id, project_id, task_description, hours_worked, log_date) VALUES (?, ?, ?, ?, CURRENT_DATE)";
			psLog = con.prepareStatement(logSql);
			psLog.setInt(1, userId);
			psLog.setInt(2, projectId);
			psLog.setString(3, taskDesc);
			psLog.setDouble(4, hours);
			int logResult = psLog.executeUpdate();

			if ("true".equals(isCompleted)) {
				String updateQuery = "UPDATE tasks SET status = 'Completed' WHERE project_id = ? AND user_id = ?";
				psUpdateTask = con.prepareStatement(updateQuery);
				psUpdateTask.setInt(1, projectId);
				psUpdateTask.setInt(2, userId);
				psUpdateTask.executeUpdate();
			}

			con.commit();

			if (logResult > 0) {
				response.sendRedirect("taskWorkLog.jsp?status=success");
			} else {
				response.sendRedirect("userDashboard.jsp?status=error");
			}

		} catch (Exception e) {
			try {
				if (con != null)
					con.rollback();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			e.printStackTrace();
			response.sendRedirect("userDashboard.jsp?status=error");
		} finally {
			try {
				if (psLog != null)
					psLog.close();
			} catch (Exception e) {
			}
			try {
				if (psUpdateTask != null)
					psUpdateTask.close();
			} catch (Exception e) {
			}
			try {
				if (con != null)
					con.close();
			} catch (Exception e) {
			}
		}
	}
}