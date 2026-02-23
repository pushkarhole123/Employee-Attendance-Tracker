package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.utility.DBUtility;

public class UserDao {

	public int getUserCount() {

		int count = 0;
		String sql = "SELECT COUNT(*) FROM users WHERE role = 'USER'";

		try (Connection con = DBUtility.getInstance().getDBConnection();
				Statement st = con.createStatement();
				ResultSet rs = st.executeQuery(sql)) {
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return count;
	}
}
