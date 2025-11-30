package service;

import java.util.*;
import java.util.regex.Pattern;

public class SentimentAnalysis {
    
    // Positive and negative word dictionaries
    private static final Set<String> POSITIVE_WORDS = Set.of(
        "good", "excellent", "great", "awesome", "fantastic", "wonderful",
        "helpful", "polite", "friendly", "professional", "efficient", "quick",
        "fast", "satisfied", "happy", "thank", "thanks", "appreciate", "kind",
        "supportive", "responsive", "courteous", "respectful", "outstanding",
        "amazing", "brilliant", "superb", "impressive", "reliable", "honest"
    );
    
    private static final Set<String> NEGATIVE_WORDS = Set.of(
        "bad", "poor", "terrible", "awful", "horrible", "rude", "corrupt",
        "bribe", "slow", "not", "delay", "lazy", "unprofessional", "useless",
        "waste", "frustrating", "angry", "disappointed", "complaint",
        "harass", "threat", "ignore", "neglect", "incompetent", "failure",
        "problem", "issue", "wrong", "mistake", "error", "wait", "long"
    );
    
    // Police-specific keywords
    private static final Set<String> CORRUPTION_KEYWORDS = Set.of(
        "bribe", "corrupt", "money", "payment", "hafta", "commission"
    );
    
    private static final Set<String> BEHAVIOR_KEYWORDS = Set.of(
        "rude", "polite", "respect", "shout", "yell", "behavior", "attitude"
    );
    
    private static final Set<String> TIMELINESS_KEYWORDS = Set.of(
        "slow", "fast", "delay", "wait", "time", "quick", "immediate"
    );

    public String analyzeSentiment(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "Neutral";
        }
        
        // Preprocess text
        String cleanedText = preprocessText(text);
        
        // Calculate sentiment score using multiple algorithms
        double lexiconScore = calculateLexiconScore(cleanedText);
        double keywordScore = calculateKeywordScore(cleanedText);
        double ratingBasedScore = calculateRatingBasedScore(cleanedText);
        
        // Combined score with weights
        double finalScore = (lexiconScore * 0.5) + (keywordScore * 0.3) + (ratingBasedScore * 0.2);
        
        // Determine sentiment
        if (finalScore > 0.1) {
            return "Positive";
        } else if (finalScore < -0.1) {
            return "Negative";
        } else {
            return "Neutral";
        }
    }
    
    public String categorizeFeedback(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "General";
        }
        
        String cleanedText = preprocessText(text).toLowerCase();
        Map<String, Integer> categoryScores = new HashMap<>();
        
        // Check for corruption keywords
        if (containsAnyKeyword(cleanedText, CORRUPTION_KEYWORDS)) {
            return "Corruption";
        }
        
        // Score other categories
        categoryScores.put("Behavior", countKeywords(cleanedText, BEHAVIOR_KEYWORDS));
        categoryScores.put("Timeliness", countKeywords(cleanedText, TIMELINESS_KEYWORDS));
        
        // Find category with highest score
        return categoryScores.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("General");
    }
    
    public Map<String, Object> analyzeFeedbackWithDetails(String text) {
        Map<String, Object> analysis = new HashMap<>();
        
        if (text == null || text.trim().isEmpty()) {
            analysis.put("sentiment", "Neutral");
            analysis.put("category", "General");
            analysis.put("confidence", 0.5);
            analysis.put("keywords", new ArrayList<String>());
            return analysis;
        }
        
        String cleanedText = preprocessText(text);
        String sentiment = analyzeSentiment(cleanedText);
        String category = categorizeFeedback(cleanedText);
        List<String> extractedKeywords = extractKeywords(cleanedText);
        
        analysis.put("sentiment", sentiment);
        analysis.put("category", category);
        analysis.put("confidence", calculateConfidence(cleanedText, sentiment));
        analysis.put("keywords", extractedKeywords);
        
        return analysis;
    }
    
    private String preprocessText(String text) {
        if (text == null) return "";
        
        return text.toLowerCase()
                  .replaceAll("[^a-zA-Z0-9\\s]", "") // Remove special characters
                  .replaceAll("\\s+", " ")           // Replace multiple spaces
                  .trim();
    }
    
    private double calculateLexiconScore(String text) {
        String[] words = text.split("\\s+");
        int positiveCount = 0;
        int negativeCount = 0;
        
        for (String word : words) {
            if (POSITIVE_WORDS.contains(word)) {
                positiveCount++;
            } else if (NEGATIVE_WORDS.contains(word)) {
                negativeCount++;
            }
        }
        
        int totalWords = words.length;
        if (totalWords == 0) return 0.0;
        
        return (double) (positiveCount - negativeCount) / totalWords;
    }
    
    private double calculateKeywordScore(String text) {
        String lowerText = text.toLowerCase();
        int positiveMatches = countKeywords(lowerText, POSITIVE_WORDS);
        int negativeMatches = countKeywords(lowerText, NEGATIVE_WORDS);
        
        int totalMatches = positiveMatches + negativeMatches;
        if (totalMatches == 0) return 0.0;
        
        return (double) (positiveMatches - negativeMatches) / totalMatches;
    }
    
    private double calculateRatingBasedScore(String text) {
        // Simple heuristic based on text length and word variety
        String[] words = text.split("\\s+");
        Set<String> uniqueWords = new HashSet<>(Arrays.asList(words));
        
        double diversityScore = (double) uniqueWords.size() / words.length;
        double lengthScore = Math.min(words.length / 50.0, 1.0); // Normalize by 50 words
        
        return (diversityScore + lengthScore) / 2 - 0.5; // Center around 0
    }
    
    private double calculateConfidence(String text, String sentiment) {
        String[] words = text.split("\\s+");
        int sentimentWordCount = 0;
        
        Set<String> sentimentWords = new HashSet<>();
        sentimentWords.addAll(POSITIVE_WORDS);
        sentimentWords.addAll(NEGATIVE_WORDS);
        
        for (String word : words) {
            if (sentimentWords.contains(word)) {
                sentimentWordCount++;
            }
        }
        
        double wordConfidence = (double) sentimentWordCount / words.length;
        double lengthConfidence = Math.min(words.length / 20.0, 1.0);
        
        return (wordConfidence + lengthConfidence) / 2;
    }
    
    private boolean containsAnyKeyword(String text, Set<String> keywords) {
        return keywords.stream().anyMatch(text::contains);
    }
    
    private int countKeywords(String text, Set<String> keywords) {
        return (int) keywords.stream().filter(text::contains).count();
    }
    
    private List<String> extractKeywords(String text) {
        Set<String> allKeywords = new HashSet<>();
        allKeywords.addAll(POSITIVE_WORDS);
        allKeywords.addAll(NEGATIVE_WORDS);
        allKeywords.addAll(CORRUPTION_KEYWORDS);
        allKeywords.addAll(BEHAVIOR_KEYWORDS);
        allKeywords.addAll(TIMELINESS_KEYWORDS);
        
        List<String> foundKeywords = new ArrayList<>();
        for (String keyword : allKeywords) {
            if (text.contains(keyword)) {
                foundKeywords.add(keyword);
            }
        }
        
        return foundKeywords;
    }
}