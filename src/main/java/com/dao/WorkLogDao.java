package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.model.WorkLog;
import com.utility.DBUtility;

public class WorkLogDao {

	public boolean insertLog(WorkLog log) {
		String sql = "INSERT INTO work_log(user_id, project_id, task_description, hours_worked, log_date) VALUES (?, ?, ?, ?, CURRENT_DATE)";
		try (Connection con = DBUtility.getInstance().getDBConnection();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, log.getUserId());
			ps.setInt(2, log.getProjectId());
			ps.setString(3, log.getTaskDescription());
			ps.setDouble(4, log.getHoursWorked());

			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			System.out.println(e);
			return false;
		}
	}

	public List<WorkLog> getLogsByUserId(int userId) {
		List<WorkLog> list = new ArrayList<>();
		String sql = "SELECT * FROM WORK_LOG WHERE USER_ID = ? ORDER BY LOG_DATE DESC LIMIT 10";
		try (Connection con = DBUtility.getInstance().getDBConnection();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				WorkLog log = new WorkLog();
				log.setLogId(rs.getInt("log_id"));
				log.setTaskDescription(rs.getString("task_description"));
				log.setHoursWorked(rs.getDouble("hours_worked"));
				log.setLogDate(rs.getDate("log_date"));
				list.add(log);
			}
		} catch (SQLException e) {
			System.out.println(e);
		}
		return list;
	}
	
	public double getTotalHoursLoggedToday() {
	    double totalHours = 0;
	    String sql = "SELECT SUM(hours_worked) FROM work_log WHERE log_date = CURRENT_DATE";
	    try (Connection con = DBUtility.getInstance().getDBConnection();
	         Statement st = con.createStatement();
	         ResultSet rs = st.executeQuery(sql)) {
	        if (rs.next()) {
	            totalHours = rs.getDouble(1);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return totalHours;
	}
}
