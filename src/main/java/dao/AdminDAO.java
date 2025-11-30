package dao;

import model.AdminUser;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    
    // Authenticate admin user
    public AdminUser authenticateAdmin(String username, String password) {
        String sql = "SELECT * FROM admin_users WHERE username = ? AND password = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractAdminUserFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error authenticating admin: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Get admin by ID
    public AdminUser getAdminById(int adminId) {
        String sql = "SELECT * FROM admin_users WHERE admin_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, adminId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractAdminUserFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting admin by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Get all admins
    public List<AdminUser> getAllAdmins() {
        List<AdminUser> admins = new ArrayList<>();
        String sql = "SELECT * FROM admin_users ORDER BY role, username";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                admins.add(extractAdminUserFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all admins: " + e.getMessage());
            e.printStackTrace();
        }
        return admins;
    }
    
    // Create new admin
    public boolean createAdmin(AdminUser admin) {
        String sql = "INSERT INTO admin_users (username, password, full_name, email, role, district, station_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getPassword());
            stmt.setString(3, admin.getFullName());
            stmt.setString(4, admin.getEmail());
            stmt.setString(5, admin.getRole());
            stmt.setString(6, admin.getDistrict());
            
            if (admin.getStationId() != null) {
                stmt.setInt(7, admin.getStationId());
            } else {
                stmt.setNull(7, Types.INTEGER);
            }
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error creating admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Update admin last login
    public boolean updateLastLogin(int adminId) {
        String sql = "UPDATE admin_users SET last_login = CURRENT_TIMESTAMP WHERE admin_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, adminId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating last login: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Change admin password
    public boolean changePassword(int adminId, String newPassword) {
        String sql = "UPDATE admin_users SET password = ? WHERE admin_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newPassword);
            stmt.setInt(2, adminId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error changing password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Check if username exists
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) as count FROM admin_users WHERE username = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking username: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Helper method to extract AdminUser from ResultSet
    private AdminUser extractAdminUserFromResultSet(ResultSet rs) throws SQLException {
        AdminUser admin = new AdminUser();
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setUsername(rs.getString("username"));
        admin.setPassword(rs.getString("password"));
        admin.setFullName(rs.getString("full_name"));
        admin.setEmail(rs.getString("email"));
        admin.setRole(rs.getString("role"));
        admin.setDistrict(rs.getString("district"));
        
        int stationId = rs.getInt("station_id");
        if (!rs.wasNull()) {
            admin.setStationId(stationId);
        }
        
        admin.setCreatedAt(rs.getTimestamp("created_at"));
        admin.setLastLogin(rs.getTimestamp("last_login"));
        return admin;
    }
}