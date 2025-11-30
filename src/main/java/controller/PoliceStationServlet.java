package controller;

import dao.PoliceStationDAO;
import model.PoliceStation;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/getPoliceStations")
public class PoliceStationServlet extends HttpServlet {
    private PoliceStationDAO policeStationDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        policeStationDAO = new PoliceStationDAO();
        gson = new Gson();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String district = request.getParameter("district");
        
        try {
            List<PoliceStation> stations;
            if (district != null && !district.isEmpty()) {
                stations = policeStationDAO.getStationsByDistrict(district);
            } else {
                stations = policeStationDAO.getAllPoliceStations();
            }
            
            String json = gson.toJson(stations);
            response.getWriter().write(json);
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to fetch police stations\"}");
        }
    }
}