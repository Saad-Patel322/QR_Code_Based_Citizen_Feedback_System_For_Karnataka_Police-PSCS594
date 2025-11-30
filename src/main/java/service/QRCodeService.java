package service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;

public class QRCodeService {
    
    public String generateQRCodeBase64(String content, int width, int height) {
        try {
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(content, BarcodeFormat.QR_CODE, width, height);
            
            BufferedImage qrImage = MatrixToImageWriter.toBufferedImage(bitMatrix);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(qrImage, "PNG", baos);
            
            byte[] imageBytes = baos.toByteArray();
            return Base64.getEncoder().encodeToString(imageBytes);
            
        } catch (WriterException | IOException e) {
            System.err.println("Error generating QR code: " + e.getMessage());
            return null;
        }
    }
    
    public String generateFeedbackQRCode(String baseUrl, String contextPath) {
        String feedbackUrl = baseUrl + contextPath + "/feedback-form.jsp";
        return generateQRCodeBase64(feedbackUrl, 300, 300);
    }
    
    public String generateStationSpecificQRCode(String baseUrl, String contextPath, int stationId) {
        String feedbackUrl = baseUrl + contextPath + "/feedback-form.jsp?station=" + stationId;
        return generateQRCodeBase64(feedbackUrl, 300, 300);
    }
    
    // Utility method to get QR code as HTML img tag
    public String getQRCodeAsHTML(String baseUrl, String contextPath) {
        String qrCodeBase64 = generateFeedbackQRCode(baseUrl, contextPath);
        if (qrCodeBase64 != null) {
            return "<img src=\"data:image/png;base64," + qrCodeBase64 + "\" " +
                   "alt=\"Scan for Feedback\" style=\"width: 300px; height: 300px;\">";
        }
        return "<p>QR Code generation failed</p>";
    }
}