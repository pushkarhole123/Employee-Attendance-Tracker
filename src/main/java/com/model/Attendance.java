package com.model;

public class Attendance {

	private int attendanceId;
	private int userId;
	private String monthYear;
	private String daysPresent;
	private int leaveCount;
	private String EmpName;
	private double otHours;
	private double totalWorkingHours;
	private int lateArrivals;

	public Attendance() {
	}

	public double getOtHours() {
		return otHours;
	}

	public void setOtHours(double otHours) {
		this.otHours = otHours;
	}

	public double getTotalWorkingHours() {
		return totalWorkingHours;
	}

	public void setTotalWorkingHours(double totalWorkingHours) {
		this.totalWorkingHours = totalWorkingHours;
	}

	public int getLateArrivals() {
		return lateArrivals;
	}

	public void setLateArrivals(int lateArrivals) {
		this.lateArrivals = lateArrivals;
	}

	public int getAttendanceId() {
		return attendanceId;
	}

	public void setAttendanceId(int attendanceId) {
		this.attendanceId = attendanceId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getMonthYear() {
		return monthYear;
	}

	public void setMonthYear(String monthYear) {
		this.monthYear = monthYear;
	}

	public String getDaysPresent() {
		return daysPresent;
	}

	public void setDaysPresent(String daysPresent) {
		this.daysPresent = daysPresent;
	}

	public int getLeaveCount() {
		return leaveCount;
	}

	public void setLeaveCount(int leaveCount) {
		this.leaveCount = leaveCount;
	}

	public void setEmpName(String string) {
		this.EmpName = EmpName;
	}

	public String getEmpName() {
		return EmpName;
	}

}
