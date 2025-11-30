package util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.concurrent.TimeUnit;

public class DateUtils {
    
    // Date formats
    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String TIME_FORMAT = "HH:mm:ss";
    public static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    public static final String DISPLAY_DATE_FORMAT = "dd MMM yyyy";
    public static final String DISPLAY_DATETIME_FORMAT = "dd MMM yyyy, hh:mm a";
    
    // Formatters
    private static final DateTimeFormatter DISPLAY_DATE_FORMATTER = 
        DateTimeFormatter.ofPattern(DISPLAY_DATE_FORMAT);
    private static final DateTimeFormatter DISPLAY_DATETIME_FORMATTER = 
        DateTimeFormatter.ofPattern(DISPLAY_DATETIME_FORMAT);
    
    /**
     * Convert Timestamp to display format string
     */
    public static String formatForDisplay(Timestamp timestamp) {
        if (timestamp == null) return "N/A";
        
        LocalDateTime dateTime = timestamp.toLocalDateTime();
        return dateTime.format(DISPLAY_DATETIME_FORMATTER);
    }
    
    /**
     * Convert Timestamp to simple date string
     */
    public static String formatDate(Timestamp timestamp) {
        if (timestamp == null) return "N/A";
        
        LocalDateTime dateTime = timestamp.toLocalDateTime();
        return dateTime.format(DISPLAY_DATE_FORMATTER);
    }
    
    /**
     * Get current timestamp
     */
    public static Timestamp getCurrentTimestamp() {
        return new Timestamp(System.currentTimeMillis());
    }
    
    /**
     * Get timestamp for X days ago
     */
    public static Timestamp getTimestampDaysAgo(int days) {
        LocalDateTime dateTime = LocalDateTime.now().minusDays(days);
        return Timestamp.valueOf(dateTime);
    }
    
    /**
     * Get timestamp for X hours ago
     */
    public static Timestamp getTimestampHoursAgo(int hours) {
        LocalDateTime dateTime = LocalDateTime.now().minusHours(hours);
        return Timestamp.valueOf(dateTime);
    }
    
    /**
     * Calculate days between two timestamps
     */
    public static long daysBetween(Timestamp start, Timestamp end) {
        if (start == null || end == null) return 0;
        
        long diff = end.getTime() - start.getTime();
        return TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
    }
    
    /**
     * Calculate hours between two timestamps
     */
    public static long hoursBetween(Timestamp start, Timestamp end) {
        if (start == null || end == null) return 0;
        
        long diff = end.getTime() - start.getTime();
        return TimeUnit.HOURS.convert(diff, TimeUnit.MILLISECONDS);
    }
    
    /**
     * Check if timestamp is today
     */
    public static boolean isToday(Timestamp timestamp) {
        if (timestamp == null) return false;
        
        LocalDate today = LocalDate.now();
        LocalDate date = timestamp.toLocalDateTime().toLocalDate();
        return today.equals(date);
    }
    
    /**
     * Check if timestamp is from last N days
     */
    public static boolean isFromLastNDays(Timestamp timestamp, int days) {
        if (timestamp == null) return false;
        
        LocalDateTime dateTime = timestamp.toLocalDateTime();
        LocalDateTime daysAgo = LocalDateTime.now().minusDays(days);
        return dateTime.isAfter(daysAgo);
    }
    
    /**
     * Get start of day timestamp
     */
    public static Timestamp getStartOfDay() {
        LocalDateTime startOfDay = LocalDateTime.now().with(LocalTime.MIN);
        return Timestamp.valueOf(startOfDay);
    }
    
    /**
     * Get start of specific day
     */
    public static Timestamp getStartOfDay(Timestamp timestamp) {
        LocalDateTime dateTime = timestamp.toLocalDateTime().with(LocalTime.MIN);
        return Timestamp.valueOf(dateTime);
    }
    
    /**
     * Get end of day timestamp
     */
    public static Timestamp getEndOfDay() {
        LocalDateTime endOfDay = LocalDateTime.now().with(LocalTime.MAX);
        return Timestamp.valueOf(endOfDay);
    }
    
    /**
     * Get start of week (Monday)
     */
    public static Timestamp getStartOfWeek() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startOfWeek = now.with(DayOfWeek.MONDAY).with(LocalTime.MIN);
        return Timestamp.valueOf(startOfWeek);
    }
    
    /**
     * Get start of month
     */
    public static Timestamp getStartOfMonth() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startOfMonth = now.withDayOfMonth(1).with(LocalTime.MIN);
        return Timestamp.valueOf(startOfMonth);
    }
    
    /**
     * Get readable time difference (e.g., "2 hours ago")
     */
    public static String getTimeAgo(Timestamp timestamp) {
        if (timestamp == null) return "Unknown";
        
        long diff = System.currentTimeMillis() - timestamp.getTime();
        
        if (diff < 60000) { // Less than 1 minute
            return "Just now";
        } else if (diff < 3600000) { // Less than 1 hour
            long minutes = TimeUnit.MINUTES.convert(diff, TimeUnit.MILLISECONDS);
            return minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        } else if (diff < 86400000) { // Less than 1 day
            long hours = TimeUnit.HOURS.convert(diff, TimeUnit.MILLISECONDS);
            return hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        } else if (diff < 604800000) { // Less than 1 week
            long days = TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
            return days + " day" + (days > 1 ? "s" : "") + " ago";
        } else {
            return formatForDisplay(timestamp);
        }
    }
    
    /**
     * Convert java.util.Date to java.sql.Timestamp
     */
    public static Timestamp toTimestamp(Date date) {
        if (date == null) return null;
        return new Timestamp(date.getTime());
    }
    
    /**
     * Convert string to timestamp (yyyy-MM-dd format)
     */
    public static Timestamp stringToTimestamp(String dateString) {
        if (dateString == null || dateString.trim().isEmpty()) return null;
        
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT);
            Date parsedDate = dateFormat.parse(dateString);
            return new Timestamp(parsedDate.getTime());
        } catch (Exception e) {
            System.err.println("Error parsing date string: " + dateString);
            return null;
        }
    }
    
    /**
     * Get current date as string
     */
    public static String getCurrentDateString() {
        return LocalDate.now().format(DateTimeFormatter.ofPattern(DATE_FORMAT));
    }
    
    /**
     * Get current datetime as string
     */
    public static String getCurrentDateTimeString() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern(DATETIME_FORMAT));
    }
}