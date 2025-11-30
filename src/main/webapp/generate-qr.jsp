<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate QR Code - Karnataka Police</title>
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
        
        body {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            min-height: 100vh;
        }
        
        .qr-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 2rem;
            animation: slideUp 0.8s ease;
            position: relative;
            overflow: hidden;
        }
        
        .qr-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(45, 116, 218, 0.05), transparent);
            transition: left 0.6s ease;
        }
        
        .qr-container:hover::before {
            left: 100%;
        }
        
        .instruction-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            border-left: 4px solid #2d74da;
            animation: fadeInLeft 0.6s ease 0.2s both;
            position: relative;
            overflow: hidden;
        }
        
        .instruction-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, var(--police-blue), var(--police-light-blue));
            animation: borderGlow 2s ease-in-out infinite;
        }
        
        .navbar {
            animation: slideDown 0.6s ease;
        }
        
        .qr-code-image {
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            transition: all 0.4s ease;
            animation: pulse 3s infinite, fadeIn 1s ease;
            position: relative;
        }
        
        .qr-code-image:hover {
            transform: scale(1.05) rotate(2deg);
            box-shadow: 0 15px 40px rgba(45, 116, 218, 0.3);
        }
        
        .btn {
            position: relative;
            overflow: hidden;
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
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
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
        
        @keyframes fadeInLeft {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
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
        
        @keyframes pulse {
            0%, 100% {
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }
            50% {
                box-shadow: 0 8px 30px rgba(45, 116, 218, 0.3);
            }
        }
        
        @keyframes borderGlow {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.7;
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
        
        .page-title {
            animation: fadeInUp 0.8s ease;
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .lead-text {
            animation: fadeInUp 0.8s ease 0.2s both;
        }
        
        .instruction-item {
            animation: fadeInLeft 0.6s ease;
            transition: all 0.3s ease;
        }
        
        .instruction-item:hover {
            transform: translateX(10px);
            background: rgba(45, 116, 218, 0.05);
            border-radius: 5px;
            padding-left: 10px;
        }
        
        .instruction-item:nth-child(1) { animation-delay: 0.3s; }
        .instruction-item:nth-child(2) { animation-delay: 0.4s; }
        .instruction-item:nth-child(3) { animation-delay: 0.5s; }
        
        .button-group {
            animation: fadeInUp 0.8s ease 0.6s both;
        }
        
        .qr-code-wrapper {
            position: relative;
            display: inline-block;
            animation: bounceIn 1s ease;
        }
        
        .qr-code-wrapper::after {
            content: '';
            position: absolute;
            top: -10px;
            left: -10px;
            right: -10px;
            bottom: -10px;
            border: 2px solid transparent;
            border-radius: 20px;
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue), #10b981, #f59e0b);
            background-size: 400% 400%;
            animation: gradientShift 3s ease infinite;
            z-index: -1;
            opacity: 0.7;
        }
        
        @keyframes gradientShift {
            0% {
                background-position: 0% 50%;
            }
            50% {
                background-position: 100% 50%;
            }
            100% {
                background-position: 0% 50%;
            }
        }
        
        .nav-link {
            transition: all 0.3s ease;
            border-radius: 5px;
        }
        
        .nav-link:hover {
            background: rgba(255,255,255,0.1);
            transform: translateY(-2px);
        }
        
        .navbar-brand {
            transition: all 0.3s ease;
        }
        
        .navbar-brand:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body class="bg-light">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <img src="images/police-logo.png" alt="Karnataka Police Logo" 
                     style="height: 40px; margin-right: 10px;">
                Karnataka Police
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="feedback-form.jsp">
                    <i class="fas fa-edit"></i> Direct Feedback
                </a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="qr-container text-center">
                    <h2 class="mb-4 page-title">
                        <i class="fas fa-qrcode me-2 float"></i>Feedback QR Code
                    </h2>
                    <p class="lead mb-4 lead-text">Scan this QR code to provide feedback for any Karnataka Police Station</p>
                    
                    <!-- QR Code Display -->
                    <div class="mb-4">
                        <div class="qr-code-wrapper">
                            <img src="generateQRCode" alt="Feedback QR Code" class="img-fluid qr-code-image" style="max-width: 300px;">
                        </div>
                    </div>
                    
                    <!-- Instructions -->
                    <div class="instruction-box text-start mb-4">
                        <h5 class="mb-3"><i class="fas fa-info-circle me-2"></i>How to Use:</h5>
                        <ul class="list-unstyled">
                            <li class="mb-2 instruction-item"><i class="fas fa-check text-success me-2"></i> Display this QR code at police stations</li>
                            <li class="mb-2 instruction-item"><i class="fas fa-check text-success me-2"></i> Citizens scan with their phone camera</li>
                            <li class="mb-2 instruction-item"><i class="fas fa-check text-success me-2"></i> Automatic redirect to feedback form</li>
                        </ul>
                    </div>
                    
                    <div class="alert alert-info">
                        <strong>QR Code for All Stations</strong><br>
                        Citizens will select their specific police station from the dropdown in the form.
                    </div>
                    
                    <div class="d-flex flex-column flex-md-row justify-content-center gap-3 mt-4 button-group">
                        <a href="feedback-form.jsp" class="btn btn-primary btn-lg">
                            <i class="fas fa-external-link-alt me-2"></i>Go to Feedback Form
                        </a>
                        <a href="index.jsp" class="btn btn-outline-secondary btn-lg">
                            <i class="fas fa-home me-2"></i>Back to Home
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Add interactive effects
            const qrImage = document.querySelector('.qr-code-image');
            const buttons = document.querySelectorAll('.btn');
            
            // QR code hover effect
            qrImage.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.08) rotate(3deg)';
            });
            
            qrImage.addEventListener('mouseleave', function() {
                this.style.transform = 'scale(1) rotate(0)';
            });
            
            // Button click animation
            buttons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    this.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                });
            });
            
            // Add floating animation to QR icon in title
            const qrIcon = document.querySelector('.fa-qrcode');
            setInterval(() => {
                qrIcon.classList.toggle('float');
            }, 3000);
            
            // Animate instruction items on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };
            
            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateX(0)';
                    }
                });
            }, observerOptions);
            
            document.querySelectorAll('.instruction-item').forEach(item => {
                observer.observe(item);
            });
        });
    </script>
</body>
</html>