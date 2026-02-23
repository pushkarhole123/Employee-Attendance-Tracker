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

/**
 * Servlet implementation class DeleteUserServlet
 */
@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DeleteUserServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String userId = request.getParameter("userId");

		// If ID is missing from post, try to get it from query string (from dashboard
		// link)
		if (userId == null) {
			userId = request.getParameter("id");
		}

		if (userId != null) {
			try {
				Connection con = DBUtility.getInstance().getDBConnection();

				/*
				 * IMPORTANT: If you have a 'tasks' table linked to this user, you should delete
				 * their tasks first or use ON DELETE CASCADE in SQL.
				 */
				String sql = "DELETE FROM users WHERE user_id = ?";
				PreparedStatement ps = con.prepareStatement(sql);
				ps.setString(1, userId);

				int result = ps.executeUpdate();
				if (result > 0) {
					response.sendRedirect("viewUsers.jsp?msg=User Deleted Successfully");
				} else {
					response.sendRedirect("viewUsers.jsp?error=Delete Failed");
				}
			} catch (Exception e) {
				e.printStackTrace();
				response.sendRedirect("viewUsers.jsp?error=Database Conflict (Check foreign keys)");
			}
		} else {
			response.sendRedirect("viewUsers.jsp");
		}
	}

}
