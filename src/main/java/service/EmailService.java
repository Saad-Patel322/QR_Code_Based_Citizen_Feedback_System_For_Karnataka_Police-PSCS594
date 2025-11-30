package service;

import model.Feedback;
import model.PoliceStation;
import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.Properties;

public class EmailService {
    private final String host;
    private final String port;
    private final String username;
    private final String password;
    private final boolean auth;
    
    public EmailService() {
        // Default configuration - update these in your application
        this.host = "smtp.gmail.com";
        this.port = "587";
        this.username = "your-email@gmail.com";
        this.password = "your-app-password";
        this.auth = true;
    }
    
    public EmailService(String host, String port, String username, String password, boolean auth) {
        this.host = host;
        this.port = port;
        this.username = username;
        this.password = password;
        this.auth = auth;
    }
    
    public boolean sendNegativeFeedbackAlert(Feedback feedback, PoliceStation station) {
        String subject = "🚨 Negative Feedback Alert - " + station.getStationName();
        
        String message = buildNegativeFeedbackEmail(feedback, station);
        String recipient = station.getStationEmailId();
        
        return sendEmail(recipient, subject, message);
    }
    
    public boolean sendPositiveFeedbackNotification(Feedback feedback, PoliceStation station) {
        String subject = "✅ Positive Feedback Received - " + station.getStationName();
        
        String message = buildPositiveFeedbackEmail(feedback, station);
        String recipient = station.getStationEmailId();
        
        return sendEmail(recipient, subject, message);
    }
    
    public boolean sendAnomalyAlert(PoliceStation station, int negativeCount, int threshold) {
        String subject = "⚠️ Anomaly Detected - " + station.getStationName();
        
        String message = buildAnomalyAlertEmail(station, negativeCount, threshold);
        String recipient = station.getSpEmailId(); // Send to SP
        
        return sendEmail(recipient, subject, message);
    }
    
    private boolean sendEmail(String to, String subject, String body) {
        try {
            Properties properties = new Properties();
            properties.put("mail.smtp.host", host);
            properties.put("mail.smtp.port", port);
            properties.put("mail.smtp.auth", String.valueOf(auth));
            properties.put("mail.smtp.starttls.enable", "true");
            
            Session session = Session.getInstance(properties, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");
            
            Transport.send(message);
            System.out.println("Email sent successfully to: " + to);
            return true;
            
        } catch (MessagingException e) {
            System.err.println("Failed to send email to " + to + ": " + e.getMessage());
            return false;
        }
    }
    
    private String buildNegativeFeedbackEmail(Feedback feedback, PoliceStation station) {
        return """
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    body { font-family: Arial, sans-serif; }
                    .alert { color: #d63031; font-weight: bold; }
                    .container { border: 1px solid #ddd; padding: 20px; border-radius: 5px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <h2 class="alert">Negative Feedback Alert</h2>
                    <p><strong>Station:</strong> %s</p>
                    <p><strong>District:</strong> %s</p>
                    <p><strong>Rating:</strong> %d/5 ⭐</p>
                    <p><strong>Feedback:</strong> %s</p>
                    <p><strong>Date:</strong> %s</p>
                    <br>
                    <p>Please review this feedback and take appropriate action.</p>
                    <p><em>Karnataka Police Feedback System</em></p>
                </div>
            </body>
            </html>
            """.formatted(
                station.getStationName(),
                station.getDistrictName(),
                feedback.getRating(),
                feedback.getFeedbackText(),
                feedback.getSubmissionDate().toString()
            );
    }
    
    private String buildPositiveFeedbackEmail(Feedback feedback, PoliceStation station) {
        return """
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    body { font-family: Arial, sans-serif; }
                    .positive { color: #00b894; font-weight: bold; }
                    .container { border: 1px solid #ddd; padding: 20px; border-radius: 5px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <h2 class="positive">Positive Feedback Received</h2>
                    <p><strong>Station:</strong> %s</p>
                    <p><strong>District:</strong> %s</p>
                    <p><strong>Rating:</strong> %d/5 ⭐</p>
                    <p><strong>Feedback:</strong> %s</p>
                    <p><strong>Date:</strong> %s</p>
                    <br>
                    <p>Great work! Keep maintaining the high standards.</p>
                    <p><em>Karnataka Police Feedback System</em></p>
                </div>
            </body>
            </html>
            """.formatted(
                station.getStationName(),
                station.getDistrictName(),
                feedback.getRating(),
                feedback.getFeedbackText(),
                feedback.getSubmissionDate().toString()
            );
    }
    
    private String buildAnomalyAlertEmail(PoliceStation station, int negativeCount, int threshold) {
        return """
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    body { font-family: Arial, sans-serif; }
                    .warning { color: #f39c12; font-weight: bold; }
                    .container { border: 1px solid #ddd; padding: 20px; border-radius: 5px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <h2 class="warning">Anomaly Detection Alert</h2>
                    <p><strong>Station:</strong> %s</p>
                    <p><strong>District:</strong> %s</p>
                    <p><strong>Negative Feedback Count:</strong> %d</p>
                    <p><strong>Threshold:</strong> %d</p>
                    <p><strong>Exceeded by:</strong> %d feedbacks</p>
                    <br>
                    <p>This station has received an unusually high number of negative feedbacks.</p>
                    <p>Please investigate and take corrective measures.</p>
                    <p><em>Karnataka Police Feedback System - AI Monitoring</em></p>
                </div>
            </body>
            </html>
            """.formatted(
                station.getStationName(),
                station.getDistrictName(),
                negativeCount,
                threshold,
                negativeCount - threshold
            );
    }
}