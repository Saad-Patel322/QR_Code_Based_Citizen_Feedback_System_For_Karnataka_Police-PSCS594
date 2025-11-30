package controller;

import dao.FeedbackDAO;
import model.Feedback;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/feedback")
public class FeedbackDataServlet extends HttpServlet {
    private FeedbackDAO feedbackDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
        gson = new Gson();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            Object result;
            switch (action != null ? action : "all") {
                case "counts":
                    result = getFeedbackCounts();
                    break;
                case "recent":
                    int limit = Integer.parseInt(request.getParameter("limit") != null ? 
                            request.getParameter("limit") : "10");
                    result = feedbackDAO.getRecentFeedback(limit);
                    break;
                case "byStation":
                    int stationId = Integer.parseInt(request.getParameter("stationId"));
                    result = feedbackDAO.getFeedbackByStation(stationId);
                    break;
                case "bySentiment":
                    String sentiment = request.getParameter("sentiment");
                    result = feedbackDAO.getFeedbackBySentiment(sentiment);
                    break;
                default:
                    result = feedbackDAO.getAllFeedback();
            }
            
            String json = gson.toJson(result);
            response.getWriter().write(json);
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to fetch feedback data: " + e.getMessage() + "\"}");
        }
    }
    
    private Object getFeedbackCounts() {
        return new Object() {
            public int total = feedbackDAO.getTotalFeedbackCount();
            public int positive = feedbackDAO.getPositiveFeedbackCount();
            public int negative = feedbackDAO.getNegativeFeedbackCount();
        };
    }
}