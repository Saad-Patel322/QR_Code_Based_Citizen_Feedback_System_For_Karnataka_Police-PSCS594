package model;

public class PoliceStation {
    private int stationId;
    private String stationName;
    private String stationAddress;
    private String subdivisionName;
    private String districtName;
    private String stationEmailId;
    private String spName;
    private String spOfficeAddress;
    private String spEmailId;
    
    // Default constructor
    public PoliceStation() {}
    
    // Constructor for basic station info
    public PoliceStation(int stationId, String stationName, String districtName) {
        this.stationId = stationId;
        this.stationName = stationName;
        this.districtName = districtName;
    }
    
    // Full constructor
    public PoliceStation(int stationId, String stationName, String stationAddress, 
                        String subdivisionName, String districtName, String stationEmailId,
                        String spName, String spOfficeAddress, String spEmailId) {
        this.stationId = stationId;
        this.stationName = stationName;
        this.stationAddress = stationAddress;
        this.subdivisionName = subdivisionName;
        this.districtName = districtName;
        this.stationEmailId = stationEmailId;
        this.spName = spName;
        this.spOfficeAddress = spOfficeAddress;
        this.spEmailId = spEmailId;
    }
    
    // Getters and Setters
    public int getStationId() { 
        return stationId; 
    }
    
    public void setStationId(int stationId) { 
        this.stationId = stationId; 
    }
    
    public String getStationName() { 
        return stationName; 
    }
    
    public void setStationName(String stationName) { 
        this.stationName = stationName; 
    }
    
    public String getStationAddress() { 
        return stationAddress; 
    }
    
    public void setStationAddress(String stationAddress) { 
        this.stationAddress = stationAddress; 
    }
    
    public String getSubdivisionName() { 
        return subdivisionName; 
    }
    
    public void setSubdivisionName(String subdivisionName) { 
        this.subdivisionName = subdivisionName; 
    }
    
    public String getDistrictName() { 
        return districtName; 
    }
    
    public void setDistrictName(String districtName) { 
        this.districtName = districtName; 
    }
    
    public String getStationEmailId() { 
        return stationEmailId; 
    }
    
    public void setStationEmailId(String stationEmailId) { 
        this.stationEmailId = stationEmailId; 
    }
    
    public String getSpName() { 
        return spName; 
    }
    
    public void setSpName(String spName) { 
        this.spName = spName; 
    }
    
    public String getSpOfficeAddress() { 
        return spOfficeAddress; 
    }
    
    public void setSpOfficeAddress(String spOfficeAddress) { 
        this.spOfficeAddress = spOfficeAddress; 
    }
    
    public String getSpEmailId() { 
        return spEmailId; 
    }
    
    public void setSpEmailId(String spEmailId) { 
        this.spEmailId = spEmailId; 
    }
    
    @Override
    public String toString() {
        return "PoliceStation{" +
                "stationId=" + stationId +
                ", stationName='" + stationName + '\'' +
                ", districtName='" + districtName + '\'' +
                ", stationEmailId='" + stationEmailId + '\'' +
                '}';
    }
}