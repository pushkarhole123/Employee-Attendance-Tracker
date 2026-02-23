package com.utility;

import java.sql.*;
import java.time.*;

public class DatabaseService {
	public void initializeMonthlyLogs(int summaryId, String monthYear) {
		// Example monthYear: "MAY-2025"
		String[] parts = monthYear.split("-");
		YearMonth ym = YearMonth.of(Integer.parseInt(parts[1]), Month.valueOf(parts[0]));

		// Using your project's DBUtility
		try (Connection con = DBUtility.getInstance().getDBConnection()) {
			String sql = "INSERT INTO attendance_logs (summary_id, day_number, status, clock_in_out, work_hours) VALUES (?, ?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(sql);

			for (int day = 1; day <= ym.lengthOfMonth(); day++) {
				LocalDate date = ym.atDay(day);
				boolean isWeekend = date.getDayOfWeek().getValue() >= 6; // Sat=6, Sun=7

				ps.setInt(1, summaryId);
				ps.setInt(2, day);
				ps.setString(3, isWeekend ? "WO" : "P");
				ps.setString(4, isWeekend ? "WO" : "9:00-17:30");
				ps.setDouble(5, isWeekend ? 0.0 : 8.5);
				ps.addBatch();
			}
			ps.executeBatch();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}