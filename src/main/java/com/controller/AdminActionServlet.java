package com.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.ProjectDao;
import com.model.Project;

@WebServlet("/AdminActionServlet")
public class AdminActionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public AdminActionServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		if ("addProject".equals(action)) {
			String name = request.getParameter("projectName");
			String desc = request.getParameter("description");

			Project newProject = new Project();
			newProject.setProjetName(name);
			newProject.setDescription(desc);

			ProjectDao dao = new ProjectDao();
			boolean success = dao.addProject(newProject);

			if (success) {
				response.sendRedirect("adminDashboard.jsp?status=success");

			} else {
				response.sendRedirect("adminDashboard.jsp?status=error");
			}

		}
	}

}
