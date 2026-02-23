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

@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public UpdateUserServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int userId = Integer.parseInt(request.getParameter("userId"));
		String fullName = request.getParameter("fullName");
		String role = request.getParameter("role");

		try {
			Connection con = DBUtility.getInstance().getDBConnection();
			String sql = "UPDATE users SET full_name = ?, role = ? WHERE user_id = ?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, fullName);
			ps.setString(2, role);
			ps.setInt(3, userId);

			ps.executeUpdate();
			response.sendRedirect("viewUsers.jsp?msg=User Updated");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("viewUsers.jsp?error=Update Failed");
		}
	}
}
