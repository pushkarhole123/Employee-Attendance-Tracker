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
import javax.servlet.http.HttpSession;

import com.utility.DBUtility;

@WebServlet("/LoginPageServlet")
public class LoginPageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public LoginPageServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String password = request.getParameter("password");

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean userExists = false;
		boolean passwordValid = false;

		try {
			con = DBUtility.getInstance().getDBConnection();
			
			String checkUserSql = "SELECT user_id FROM users WHERE username = ?";
			ps = con.prepareStatement(checkUserSql);
			ps.setString(1, username);
			rs = ps.executeQuery();
			
			userExists = rs.next(); // true if user found
			
			if (userExists) {
				rs.close();
				ps.close();
				
				String validatePasswordSql = "SELECT user_id, full_name, role FROM users WHERE username = ? AND password = ?";
				ps = con.prepareStatement(validatePasswordSql);
				ps.setString(1, username);
				ps.setString(2, password);
				
				rs = ps.executeQuery();
				passwordValid = rs.next(); // true if password matches
			}
			
			if (userExists && passwordValid) {
				HttpSession session = request.getSession();
				session.setAttribute("user_id", rs.getInt("user_id"));
				session.setAttribute("name", rs.getString("full_name"));
				session.setAttribute("role", rs.getString("role"));
				
				if ("ADMIN".equalsIgnoreCase(rs.getString("role"))) {
					response.sendRedirect("adminDashboard.jsp");
				} else {
					response.sendRedirect("userDashboard.jsp");
				}
				
			} else if (!userExists) {
				response.sendRedirect("login.jsp?error=NotRegistered");
				
			} else {
				response.sendRedirect("login.jsp?error=InvalidCredentials");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("login.jsp?error=InvalidCredentials");
		} finally {
			try {
				if (rs != null) rs.close();
			} catch (Exception e) {}
			try {
				if (ps != null) ps.close();
			} catch (Exception e) {}
			try {
				if (con != null) con.close();
			} catch (Exception e) {}
		}
	}
}
