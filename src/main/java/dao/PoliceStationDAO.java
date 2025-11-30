package dao;

import model.PoliceStation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PoliceStationDAO {
    
    // Get all police stations
    public List<PoliceStation> getAllPoliceStations() {
        List<PoliceStation> stations = new ArrayList<>();
        String sql = "SELECT * FROM police_stations ORDER BY district_name, station_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                stations.add(extractPoliceStationFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all police stations: " + e.getMessage());
            e.printStackTrace();
        }
        return stations;
    }
    
    // Get police stations by district
    public List<PoliceStation> getStationsByDistrict(String district) {
        List<PoliceStation> stations = new ArrayList<>();
        String sql = "SELECT * FROM police_stations WHERE district_name = ? ORDER BY station_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, district);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                stations.add(extractPoliceStationFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting stations by district: " + e.getMessage());
            e.printStackTrace();
        }
        return stations;
    }
    
    // Get police station by ID
    public PoliceStation getStationById(int stationId) {
        String sql = "SELECT * FROM police_stations WHERE station_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, stationId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractPoliceStationFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting station by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Get district by station ID
    public String getDistrictByStationId(int stationId) {
        String sql = "SELECT district_name FROM police_stations WHERE station_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, stationId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("district_name");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting district by station ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Get all unique districts
    public List<String> getAllDistricts() {
        List<String> districts = new ArrayList<>();
        String sql = "SELECT DISTINCT district_name FROM police_stations ORDER BY district_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                districts.add(rs.getString("district_name"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all districts: " + e.getMessage());
            e.printStackTrace();
        }
        return districts;
    }
    
    // Get station email by station ID
    public String getStationEmailById(int stationId) {
        String sql = "SELECT station_email_id FROM police_stations WHERE station_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, stationId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("station_email_id");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting station email: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Helper method to extract PoliceStation from ResultSet
    private PoliceStation extractPoliceStationFromResultSet(ResultSet rs) throws SQLException {
        PoliceStation station = new PoliceStation();
        station.setStationId(rs.getInt("station_id"));
        station.setStationName(rs.getString("station_name"));
        station.setStationAddress(rs.getString("station_address"));
        station.setSubdivisionName(rs.getString("subdivision_name"));
        station.setDistrictName(rs.getString("district_name"));
        station.setStationEmailId(rs.getString("station_email_id"));
        station.setSpName(rs.getString("sp_name"));
        station.setSpOfficeAddress(rs.getString("sp_office_address"));
        station.setSpEmailId(rs.getString("sp_email_id"));
        return station;
    }
}