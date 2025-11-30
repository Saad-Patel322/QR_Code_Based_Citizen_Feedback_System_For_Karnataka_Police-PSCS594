<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
    String errorMessage = request.getParameter("message");
    if (errorMessage == null) {
        errorMessage = "An unexpected error occurred.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Karnataka Police</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .error-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .error-card {
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
    <div class="error-container">
        <div class="error-card">
            <div class="error-icon mb-4">
                <i class="fas fa-exclamation-triangle fa-5x text-danger"></i>
            </div>
            <h2 class="mb-3">Oops! Something Went Wrong</h2>
            <p class="lead mb-4"><%= errorMessage %></p>
            
            <div class="alert alert-warning mb-4">
                <i class="fas fa-lightbulb me-2"></i>
                <strong>Need help?</strong><br>
                If this problem persists, please contact the system administrator.
            </div>

            <div class="d-flex flex-column flex-md-row justify-content-center gap-3">
                <a href="feedback-form.jsp" class="btn btn-primary btn-lg">
                    <i class="fas fa-arrow-left me-2"></i>Try Again
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