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

@WebServlet("/SalaryServlet")
public class SalaryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public SalaryServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String userId = request.getParameter("userId");
		String monthYear = request.getParameter("monthYear");
		String hoursStr = request.getParameter("hours"); // From the readonly input
		String rateStr = request.getParameter("baseSalary"); // From the hourly rate input
		String bonusStr = request.getParameter("bonus"); // From the bonus input

		try {
			// 2. Null & Empty Check (The "Safety Net")
			if (hoursStr == null || rateStr == null || bonusStr == null || hoursStr.isEmpty() || rateStr.isEmpty()) {
				response.sendRedirect("manageSalary.jsp?error=Missing Data");
				return;
			}

			// 3. Parsing numbers safely
			double hours = Double.parseDouble(hoursStr);
			double rate = Double.parseDouble(rateStr);
			double bonus = bonusStr.isEmpty() ? 0 : Double.parseDouble(bonusStr);

			// 4. Calculate Net Salary
			double netSalary = (hours * rate) + bonus;

			// 5. Database Logic
			Connection con = DBUtility.getInstance().getDBConnection();
			String sql = "INSERT INTO salary (user_id, base_salary, bonus, net_salary, month_year, status, payment_date) "
					+ "VALUES (?, ?, ?, ?, ?, 'PAID', CURDATE())";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, userId);
			ps.setDouble(2, rate);
			ps.setDouble(3, bonus);
			ps.setDouble(4, netSalary);
			ps.setString(5, monthYear);

			ps.executeUpdate();

			// Success Redirect
			response.sendRedirect("manageSalary.jsp?msg=Salary Disbursed Successfully");

		} catch (NumberFormatException e) {
			e.printStackTrace();
			response.sendRedirect("manageSalary.jsp?error=Invalid Number Format");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("manageSalary.jsp?error=Database Error");
		}

	}

}
