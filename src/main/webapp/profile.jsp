<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
    // Check admin session
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get admin details from session (you can replace with actual database data)
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        adminName = "Police Administrator";
    }
    
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        adminEmail = "admin@karnatakapolice.gov.in";
    }
    
    String adminRole = (String) session.getAttribute("adminRole");
    if (adminRole == null) {
        adminRole = "System Administrator";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Karnataka Police</title>
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
        
        .profile-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 2rem 0;
        }
        
        .profile-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            overflow: hidden;
            animation: slideUp 0.8s ease;
            position: relative;
        }
        
        .profile-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(45, 116, 218, 0.05), transparent);
            transition: left 0.6s ease;
        }
        
        .profile-card:hover::before {
            left: 100%;
        }
        
        .profile-header {
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            color: white;
            padding: 3rem 2rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .profile-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%);
            animation: shimmer 3s infinite;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #fff, #e3f2fd);
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 4px solid white;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            animation: bounceIn 1s ease, float 4s ease-in-out infinite;
            position: relative;
            z-index: 2;
        }
        
        .profile-avatar::before {
            content: '';
            position: absolute;
            top: -5px;
            left: -5px;
            right: -5px;
            bottom: -5px;
            border: 2px solid transparent;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue), #10b981);
            background-size: 400% 400%;
            animation: gradientRotate 3s ease infinite;
            z-index: -1;
        }
        
        .avatar-icon {
            font-size: 3rem;
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .profile-body {
            padding: 2.5rem;
        }
        
        .info-card {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--police-blue);
            animation: fadeInUp 0.6s ease;
            transition: all 0.3s ease;
        }
        
        .info-card:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin: 2rem 0;
        }
        
        .stat-item {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            animation: fadeInUp 0.6s ease;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        
        .stat-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }
        
        .btn-profile {
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .btn-profile::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .btn-profile:hover::before {
            left: 100%;
        }
        
        .btn-profile:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(45, 116, 218, 0.4);
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
        
        .info-card:nth-child(1) { animation-delay: 0.1s; }
        .info-card:nth-child(2) { animation-delay: 0.2s; }
        .info-card:nth-child(3) { animation-delay: 0.3s; }
        
        .stat-item:nth-child(1) { animation-delay: 0.4s; }
        .stat-item:nth-child(2) { animation-delay: 0.5s; }
        .stat-item:nth-child(3) { animation-delay: 0.6s; }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="dashboard.jsp">
                <img src="images/police-logo.png" alt="Karnataka Police Logo" 
                     style="height: 40px; margin-right: 10px;">
                Karnataka Police
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="dashboard.jsp">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>
        </div>
    </nav>

    <div class="profile-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="profile-card">
                        <!-- Profile Header -->
                        <div class="profile-header">
                            <div class="profile-avatar">
                                <i class="fas fa-user-shield avatar-icon"></i>
                            </div>
                            <h2 class="mb-2 fw-bold"><%= adminName %></h2>
                            <p class="mb-0 opacity-75"><%= adminRole %></p>
                        </div>
                        
                        <!-- Profile Body -->
                        <div class="profile-body">
                            <!-- Personal Information -->
                            <div class="info-card">
                                <h5 class="mb-3 text-primary">
                                    <i class="fas fa-id-card me-2"></i>Personal Information
                                </h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small mb-1">Full Name</label>
                                        <p class="mb-0 fw-semibold"><%= adminName %></p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small mb-1">Email Address</label>
                                        <p class="mb-0 fw-semibold"><%= adminEmail %></p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small mb-1">Role</label>
                                        <p class="mb-0 fw-semibold"><%= adminRole %></p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small mb-1">Department</label>
                                        <p class="mb-0 fw-semibold">Karnataka State Police</p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Activity Stats -->
                            <h5 class="mb-3 text-primary">
                                <i class="fas fa-chart-bar me-2"></i>Activity Overview
                            </h5>
                            <div class="stats-grid">
                                <div class="stat-item">
                                    <div class="stat-label text-muted">Feedback Reviewed</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-label text-muted">Alerts Handled</div>
                                </div>
                                <div class="stat-item">                                
                                    <div class="stat-label text-muted">Response Rate</div>
                                </div>
                            </div>
                            
                            <!-- System Information -->
                            <div class="info-card">
                                <h5 class="mb-3 text-primary">
                                    <i class="fas fa-cog me-2"></i>System Information
                                </h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small mb-1">Last Login</label>
                                        <p class="mb-0 fw-semibold">
                                            <i class="fas fa-clock me-2 text-success"></i>
                                            <%= new java.text.SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a").format(new java.util.Date()) %>
                                        </p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small mb-1">Account Status</label>
                                        <p class="mb-0 fw-semibold">
                                            <i class="fas fa-check-circle me-2 text-success"></i>
                                            Active
                                        </p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small mb-1">Member Since</label>
                                        <p class="mb-0 fw-semibold">oct 2025</p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small mb-1">Security Level</label>
                                        <p class="mb-0 fw-semibold">
                                            <i class="fas fa-shield-alt me-2 text-warning"></i>
                                            Administrator
                                        </p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="d-flex flex-column flex-md-row justify-content-center gap-3 mt-4">
                                <a href="dashboard.jsp" class="btn btn-outline-secondary">
                                    <i class="fas fa-tachometer-alt me-2"></i>Back to Dashboard
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Add interactive effects
            const statItems = document.querySelectorAll('.stat-item');
            const infoCards = document.querySelectorAll('.info-card');
            
            // Add hover effects
            statItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                });
                
                item.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
            
            // Add click animations to buttons
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(btn => {
                btn.addEventListener('click', function() {
                    this.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                });
            });
            
            // Floating animation for avatar
            const avatar = document.querySelector('.profile-avatar');
            setInterval(() => {
                avatar.style.animation = 'none';
                setTimeout(() => {
                    avatar.style.animation = 'float 4s ease-in-out infinite, bounceIn 1s ease';
                }, 10);
            }, 4000);
        });
    </script>
</body>
</html>