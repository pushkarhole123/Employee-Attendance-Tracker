package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.utility.DBUtility;

@WebServlet("/AddUserServlet")
public class AddUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String fullName = request.getParameter("full_name");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String role = request.getParameter("role");

		// Clean data
		if (role != null)
			role = role.trim().toUpperCase();

		// Using try-with-resources for automatic closing of database connections
		try (Connection con = DBUtility.getInstance().getDBConnection()) {

			// 1. Check for duplicate username
			String checkSql = "SELECT user_id FROM users WHERE username = ?";
			try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {
				psCheck.setString(1, username);
				try (ResultSet rs = psCheck.executeQuery()) {
					if (rs.next()) {
						response.sendRedirect("addUser.jsp?error=duplicate");
						return;
					}
				}
			}

			// 2. Insert new user
			String insertSql = "INSERT INTO users (full_name, username, password, role) VALUES (?, ?, ?, ?)";
			try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
				psInsert.setString(1, fullName);
				psInsert.setString(2, username);
				psInsert.setString(3, password);
				psInsert.setString(4, role);

				int rows = psInsert.executeUpdate();
				if (rows > 0) {
					response.sendRedirect("addUser.jsp?status=success");
				} else {
					response.sendRedirect("addUser.jsp?error=database");
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("addUser.jsp?error=database");
		}
	}
}