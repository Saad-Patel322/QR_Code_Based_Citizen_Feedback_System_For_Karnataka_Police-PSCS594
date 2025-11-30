package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import dao.DatabaseConnection;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🚀 Karnataka Police Feedback System Starting...");
        
        // Test database connection
        try {
            if (DatabaseConnection.testConnection()) {
                System.out.println("✅ Database connection successful");
            } else {
                System.err.println("❌ Database connection failed");
            }
        } catch (Exception e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("🛑 Karnataka Police Feedback System Shutting Down...");
    }
}