<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Karnataka Police Citizen Feedback System</title>
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
        
        .hero-section {
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            color: white;
            padding: 4rem 0;
            text-align: center;
            position: relative;
            overflow: hidden;
            animation: gradientShift 8s ease-in-out infinite;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%);
            animation: shimmer 3s infinite;
        }
        
        .feature-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            height: 100%;
            animation: fadeInUp 0.6s ease;
            position: relative;
            overflow: hidden;
        }
        
        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }
        
        .feature-card:hover::before {
            left: 100%;
        }
        
        .feature-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }
        
        .nav-brand {
            font-weight: bold;
            font-size: 1.5rem;
            animation: fadeIn 1s ease;
        }
        
        .btn-police {
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: bold;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .btn-police::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .btn-police:hover::before {
            left: 100%;
        }
        
        .btn-police:hover {
            background: linear-gradient(135deg, var(--police-light-blue), var(--police-blue));
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(45, 116, 218, 0.4);
        }
        
        .navbar {
            animation: slideDown 0.8s ease;
        }
        
        .process-step {
            animation: fadeInUp 0.8s ease;
        }
        
        .process-step .rounded-circle {
            transition: all 0.3s ease;
            animation: pulse 2s infinite;
        }
        
        .process-step:hover .rounded-circle {
            transform: scale(1.1);
            animation: none;
        }
        
        footer {
            animation: fadeIn 1.5s ease;
        }
        
        /* Animations */
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
        
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
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
        
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(45, 116, 218, 0.4);
            }
            70% {
                box-shadow: 0 0 0 15px rgba(45, 116, 218, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(45, 116, 218, 0);
            }
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }
        
        .hero-content {
            animation: fadeInUp 1s ease 0.2s both;
        }
        
        .hero-buttons {
            animation: fadeInUp 1s ease 0.4s both;
        }
        
        .feature-card:nth-child(1) { animation-delay: 0.1s; }
        .feature-card:nth-child(2) { animation-delay: 0.2s; }
        .feature-card:nth-child(3) { animation-delay: 0.3s; }
        
        .process-step:nth-child(1) { animation-delay: 0.1s; }
        .process-step:nth-child(2) { animation-delay: 0.2s; }
        .process-step:nth-child(3) { animation-delay: 0.3s; }
        .process-step:nth-child(4) { animation-delay: 0.4s; }
        
        .floating {
            animation: floating 3s ease-in-out infinite;
        }
        
        @keyframes floating {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }
        
        .icon-hover {
            transition: all 0.3s ease;
        }
        
        .feature-card:hover .icon-hover {
            transform: scale(1.2) rotate(5deg);
        }
        
        .stats-counter {
            font-size: 2.5rem;
            font-weight: bold;
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
              <img src="images/police-logo.png" alt="Karnataka Police Logo" 
                   style="height: 40px; margin-right: 10px;">
                       Karnataka Police</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="admin-login.jsp">
                    <i class="fas fa-sign-in-alt"></i> Admin Login
                </a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="hero-content">
                        <h1 class="display-4 mb-4 fw-bold floating">Karnataka Police Citizen Feedback Portal</h1>
                        <p class="lead mb-5 fs-5">Your feedback helps us serve you better and improve our services</p>
                    </div>
                    <div class="hero-buttons">
                        <div class="d-flex flex-column flex-md-row justify-content-center gap-3">
                            <a href="generate-qr.jsp" class="btn btn-light btn-lg px-4 py-3">
                                <i class="fas fa-qrcode me-2"></i> Scan QR Code
                            </a>
                            <a href="feedback-form.jsp" class="btn btn-outline-light btn-lg px-4 py-3">
                                <i class="fas fa-edit me-2"></i> Give Feedback Directly
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Features Section -->
    <div class="container my-5 py-5">
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card feature-card text-center p-4">
                    <div class="card-body">
                        <i class="fas fa-qrcode fa-3x text-primary mb-3 icon-hover"></i>
                        <h4 class="card-title">Quick QR Scan</h4>
                        <p class="card-text">Scan QR code at any police station to provide instant feedback on our services</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card text-center p-4">
                    <div class="card-body">
                        <i class="fas fa-chart-line fa-3x text-success mb-3 icon-hover"></i>
                        <h4 class="card-title">AI-Powered Analysis</h4>
                        <p class="card-text">Advanced sentiment analysis to understand and address citizen concerns effectively</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card text-center p-4">
                    <div class="card-body">
                        <i class="fas fa-bell fa-3x text-warning mb-3 icon-hover"></i>
                        <h4 class="card-title">Instant Alerts</h4>
                        <p class="card-text">Alerts for immediate action on critical feedback and suggestions</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

   
    <!-- Footer -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-2">&copy; 2025 Karnataka Police Department. All rights reserved.</p>
            <p class="mb-0">Designed to improve citizen-police engagement and service quality.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add scroll animations
        document.addEventListener('DOMContentLoaded', function() {
            // Animate elements on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);

            // Observe all feature cards and process steps
            document.querySelectorAll('.feature-card, .process-step').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(30px)';
                el.style.transition = 'all 0.6s ease';
                observer.observe(el);
            });

            // Add click animation to buttons
            document.querySelectorAll('.btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    this.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                });
            });
        });

        // Add floating effect to hero title
        function startFloatingAnimation() {
            const heroTitle = document.querySelector('.floating');
            setInterval(() => {
                heroTitle.style.animation = 'none';
                setTimeout(() => {
                    heroTitle.style.animation = 'floating 3s ease-in-out infinite';
                }, 10);
            }, 3000);
        }

        startFloatingAnimation();
    </script>
</body>
</html>