package model;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackId;
    private String email;
    private String name;
    private String phone;
    private String district;
    private String policeStation;
    private int stationId;
    private int rating;
    private String feedbackText;
    private String suggestion;
    private String sentiment;
    private String category;
    private boolean isAnonymous;
    private Timestamp submissionDate;
    private String status;
    
    // Default constructor
    public Feedback() {}
    
    // Constructor for new feedback
    public Feedback(String email, String name, String phone, String district, 
                   String policeStation, int stationId, int rating, 
                   String feedbackText, String suggestion) {
        this.email = email;
        this.name = name;
        this.phone = phone;
        this.district = district;
        this.policeStation = policeStation;
        this.stationId = stationId;
        this.rating = rating;
        this.feedbackText = feedbackText;
        this.suggestion = suggestion;
        this.sentiment = "Neutral";
        this.status = "New";
        this.submissionDate = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getFeedbackId() { 
        return feedbackId; 
    }
    
    public void setFeedbackId(int feedbackId) { 
        this.feedbackId = feedbackId; 
    }
    
    public String getEmail() { 
        return email; 
    }
    
    public void setEmail(String email) { 
        this.email = email; 
    }
    
    public String getName() { 
        return name; 
    }
    
    public void setName(String name) { 
        this.name = name; 
    }
    
    public String getPhone() { 
        return phone; 
    }
    
    public void setPhone(String phone) { 
        this.phone = phone; 
    }
    
    public String getDistrict() { 
        return district; 
    }
    
    public void setDistrict(String district) { 
        this.district = district; 
    }
    
    public String getPoliceStation() { 
        return policeStation; 
    }
    
    public void setPoliceStation(String policeStation) { 
        this.policeStation = policeStation; 
    }
    
    public int getStationId() { 
        return stationId; 
    }
    
    public void setStationId(int stationId) { 
        this.stationId = stationId; 
    }
    
    public int getRating() { 
        return rating; 
    }
    
    public void setRating(int rating) { 
        this.rating = rating; 
    }
    
    public String getFeedbackText() { 
        return feedbackText; 
    }
    
    public void setFeedbackText(String feedbackText) { 
        this.feedbackText = feedbackText; 
    }
    
    public String getSuggestion() { 
        return suggestion; 
    }
    
    public void setSuggestion(String suggestion) { 
        this.suggestion = suggestion; 
    }
    
    public String getSentiment() { 
        return sentiment; 
    }
    
    public void setSentiment(String sentiment) { 
        this.sentiment = sentiment; 
    }
    
    public String getCategory() { 
        return category; 
    }
    
    public void setCategory(String category) { 
        this.category = category; 
    }
    
    public boolean isAnonymous() { 
        return isAnonymous; 
    }
    
    public void setAnonymous(boolean anonymous) { 
        isAnonymous = anonymous; 
    }
    
    public Timestamp getSubmissionDate() { 
        return submissionDate; 
    }
    
    public void setSubmissionDate(Timestamp submissionDate) { 
        this.submissionDate = submissionDate; 
    }
    
    public String getStatus() { 
        return status; 
    }
    
    public void setStatus(String status) { 
        this.status = status; 
    }
    
    @Override
    public String toString() {
        return "Feedback{" +
                "feedbackId=" + feedbackId +
                ", email='" + email + '\'' +
                ", name='" + name + '\'' +
                ", district='" + district + '\'' +
                ", policeStation='" + policeStation + '\'' +
                ", rating=" + rating +
                ", sentiment='" + sentiment + '\'' +
                ", submissionDate=" + submissionDate +
                '}';
    }
}