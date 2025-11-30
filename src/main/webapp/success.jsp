<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Success - Karnataka Police</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .success-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #10b981, #059669);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .success-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 3rem;
            text-align: center;
            color: #333;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 90%;
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-card">
            <div class="success-icon mb-4">
                <i class="fas fa-check-circle fa-5x text-success"></i>
            </div>
            <h2 class="mb-3">Feedback Submitted Successfully!</h2>
            <p class="lead mb-4">Thank you for your valuable feedback. Your response has been recorded and will help us improve our services.</p>
            
            <div class="alert alert-info mb-4">
                <i class="fas fa-info-circle me-2"></i>
                <strong>What happens next?</strong><br>
                Your feedback will be analyzed and appropriate action will be taken by the concerned police station.
            </div>

            <div class="d-flex flex-column flex-md-row justify-content-center gap-3">
                <a href="feedback-form.jsp" class="btn btn-primary btn-lg">
                    <i class="fas fa-plus me-2"></i>Submit Another Feedback
                </a>
                <a href="index.jsp" class="btn btn-outline-secondary btn-lg">
                    <i class="fas fa-home me-2"></i>Back to Home
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>