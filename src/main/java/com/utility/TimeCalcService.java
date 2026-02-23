package com.utility;

import java.time.LocalTime;
import java.time.Duration;
import java.time.format.DateTimeFormatter;

public class TimeCalcService {
	private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("H:mm");

	public static double calculateHours(String clockInOut) {
		if (clockInOut == null || !clockInOut.contains("-"))
			return 0.0;
		try {
			String[] parts = clockInOut.split("-");
			LocalTime start = parseTime(parts[0].trim());
			LocalTime end = parseTime(parts[1].trim());
			long mins = Duration.between(start, end).toMinutes();
			if (mins < 0)
				mins += 1440; // Handle overnight shifts
			return (double) mins / 60.0;
		} catch (Exception e) {
			return 0.0;
		}
	}

	private static LocalTime parseTime(String t) {
		if (!t.contains(":"))
			t += ":00";
		return LocalTime.parse(t, FMT);
	}
}