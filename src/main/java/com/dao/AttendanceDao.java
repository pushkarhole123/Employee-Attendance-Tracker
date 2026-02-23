package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.model.Attendance;
import com.utility.DBUtility;

public class AttendanceDao {

    public int createAttendanceSummary(Attendance attendance) {
        // Updated to match your 'desc attendance' screenshot
        String sql = "INSERT INTO attendance (user_id, month_year, days_present, leave_count, ot_hours, total_working_hours, late_arrivals) "
                + "VALUES (?, ?, ?, ?, 0.0, 0.0, 0)";

        int generatedId = -1;
        try (Connection con = DBUtility.getInstance().getDBConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, attendance.getUserId());
            ps.setString(2, attendance.getMonthYear());
            ps.setString(3, "0"); 
            ps.setInt(4, 0); 

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return generatedId;
    }

    public List<Attendance> getAllAttendance() {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance ORDER BY attendance_id DESC";

        try (Connection con = DBUtility.getInstance().getDBConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Attendance record = new Attendance();
                record.setAttendanceId(rs.getInt("attendance_id"));
                record.setUserId(rs.getInt("user_id"));
                record.setMonthYear(rs.getString("month_year"));
                record.setDaysPresent(rs.getString("days_present"));
                record.setLeaveCount(rs.getInt("leave_count"));
                // Optional: set the new analytical fields if your model has them
                list.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Attendance> getAttendanceByUserId(int userId) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance WHERE user_id = ? ORDER BY month_year DESC";

        try (Connection con = DBUtility.getInstance().getDBConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Attendance record = new Attendance();
                    record.setAttendanceId(rs.getInt("attendance_id"));
                    record.setUserId(userId);
                    record.setMonthYear(rs.getString("month_year"));
                    record.setDaysPresent(rs.getString("days_present"));
                    record.setLeaveCount(rs.getInt("leave_count"));
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Attendance> getAllAttendance1() {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.*, u.name as fetched_name, u.role as fetched_role " +
                     "FROM attendance a " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "ORDER BY a.attendance_id DESC";

        try (Connection con = DBUtility.getInstance().getDBConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Attendance record = new Attendance();
                record.setAttendanceId(rs.getInt("attendance_id"));
                record.setUserId(rs.getInt("user_id"));
                record.setMonthYear(rs.getString("month_year"));
                record.setDaysPresent(rs.getString("days_present"));
                record.setLeaveCount(rs.getInt("leave_count"));
                
                record.setEmpName(rs.getString("fetched_name")); 
                
                record.setOtHours(rs.getDouble("ot_hours")); //
                record.setTotalWorkingHours(rs.getDouble("total_working_hours")); //
                record.setLateArrivals(rs.getInt("late_arrivals")); //
                
                list.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}