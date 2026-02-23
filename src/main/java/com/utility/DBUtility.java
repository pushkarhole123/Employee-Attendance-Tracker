package com.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtility {

	private static DBUtility instance;
	private static final String URL = "jdbc:mysql://localhost:3306/employee_management_system";
	private static final String USER = "root";
	private static final String PASSWORD = "root";

	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			System.out.println(e);
		}
	}

	private DBUtility() {

	}

	public static DBUtility getInstance() {
		if (instance == null) {
			instance = new DBUtility();
		}
		return instance;
	}

	public static Connection getDBConnection() {
		Connection con = null;
		try {
			con = DriverManager.getConnection(URL, USER, PASSWORD);
		} catch (SQLException e) {
			System.out.println(e);
		}
		return con;
	}
}
