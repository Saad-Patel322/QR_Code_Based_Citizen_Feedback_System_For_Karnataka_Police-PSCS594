package controller;

import service.EmailService;
import dao.FeedbackDAO;
import dao.PoliceStationDAO;
import model.Feedback;
import model.PoliceStation;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/sendAlert")
public class EmailAlertServlet extends HttpServlet {
    private EmailService emailService;
    private FeedbackDAO feedbackDAO;
    private PoliceStationDAO policeStationDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        emailService = new EmailService();
        feedbackDAO = new FeedbackDAO();
        policeStationDAO = new PoliceStationDAO();
        gson = new Gson();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String alertType = request.getParameter("alertType");
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        
        try {
            Feedback feedback = getFeedbackById(feedbackId);
            PoliceStation station = policeStationDAO.getStationById(feedback.getStationId());
            
            boolean success = false;
            String message = "";
            
            switch (alertType) {
                case "negative":
                    success = emailService.sendNegativeFeedbackAlert(feedback, station);
                    message = "Negative feedback alert sent successfully";
                    break;
                case "positive":
                    success = emailService.sendPositiveFeedbackNotification(feedback, station);
                    message = "Positive feedback notification sent successfully";
                    break;
                case "anomaly":
                    int threshold = Integer.parseInt(request.getParameter("threshold"));
                    success = emailService.sendAnomalyAlert(station, 
                            feedbackDAO.getNegativeFeedbackCount(), threshold);
                    message = "Anomaly alert sent successfully";
                    break;
            }
            
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"" + message + "\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to send alert\"}");
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to send alert: " + e.getMessage() + "\"}");
        }
    }
    
    private Feedback getFeedbackById(int feedbackId) {
        // This would typically fetch from database
        // For now, return mock data
        return new Feedback();
    }
}