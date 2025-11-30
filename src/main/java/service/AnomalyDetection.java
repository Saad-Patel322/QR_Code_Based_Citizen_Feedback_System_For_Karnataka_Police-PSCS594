package service;

import dao.FeedbackDAO;
import model.PoliceStation;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;

public class AnomalyDetection {
    
    private final FeedbackDAO feedbackDAO;
    
    public AnomalyDetection() {
        this.feedbackDAO = new FeedbackDAO();
    }
    
    public AnomalyDetection(FeedbackDAO feedbackDAO) {
        this.feedbackDAO = feedbackDAO;
    }
    
    public Map<String, Object> detectAnomalies(int stationId, int daysToCheck) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Get historical data for this station
            LocalDateTime endDate = LocalDateTime.now();
            LocalDateTime startDate = endDate.minus(daysToCheck, ChronoUnit.DAYS);
            
            // Calculate baseline (average negative feedback per day)
            double baseline = calculateBaseline(stationId, daysToCheck);
            int currentNegativeCount = getRecentNegativeCount(stationId, 1); // Last 24 hours
            
            boolean isAnomaly = currentNegativeCount > (baseline * 2); // Threshold: 2x baseline
            String explanation = generateExplanation(stationId, currentNegativeCount, baseline);
            
            result.put("isAnomaly", isAnomaly);
            result.put("stationId", stationId);
            result.put("currentNegativeCount", currentNegativeCount);
            result.put("baseline", baseline);
            result.put("threshold", baseline * 2);
            result.put("explanation", explanation);
            result.put("severity", calculateSeverity(currentNegativeCount, baseline));
            
        } catch (Exception e) {
            result.put("isAnomaly", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    public List<Map<String, Object>> checkAllStationsForAnomalies(int daysToCheck) {
        List<Map<String, Object>> anomalies = new ArrayList<>();
        
        // This would typically check all stations
        // For now, return empty list - implement based on your station data
        
        return anomalies;
    }
    
    public Map<String, Object> detectSentimentShift(int stationId, int periodDays) {
        Map<String, Object> analysis = new HashMap<>();
        
        try {
            // Get sentiment distribution for current period
            Map<String, Integer> currentSentiment = getSentimentDistribution(stationId, periodDays);
            Map<String, Integer> previousSentiment = getSentimentDistribution(stationId, periodDays * 2);
            
            double currentPositiveRatio = calculatePositiveRatio(currentSentiment);
            double previousPositiveRatio = calculatePositiveRatio(previousSentiment);
            
            boolean significantDrop = (previousPositiveRatio - currentPositiveRatio) > 0.2; // 20% drop
            String shiftExplanation = generateShiftExplanation(currentPositiveRatio, previousPositiveRatio);
            
            analysis.put("significantShift", significantDrop);
            analysis.put("currentPositiveRatio", currentPositiveRatio);
            analysis.put("previousPositiveRatio", previousPositiveRatio);
            analysis.put("shiftPercentage", previousPositiveRatio - currentPositiveRatio);
            analysis.put("explanation", shiftExplanation);
            
        } catch (Exception e) {
            analysis.put("significantShift", false);
            analysis.put("error", e.getMessage());
        }
        
        return analysis;
    }
    
    private double calculateBaseline(int stationId, int days) {
        // Simplified baseline calculation
        // In production, this would use historical data analysis
        int totalNegative = getRecentNegativeCount(stationId, days);
        return (double) totalNegative / days;
    }
    
    private int getRecentNegativeCount(int stationId, int days) {
        // This would query the database for negative feedback in the last 'days'
        // For now, return a mock value
        return feedbackDAO.getFeedbackByStation(stationId).stream()
                .filter(f -> "Negative".equals(f.getSentiment()))
                .mapToInt(f -> 1)
                .sum();
    }
    
    private Map<String, Integer> getSentimentDistribution(int stationId, int days) {
        Map<String, Integer> distribution = new HashMap<>();
        distribution.put("Positive", 0);
        distribution.put("Negative", 0);
        distribution.put("Neutral", 0);
        
        // This would query actual database data
        // Mock implementation
        distribution.put("Positive", new Random().nextInt(10));
        distribution.put("Negative", new Random().nextInt(5));
        distribution.put("Neutral", new Random().nextInt(3));
        
        return distribution;
    }
    
    private double calculatePositiveRatio(Map<String, Integer> sentimentDistribution) {
        int total = sentimentDistribution.values().stream().mapToInt(Integer::intValue).sum();
        if (total == 0) return 0.0;
        return (double) sentimentDistribution.get("Positive") / total;
    }
    
    private String generateExplanation(int stationId, int currentCount, double baseline) {
        if (currentCount > baseline * 2) {
            return String.format(
                "Station %d has %d negative feedbacks in last 24 hours, which is %.1fx above the baseline of %.1f",
                stationId, currentCount, currentCount / baseline, baseline
            );
        } else {
            return String.format(
                "Station %d has %d negative feedbacks, within normal range (baseline: %.1f)",
                stationId, currentCount, baseline
            );
        }
    }
    
    private String generateShiftExplanation(double currentRatio, double previousRatio) {
        double shift = previousRatio - currentRatio;
        if (shift > 0.2) {
            return String.format(
                "Significant drop in positive feedback: from %.1f%% to %.1f%% (%.1f%% decrease)",
                previousRatio * 100, currentRatio * 100, shift * 100
            );
        } else {
            return "Sentiment levels are stable";
        }
    }
    
    private String calculateSeverity(int currentCount, double baseline) {
        double ratio = currentCount / baseline;
        if (ratio > 3) return "CRITICAL";
        if (ratio > 2) return "HIGH";
        if (ratio > 1.5) return "MEDIUM";
        return "LOW";
    }
    
    // Real-time monitoring method (would be called periodically)
    public void monitorStations() {
        System.out.println("Starting anomaly detection monitoring...");
        
        // This would be implemented with scheduling (Quartz, @Scheduled, etc.)
        // For now, just log the monitoring start
    }
}