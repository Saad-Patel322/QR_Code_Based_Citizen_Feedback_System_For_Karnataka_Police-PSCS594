package controller;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/generateQRCode")
public class QRCodeGenerator extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Configuration - choose one method below

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // METHOD 1: Environment Variable (Best for production)
        String baseUrl = System.getenv("NGROK_URL");
        if (baseUrl == null || baseUrl.trim().isEmpty()) {
            // METHOD 2: System Property (Good for development)
            baseUrl = System.getProperty("ngrok.url", "https://superb-accusatival-coralee.ngrok-free.dev");
        }
        
        String feedbackUrl = baseUrl + "/PoliceFeedbackSystem/feedback-form.jsp";
        
        try {
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(feedbackUrl, BarcodeFormat.QR_CODE, 300, 300);
            
            response.setContentType("image/png");
            OutputStream outputStream = response.getOutputStream();
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", outputStream);
            outputStream.flush();
            outputStream.close();
            
        } catch (WriterException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "QR Code generation failed");
        }
    }
}