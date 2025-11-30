package dao;

import model.Feedback;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    
    // Save feedback to database
    public boolean saveFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (email, name, phone, district, police_station, station_id, " +
                    "rating, feedback_text, suggestion, sentiment, category, is_anonymous, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, feedback.getEmail());
            stmt.setString(2, feedback.getName());
            stmt.setString(3, feedback.getPhone());
            stmt.setString(4, feedback.getDistrict());
            stmt.setString(5, feedback.getPoliceStation());
            stmt.setInt(6, feedback.getStationId());
            stmt.setInt(7, feedback.getRating());
            stmt.setString(8, feedback.getFeedbackText());
            stmt.setString(9, feedback.getSuggestion());
            stmt.setString(10, feedback.getSentiment());
            stmt.setString(11, feedback.getCategory());
            stmt.setBoolean(12, feedback.isAnonymous());
            stmt.setString(13, feedback.getStatus());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error saving feedback: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all feedback
    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM feedback ORDER BY submission_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                feedbackList.add(extractFeedbackFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all feedback: " + e.getMessage());
            e.printStackTrace();
        }
        return feedbackList;
    }
    
    // Get recent feedback with limit
    public List<Feedback> getRecentFeedback(int limit) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM feedback ORDER BY submission_date DESC LIMIT ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                feedbackList.add(extractFeedbackFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting recent feedback: " + e.getMessage());
            e.printStackTrace();
        }
        return feedbackList;
    }
    
    // Get feedback by station ID
    public List<Feedback> getFeedbackByStation(int stationId) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE station_id = ? ORDER BY submission_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, stationId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                feedbackList.add(extractFeedbackFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting feedback by station: " + e.getMessage());
            e.printStackTrace();
        }
        return feedbackList;
    }
    
    // Get total feedback count
    public int getTotalFeedbackCount() {
        String sql = "SELECT COUNT(*) as total FROM feedback";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total feedback count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get positive feedback count
    public int getPositiveFeedbackCount() {
        String sql = "SELECT COUNT(*) as total FROM feedback WHERE sentiment = 'Positive'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting positive feedback count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get negative feedback count
    public int getNegativeFeedbackCount() {
        String sql = "SELECT COUNT(*) as total FROM feedback WHERE sentiment = 'Negative'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting negative feedback count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get feedback by sentiment
    public List<Feedback> getFeedbackBySentiment(String sentiment) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE sentiment = ? ORDER BY submission_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, sentiment);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                feedbackList.add(extractFeedbackFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting feedback by sentiment: " + e.getMessage());
            e.printStackTrace();
        }
        return feedbackList;
    }
    
    // Get stations with most negative feedback
    public List<Object[]> getStationsWithMostNegativeFeedback() {
        List<Object[]> stationData = new ArrayList<>();
        String sql = "SELECT " +
                    "police_station, " +
                    "COUNT(CASE WHEN sentiment = 'Negative' THEN 1 END) as negative_count, " +
                    "COUNT(*) as total_feedback " +
                    "FROM feedback " +
                    "WHERE police_station IS NOT NULL AND police_station != '' " +
                    "GROUP BY police_station " +
                    "HAVING COUNT(CASE WHEN sentiment = 'Negative' THEN 1 END) > 0 " +
                    "ORDER BY negative_count DESC, total_feedback DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                String stationName = rs.getString("police_station");
                Long negativeCount = rs.getLong("negative_count");
                Long totalCount = rs.getLong("total_feedback");
                
                Object[] data = {stationName, negativeCount, totalCount};
                stationData.add(data);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting stations with most negative feedback: " + e.getMessage());
            e.printStackTrace();
        }
        return stationData;
    }
    
    // Helper method to extract Feedback from ResultSet
    private Feedback extractFeedbackFromResultSet(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getInt("feedback_id"));
        feedback.setEmail(rs.getString("email"));
        feedback.setName(rs.getString("name"));
        feedback.setPhone(rs.getString("phone"));
        feedback.setDistrict(rs.getString("district"));
        feedback.setPoliceStation(rs.getString("police_station"));
        feedback.setStationId(rs.getInt("station_id"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setFeedbackText(rs.getString("feedback_text"));
        feedback.setSuggestion(rs.getString("suggestion"));
        feedback.setSentiment(rs.getString("sentiment"));
        feedback.setCategory(rs.getString("category"));
        feedback.setAnonymous(rs.getBoolean("is_anonymous"));
        feedback.setSubmissionDate(rs.getTimestamp("submission_date"));
        feedback.setStatus(rs.getString("status"));
        return feedback;
    }
} 