package controller;

import dao.FeedbackDAO;
import dao.PoliceStationDAO;
import model.Feedback;
import service.SentimentAnalysis;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/submitFeedback")
public class FeedbackController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FeedbackDAO feedbackDAO;
    private PoliceStationDAO policeStationDAO;
    private SentimentAnalysis sentimentAnalysis;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
        policeStationDAO = new PoliceStationDAO();
        sentimentAnalysis = new SentimentAnalysis();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get form parameters
            String email = request.getParameter("email");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String policeStation = request.getParameter("policeStation");
            int stationId = Integer.parseInt(request.getParameter("policeStation"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String feedbackText = request.getParameter("feedbackText");
            String suggestion = request.getParameter("suggestion");
            boolean isAnonymous = "on".equals(request.getParameter("anonymous"));

            // Get district from station ID
            String district = policeStationDAO.getDistrictByStationId(stationId);

            // Create Feedback object
            Feedback feedback = new Feedback();
            feedback.setEmail(email);
            feedback.setName(isAnonymous ? "" : name);
            feedback.setPhone(isAnonymous ? "" : phone);
            feedback.setDistrict(district);
            feedback.setPoliceStation(policeStation);
            feedback.setStationId(stationId);
            feedback.setRating(rating);
            feedback.setFeedbackText(feedbackText);
            feedback.setSuggestion(suggestion);
            feedback.setAnonymous(isAnonymous);
            feedback.setSubmissionDate(new Timestamp(System.currentTimeMillis()));

            // Perform sentiment analysis
            String sentiment = sentimentAnalysis.analyzeSentiment(feedbackText);
            feedback.setSentiment(sentiment);

            // Save to database
            boolean isSaved = feedbackDAO.saveFeedback(feedback);

            if (isSaved) {
                // Check for negative feedback alert
                if ("Negative".equals(sentiment) && rating <= 2) {
                    // Trigger email alert (implement this later)
                    triggerNegativeFeedbackAlert(feedback);
                }
                
                response.sendRedirect("thank-you.jsp");
            } else {
                response.sendRedirect("error.jsp?message=Feedback submission failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Server error: " + e.getMessage());
        }
    }

    private void triggerNegativeFeedbackAlert(Feedback feedback) {
        // Implement email alert logic here
        System.out.println("ALERT: Negative feedback received for station: " + feedback.getPoliceStation());
    }
}