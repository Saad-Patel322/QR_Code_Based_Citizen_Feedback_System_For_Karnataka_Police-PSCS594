<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thank You - Karnataka Police</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --police-blue: #1a365d;
            --police-light-blue: #2d74da;
            --animation-timing: 0.3s ease;
        }
        
        * {
            transition: var(--animation-timing);
        }
        
        .thankyou-container {
            min-height: 100vh;
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            position: relative;
            overflow: hidden;
            animation: gradientShift 8s ease-in-out infinite;
        }
        
        .thankyou-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%);
            animation: shimmer 4s infinite;
        }
        
        .thankyou-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 3rem;
            text-align: center;
            color: #333;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 600px;
            width: 90%;
            animation: slideUp 0.8s ease, fadeIn 1s ease;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .thankyou-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(45, 116, 218, 0.1), transparent);
            transition: left 0.6s ease;
        }
        
        .thankyou-card:hover::before {
            left: 100%;
        }
        
        .feature-icon {
            width: 60px;
            height: 60px;
            background: #e3f2fd;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            animation: fadeInUp 0.6s ease;
        }
        
        .feature-icon:hover {
            transform: scale(1.1) rotate(5deg);
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
        }
        
        .police-logo {
            width: 100px;
            height: 100px;
            margin: 0 auto 2rem;
            animation: bounceIn 1s ease, float 3s ease-in-out infinite;
            filter: drop-shadow(0 5px 15px rgba(0,0,0,0.3));
            position: relative;
        }
        
        .police-logo::after {
            content: '';
            position: absolute;
            top: -10px;
            left: -10px;
            right: -10px;
            bottom: -10px;
            border: 2px solid transparent;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue), #10b981);
            background-size: 400% 400%;
            animation: gradientRotate 3s ease infinite;
            z-index: -1;
            opacity: 0.7;
        }
        
        .btn {
            position: relative;
            overflow: hidden;
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        
        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .btn:hover::before {
            left: 100%;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        
        .alert {
            animation: fadeInUp 0.6s ease 0.4s both;
            border-radius: 10px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .alert::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, #28a745, #20c997);
            animation: borderPulse 2s ease-in-out infinite;
        }
        
        /* Animations */
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes bounceIn {
            0% {
                opacity: 0;
                transform: scale(0.3);
            }
            50% {
                opacity: 1;
                transform: scale(1.05);
            }
            70% {
                transform: scale(0.9);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }
        
        @keyframes gradientShift {
            0%, 100% {
                background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            }
            50% {
                background: linear-gradient(135deg, var(--police-light-blue), var(--police-blue));
            }
        }
        
        @keyframes shimmer {
            0% {
                transform: translateX(-100%);
            }
            100% {
                transform: translateX(100%);
            }
        }
        
        @keyframes gradientRotate {
            0% {
                background-position: 0% 50%;
                transform: rotate(0deg);
            }
            50% {
                background-position: 100% 50%;
                transform: rotate(180deg);
            }
            100% {
                background-position: 0% 50%;
                transform: rotate(360deg);
            }
        }
        
        @keyframes borderPulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.7;
            }
        }
        
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }
        
        .thankyou-title {
            animation: fadeInUp 0.8s ease 0.2s both;
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .thankyou-text {
            animation: fadeInUp 0.8s ease 0.4s both;
        }
        
        .feature-item {
            animation: fadeInUp 0.6s ease;
        }
        
        .feature-item:nth-child(1) { animation-delay: 0.3s; }
        .feature-item:nth-child(2) { animation-delay: 0.4s; }
        .feature-item:nth-child(3) { animation-delay: 0.5s; }
        
        .button-group {
            animation: fadeInUp 0.8s ease 0.6s both;
        }
        
        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            background: linear-gradient(45deg, #ff6b6b, #4ecdc4, #45b7d1, #96ceb4, #feca57);
            animation: confettiFall 5s ease-in-out infinite;
        }
        
        @keyframes confettiFall {
            0% {
                transform: translateY(-100px) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(100vh) rotate(360deg);
                opacity: 0;
            }
        }
    </style>
</head>
<body>
    <div class="thankyou-container">
        <!-- Confetti Effect -->
        <div id="confetti-container"></div>
        
        <div class="thankyou-card">
            <!-- Karnataka Police Logo -->
            <div class="police-logo">
                <img src="images/police-logo.png" alt="Karnataka Police Logo" 
                     style="width: 100%; height: 100%; object-fit: contain; border-radius: 50%;">
            </div>
            
            <h2 class="mb-3 thankyou-title">Thank You for Your Feedback!</h2>
            <p class="lead mb-4 thankyou-text">Your input is valuable in helping us improve police services across Karnataka.</p>
            
            <div class="row mb-4">
                <div class="col-md-4 mb-3 feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-search text-primary fa-2x"></i>
                    </div>
                    <h6>Review & Analysis</h6>
                    <small class="text-muted">Your feedback will be carefully reviewed</small>
                </div>
                <div class="col-md-4 mb-3 feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-chart-line text-success fa-2x"></i>
                    </div>
                    <h6>AI Processing</h6>
                    <small class="text-muted">Sentiment analysis for better insights</small>
                </div>
                <div class="col-md-4 mb-3 feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-bell text-warning fa-2x"></i>
                    </div>
                    <h6>Action Taken</h6>
                    <small class="text-muted">Appropriate measures will be implemented</small>
                </div>
            </div>

            <div class="alert alert-success mb-4">
                <i class="fas fa-check-circle me-2"></i>
                <strong>Feedback Recorded Successfully!</strong><br>
                Reference ID: #<%= System.currentTimeMillis() %>
            </div>

            <div class="d-flex flex-column flex-md-row justify-content-center gap-3 button-group">
                <a href="feedback-form.jsp" class="btn btn-primary btn-lg">
                    <i class="fas fa-plus me-2"></i>Submit Another
                </a>
                <a href="generate-qr.jsp" class="btn btn-outline-primary btn-lg">
                    <i class="fas fa-qrcode me-2"></i>QR Code
                </a>
                <a href="index.jsp" class="btn btn-outline-secondary btn-lg">
                    <i class="fas fa-home me-2"></i>Home
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Create confetti effect
            createConfetti();
            
            // Add interactive effects
            const buttons = document.querySelectorAll('.btn');
            const featureIcons = document.querySelectorAll('.feature-icon');
            
            // Button click animation
            buttons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    this.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                });
            });
            
            // Feature icon hover effects
            featureIcons.forEach(icon => {
                icon.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.1) rotate(5deg)';
                });
                
                icon.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1) rotate(0)';
                });
            });
            
            // Add floating animation to logo
            const logo = document.querySelector('.police-logo');
            setInterval(() => {
                logo.style.animation = 'none';
                setTimeout(() => {
                    logo.style.animation = 'float 3s ease-in-out infinite, pulse 2s ease-in-out infinite';
                }, 10);
            }, 3000);
        });
        
        function createConfetti() {
            const container = document.getElementById('confetti-container');
            const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#feca57', '#ff9ff3'];
            
            for (let i = 0; i < 50; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'confetti';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.background = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.animationDelay = Math.random() * 5 + 's';
                confetti.style.width = Math.random() * 10 + 5 + 'px';
                confetti.style.height = Math.random() * 10 + 5 + 'px';
                container.appendChild(confetti);
            }
        }
    </script>
</body>
</html>