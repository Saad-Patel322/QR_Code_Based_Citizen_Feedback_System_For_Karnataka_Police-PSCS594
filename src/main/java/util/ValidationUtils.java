package util;

import java.util.regex.Pattern;
import java.util.Arrays;
import java.util.List;

public class ValidationUtils {
    
    // Regex patterns
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    
    private static final Pattern PHONE_PATTERN = 
        Pattern.compile("^[6-9]\\d{9}$"); // Indian phone numbers
    
    private static final Pattern NAME_PATTERN = 
        Pattern.compile("^[a-zA-Z\\s.'-]{2,50}$");
    
    private static final Pattern DISTRICT_PATTERN = 
        Pattern.compile("^[a-zA-Z\\s]{2,50}$");
    
    private static final Pattern STATION_PATTERN = 
        Pattern.compile("^[a-zA-Z0-9\\s().,-]{2,100}$");
    
    // Common injection patterns to block
    private static final List<Pattern> INJECTION_PATTERNS = Arrays.asList(
        Pattern.compile("<script>", Pattern.CASE_INSENSITIVE),
        Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE),
        Pattern.compile("onload=", Pattern.CASE_INSENSITIVE),
        Pattern.compile("onerror=", Pattern.CASE_INSENSITIVE),
        Pattern.compile("onclick=", Pattern.CASE_INSENSITIVE),
        Pattern.compile("union\\s+select", Pattern.CASE_INSENSITIVE),
        Pattern.compile("drop\\s+table", Pattern.CASE_INSENSITIVE),
        Pattern.compile("insert\\s+into", Pattern.CASE_INSENSITIVE),
        Pattern.compile("delete\\s+from", Pattern.CASE_INSENSITIVE),
        Pattern.compile("sleep\\(", Pattern.CASE_INSENSITIVE)
    );
    
    /**
     * Validate email address
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }
    
    /**
     * Validate Indian phone number
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) return false;
        // Remove spaces and special characters
        String cleanedPhone = phone.replaceAll("[^0-9]", "");
        return PHONE_PATTERN.matcher(cleanedPhone).matches();
    }
    
    /**
     * Validate name (allows letters, spaces, and common punctuation)
     */
    public static boolean isValidName(String name) {
        if (name == null || name.trim().isEmpty()) return false;
        return NAME_PATTERN.matcher(name.trim()).matches();
    }
    
    /**
     * Validate district name
     */
    public static boolean isValidDistrict(String district) {
        if (district == null || district.trim().isEmpty()) return false;
        return DISTRICT_PATTERN.matcher(district.trim()).matches();
    }
    
    /**
     * Validate police station name
     */
    public static boolean isValidStation(String station) {
        if (station == null || station.trim().isEmpty()) return false;
        return STATION_PATTERN.matcher(station.trim()).matches();
    }
    
    /**
     * Validate rating (1-5)
     */
    public static boolean isValidRating(int rating) {
        return rating >= 1 && rating <= 5;
    }
    
    /**
     * Validate rating from string
     */
    public static boolean isValidRating(String rating) {
        if (rating == null || rating.trim().isEmpty()) return false;
        try {
            int ratingValue = Integer.parseInt(rating.trim());
            return isValidRating(ratingValue);
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * Sanitize input to prevent XSS and SQL injection
     */
    public static String sanitizeInput(String input) {
        if (input == null) return null;
        
        String sanitized = input.trim();
        
        // Remove potential HTML tags
        sanitized = sanitized.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
        
        // Remove potential SQL injection patterns
        for (Pattern pattern : INJECTION_PATTERNS) {
            sanitized = pattern.matcher(sanitized).replaceAll("");
        }
        
        // Remove extra whitespace
        sanitized = sanitized.replaceAll("\\s+", " ");
        
        return sanitized;
    }
    
    /**
     * Sanitize feedback text (allows more characters but still safe)
     */
    public static String sanitizeFeedback(String feedback) {
        if (feedback == null) return null;
        
        String sanitized = feedback.trim();
        
        // Allow basic punctuation but block scripts
        sanitized = sanitized.replaceAll("<script>", "")
                           .replaceAll("javascript:", "")
                           .replaceAll("onload=", "")
                           .replaceAll("onerror=", "")
                           .replaceAll("onclick=", "");
        
        // Limit length
        if (sanitized.length() > 1000) {
            sanitized = sanitized.substring(0, 1000);
        }
        
        return sanitized;
    }
    
    /**
     * Validate and sanitize email
     */
    public static String validateAndSanitizeEmail(String email) {
        if (!isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email format");
        }
        return sanitizeInput(email);
    }
    
    /**
     * Validate and sanitize phone
     */
    public static String validateAndSanitizePhone(String phone) {
        if (!isValidPhone(phone)) {
            throw new IllegalArgumentException("Invalid phone number format");
        }
        return phone.replaceAll("[^0-9]", ""); // Return only digits
    }
    
    /**
     * Validate feedback submission data
     */
    public static boolean isValidFeedbackData(String email, String name, String phone, 
                                            String district, String station, int rating, 
                                            String feedbackText) {
        return isValidEmail(email) &&
               (name == null || name.trim().isEmpty() || isValidName(name)) &&
               (phone == null || phone.trim().isEmpty() || isValidPhone(phone)) &&
               isValidDistrict(district) &&
               isValidStation(station) &&
               isValidRating(rating) &&
               feedbackText != null && !feedbackText.trim().isEmpty() &&
               feedbackText.length() <= 1000;
    }
    
    /**
     * Get validation error message for feedback data
     */
    public static String getFeedbackValidationError(String email, String name, String phone, 
                                                  String district, String station, int rating, 
                                                  String feedbackText) {
        if (!isValidEmail(email)) return "Invalid email address format";
        if (name != null && !name.trim().isEmpty() && !isValidName(name)) return "Invalid name format";
        if (phone != null && !phone.trim().isEmpty() && !isValidPhone(phone)) return "Invalid phone number (10 digits starting with 6-9)";
        if (!isValidDistrict(district)) return "Invalid district name";
        if (!isValidStation(station)) return "Invalid police station name";
        if (!isValidRating(rating)) return "Rating must be between 1 and 5";
        if (feedbackText == null || feedbackText.trim().isEmpty()) return "Feedback text is required";
        if (feedbackText.length() > 1000) return "Feedback text too long (max 1000 characters)";
        
        return null; // No error
    }
    
    /**
     * Check if string contains SQL injection patterns
     */
    public static boolean containsSQLInjection(String input) {
        if (input == null) return false;
        
        for (Pattern pattern : INJECTION_PATTERNS) {
            if (pattern.matcher(input).find()) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Check if string contains XSS patterns
     */
    public static boolean containsXSS(String input) {
        if (input == null) return false;
        
        String lowerInput = input.toLowerCase();
        return lowerInput.contains("<script>") ||
               lowerInput.contains("javascript:") ||
               lowerInput.contains("onload=") ||
               lowerInput.contains("onerror=") ||
               lowerInput.contains("onclick=");
    }
    
    /**
     * Validate admin login credentials
     */
    public static boolean isValidAdminCredentials(String username, String password) {
        return username != null && !username.trim().isEmpty() &&
               password != null && !password.trim().isEmpty() &&
               username.length() >= 3 && username.length() <= 50 &&
               password.length() >= 3 && password.length() <= 100 &&
               !containsSQLInjection(username) && !containsSQLInjection(password);
    }
    
    /**
     * Truncate string to specified length
     */
    public static String truncate(String input, int maxLength) {
        if (input == null) return null;
        if (input.length() <= maxLength) return input;
        return input.substring(0, maxLength) + "...";
    }
}