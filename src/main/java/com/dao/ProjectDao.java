package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.model.Project;
import com.utility.DBUtility;

public class ProjectDao {

	public List<Project> getAllProjects() {

		List<Project> projects = new ArrayList<>();
		String sql = "SELECT * FROM PROJECTS ORDER BY PROJECT_NAME ASC";

		try (Connection con = DBUtility.getInstance().getDBConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				Project project = new Project(rs.getInt("project_id"), rs.getString("project_name"),
						rs.getString("description"));
				projects.add(project);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return projects;
	}

	public boolean addProject(Project project) {
		String sql = "INSERT INTO PROJECTS(PROJECT_NAME, DESCRIPTION) VALUES (?,?)";
		try (Connection con = DBUtility.getInstance().getDBConnection();
				PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, project.getProjetName());
			ps.setString(2, project.getDescription());

			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			System.out.println(e);
			return false;
		}
	}
}
