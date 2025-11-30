package controller;

import dao.FeedbackDAO;
import model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        try {
            // Get dashboard data
            int totalFeedback = feedbackDAO.getTotalFeedbackCount();
            int positiveFeedback = feedbackDAO.getPositiveFeedbackCount();
            int negativeFeedback = feedbackDAO.getNegativeFeedbackCount();
            List<Feedback> recentFeedback = feedbackDAO.getRecentFeedback(10);

            // Set attributes for JSP
            request.setAttribute("totalFeedback", totalFeedback);
            request.setAttribute("positiveFeedback", positiveFeedback);
            request.setAttribute("negativeFeedback", negativeFeedback);
            request.setAttribute("recentFeedback", recentFeedback);

            // Forward to dashboard JSP
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Error loading dashboard");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}