package model;

import java.sql.Timestamp;

public class AdminUser {
    private int adminId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role;
    private String district;
    private Integer stationId;
    private Timestamp createdAt;
    private Timestamp lastLogin;
    
    // Default constructor
    public AdminUser() {}
    
    // Constructor for authentication
    public AdminUser(String username, String password) {
        this.username = username;
        this.password = password;
    }
    
    // Constructor for admin creation
    public AdminUser(String username, String password, String fullName, 
                    String email, String role, String district, Integer stationId) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.district = district;
        this.stationId = stationId;
    }
    
    // Getters and Setters
    public int getAdminId() { 
        return adminId; 
    }
    
    public void setAdminId(int adminId) { 
        this.adminId = adminId; 
    }
    
    public String getUsername() { 
        return username; 
    }
    
    public void setUsername(String username) { 
        this.username = username; 
    }
    
    public String getPassword() { 
        return password; 
    }
    
    public void setPassword(String password) { 
        this.password = password; 
    }
    
    public String getFullName() { 
        return fullName; 
    }
    
    public void setFullName(String fullName) { 
        this.fullName = fullName; 
    }
    
    public String getEmail() { 
        return email; 
    }
    
    public void setEmail(String email) { 
        this.email = email; 
    }
    
    public String getRole() { 
        return role; 
    }
    
    public void setRole(String role) { 
        this.role = role; 
    }
    
    public String getDistrict() { 
        return district; 
    }
    
    public void setDistrict(String district) { 
        this.district = district; 
    }
    
    public Integer getStationId() { 
        return stationId; 
    }
    
    public void setStationId(Integer stationId) { 
        this.stationId = stationId; 
    }
    
    public Timestamp getCreatedAt() { 
        return createdAt; 
    }
    
    public void setCreatedAt(Timestamp createdAt) { 
        this.createdAt = createdAt; 
    }
    
    public Timestamp getLastLogin() { 
        return lastLogin; 
    }
    
    public void setLastLogin(Timestamp lastLogin) { 
        this.lastLogin = lastLogin; 
    }
    
    // Utility method to check if super admin
    public boolean isSuperAdmin() {
        return "Super Admin".equals(this.role);
    }
    
    // Utility method to check if district admin
    public boolean isDistrictAdmin() {
        return "District Admin".equals(this.role);
    }
    
    // Utility method to check if station admin
    public boolean isStationAdmin() {
        return "Station Admin".equals(this.role);
    }
    
    @Override
    public String toString() {
        return "AdminUser{" +
                "adminId=" + adminId +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                ", role='" + role + '\'' +
                ", district='" + district + '\'' +
                ", lastLogin=" + lastLogin +
                '}';
    }
}