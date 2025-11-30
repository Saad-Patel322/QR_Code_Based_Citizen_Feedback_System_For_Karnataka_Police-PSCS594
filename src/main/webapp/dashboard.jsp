<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="dao.FeedbackDAO, model.*, java.util.*" %>
<%@ page import="util.DateUtils" %>
<%
    // Check admin session
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    FeedbackDAO feedbackDAO = new FeedbackDAO();
    int totalFeedback = feedbackDAO.getTotalFeedbackCount();
    int positiveFeedback = feedbackDAO.getPositiveFeedbackCount();
    int negativeFeedback = feedbackDAO.getNegativeFeedbackCount();
    int neutralFeedback = totalFeedback - positiveFeedback - negativeFeedback;
    List<Feedback> recentFeedback = feedbackDAO.getRecentFeedback(10);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Karnataka Police</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --police-blue: #1a365d;
            --police-light-blue: #2d74da;
            --positive-green: #10b981;
            --negative-red: #ef4444;
            --neutral-gray: #6b7280;
        }
        
        * {
            transition: all 0.3s ease;
        }
        
        .dashboard-header {
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            animation: slideDown 0.8s ease;
        }
        
        .metric-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            animation: fadeInUp 0.6s ease;
            position: relative;
            overflow: hidden;
        }
        
        .metric-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }
        
        .metric-card:hover::before {
            left: 100%;
        }
        
        .metric-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .metric-card.total { 
            border-left: 4px solid var(--police-blue);
            animation-delay: 0.1s;
        }
        .metric-card.positive { 
            border-left: 4px solid var(--positive-green);
            animation-delay: 0.2s;
        }
        .metric-card.negative { 
            border-left: 4px solid var(--negative-red);
            animation-delay: 0.3s;
        }
        
        .metric-value {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0;
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .metric-card.positive .metric-value {
            background: linear-gradient(135deg, var(--positive-green), #34d399);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .metric-card.negative .metric-value {
            background: linear-gradient(135deg, var(--negative-red), #f87171);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .metric-change.positive { color: var(--positive-green); }
        .metric-change.negative { color: var(--negative-red); }
        
        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
            height: 400px;
            animation: fadeInUp 0.8s ease;
            transition: transform 0.3s ease;
        }
        
        .chart-container:hover {
            transform: translateY(-5px);
        }
        
        .feedback-table {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            animation: fadeInUp 1s ease;
        }
        
        .sentiment-badge.positive { 
            background-color: var(--positive-green); 
            color: white;
            animation: pulse 2s infinite;
        }
        .sentiment-badge.negative { 
            background-color: var(--negative-red); 
            color: white;
        }
        .sentiment-badge.neutral { 
            background-color: var(--neutral-gray); 
            color: white;
        }
        
        .sidebar {
            background: linear-gradient(180deg, var(--police-blue), #2d3748);
            color: white;
            min-height: 100vh;
            box-shadow: 3px 0 15px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .sidebar::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 100%;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.03) 50%, transparent 70%);
            animation: shimmer 3s infinite;
        }
        
        .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            margin: 5px 0;
            border-radius: 8px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .nav-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        
        .nav-link:hover::before, .nav-link.active::before {
            left: 100%;
        }
        
        .nav-link:hover, .nav-link.active {
            background: rgba(255,255,255,0.15);
            color: white;
            transform: translateX(5px);
            box-shadow: 2px 2px 10px rgba(0,0,0,0.2);
        }
        
        .nav-link i {
            transition: transform 0.3s ease;
        }
        
        .nav-link:hover i {
            transform: scale(1.2);
        }
        
        .content-section {
            display: none;
            animation: fadeIn 0.5s ease;
        }
        
        .content-section.active {
            display: block;
        }
        
        .table-hover tbody tr {
            transition: all 0.3s ease;
        }
        
        .table-hover tbody tr:hover {
            background-color: rgba(26, 54, 93, 0.05);
            transform: scale(1.01);
        }
        
        .btn {
            transition: all 0.3s ease;
            border-radius: 8px;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
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
        
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.4);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(16, 185, 129, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(16, 185, 129, 0);
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
        
        .rating-stars {
            color: #ffc107;
            animation: twinkle 2s infinite;
        }
        
        @keyframes twinkle {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
        
        .profile-option, .logout-option {
            padding: 15px;
            margin: 10px 0;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .profile-option:hover, .logout-option:hover {
            background: rgba(255,255,255,0.2);
            transform: translateX(5px);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar p-0">
    <div class="p-4">
        <!-- Enhanced Logo Design -->
        <div class="text-center mb-4">
            <div class="logo-wrapper position-relative d-inline-block mb-3">
                <div class="logo-background" 
                     style="width: 70px; height: 70px; 
                            background: linear-gradient(135deg, rgba(255,255,255,0.2), rgba(255,255,255,0.1));
                            border-radius: 50%;
                            position: absolute;
                            top: 50%;
                            left: 50%;
                            transform: translate(-50%, -50%);
                            animation: pulseLogo 3s infinite;">
                </div>
                <img src="images/police-logo.png" alt="Police Logo" 
                     class="logo-img"
                     style="height: 50px; 
                            filter: brightness(0) invert(1) drop-shadow(0 2px 4px rgba(0,0,0,0.3));
                            position: relative;
                            z-index: 2;
                            transition: all 0.3s ease;">
            </div>
            <h5 class="text-white fw-bold mb-1" style="font-size: 1.1rem;">Police Admin</h5>
            <p class="text-white-50 small mb-0">Dashboard</p>
        </div>

        <nav class="nav flex-column">
            <a class="nav-link active" href="#" onclick="showSection('dashboard')">
                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
            </a>
            <a class="nav-link" href="#" onclick="showSection('allFeedback')">
                <i class="fas fa-comments me-2"></i>All Feedback
            </a>
            <a class="nav-link" href="#" onclick="showSection('analytics')">
                <i class="fas fa-chart-pie me-2"></i>Analytics
            </a>
            <a class="nav-link" href="alerts.jsp" target="_blank">
                <i class="fas fa-bell me-2"></i>Alerts
            </a>
            <a class="nav-link" href="#" onclick="showSection('settings')">
                <i class="fas fa-cog me-2"></i>Settings
            </a>
        </nav>
    </div>
</div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 ml-sm-auto">
                <!-- Header -->
                <div class="dashboard-header">
                    <div class="container-fluid">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <div class="d-flex align-items-center">
                                    <img src="images/police-logo.png" alt="Karnataka Police Logo" 
                                         style="height: 50px; margin-right: 15px; filter: brightness(0) invert(1);">
                                    <div>
                                        <h1 class="h3 mb-2">Karnataka State Police</h1>
                                        <h2 class="h5 mb-0">AI-Powered Citizen Feedback System</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 text-end">
                                <div class="btn-group">
                                    <button class="btn btn-outline-light btn-sm">Last Week</button>
                                    <button class="btn btn-outline-light btn-sm">Last Month</button>
                                    <button class="btn btn-light btn-sm">Last Quarter</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Dashboard Section -->
                <div id="dashboard" class="content-section active">
                    <div class="container-fluid mt-4">
                        <!-- Metrics Cards -->
                        <div class="row mb-4">
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="card metric-card total h-100">
                                    <div class="card-body">
                                        <h5 class="card-title text-muted">Total Feedback</h5>
                                        <h2 class="metric-value text-primary"><%= totalFeedback %></h2>
                                        <p class="metric-change positive">↑ 12% from last week</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="card metric-card positive h-100">
                                    <div class="card-body">
                                        <h5 class="card-title text-muted">Positive Feedback</h5>
                                        <h2 class="metric-value text-success"><%= positiveFeedback %></h2>
                                        <p class="metric-change positive">↑ 8% from last week</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="card metric-card negative h-100">
                                    <div class="card-body">
                                        <h5 class="card-title text-muted">Negative Feedback</h5>
                                        <h2 class="metric-value text-danger"><%= negativeFeedback %></h2>
                                        <p class="metric-change negative">↑ 5% from last week</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="card metric-card h-100">
                                    <div class="card-body">
                                        <h5 class="card-title text-muted">Avg. Response Time</h5>
                                        <h2 class="metric-value text-info">2.4h</h2>
                                        <p class="metric-change positive">↓ 15% from last week</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Charts Section -->
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <div class="chart-container">
                                    <h5>Feedback Trends</h5>
                                    <canvas id="trendsChart"></canvas>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="chart-container">
                                    <h5>Sentiment Distribution</h5>
                                    <canvas id="sentimentChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Feedback Table -->
                        <div class="row">
                            <div class="col-12">
                                <div class="feedback-table">
                                    <div class="card">
                                        <div class="card-header bg-white">
                                            <h5 class="mb-0">Recent Feedback</h5>
                                        </div>
                                        <div class="card-body p-0">
                                            <div class="table-responsive">
                                                <table class="table table-hover mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Date</th>
                                                            <th>Citizen</th>
                                                            <th>Station</th>
                                                            <th>Rating</th>
                                                            <th>Sentiment</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% for(Feedback feedback : recentFeedback) { %>
                                                        <tr>
                                                            <td><%= DateUtils.formatForDisplay(feedback.getSubmissionDate()) %></td>
                                                            <td><%= feedback.getEmail() %></td>
                                                            <td><%= feedback.getPoliceStation() %></td>
                                                            <td>
                                                                <span class="rating-stars">
                                                                    <%
                                                                        int rating = feedback.getRating();
                                                                        for(int i=1; i<=5; i++) {
                                                                            if(i <= rating) {
                                                                    %>
                                                                        ★
                                                                    <% } else { %>
                                                                        ☆
                                                                    <% }} %>
                                                                </span>
                                                                (<%= rating %>/5)
                                                            </td>
                                                            <td>
                                                                <span class="badge sentiment-badge <%= feedback.getSentiment().toLowerCase() %>">
                                                                    <%= feedback.getSentiment() %>
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <button class="btn btn-sm btn-outline-primary">View</button>
                                                            </td>
                                                        </tr>
                                                        <% } %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- All Feedback Section -->
                <div id="allFeedback" class="content-section">
                    <div class="container-fluid mt-4">
                        <div class="row">
                            <div class="col-12">
                                <div class="feedback-table">
                                    <div class="card">
                                        <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0">All Feedback</h5>
                                            
                                        </div>
                                        <div class="card-body p-0">
                                            <div class="table-responsive">
                                                <table class="table table-hover mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Date</th>
                                                            <th>Citizen</th>
                                                            <th>Station</th>
                                                            <th>Rating</th>
                                                            <th>Sentiment</th>
                                                            <th>Message</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% for(Feedback feedback : recentFeedback) { %>
                                                        <tr>
                                                            <td><%= DateUtils.formatForDisplay(feedback.getSubmissionDate()) %></td>
                                                            <td><%= feedback.getEmail() %></td>
                                                            <td><%= feedback.getPoliceStation() %></td>
                                                            <td>
                                                                <span class="rating-stars">
                                                                    <%
                                                                        int rating = feedback.getRating();
                                                                        for(int i=1; i<=5; i++) {
                                                                            if(i <= rating) {
                                                                    %>
                                                                        ★
                                                                    <% } else { %>
                                                                        ☆
                                                                    <% }} %>
                                                                </span>
                                                                (<%= rating %>/5)
                                                            </td>
                                                            <td>
                                                                <span class="badge sentiment-badge <%= feedback.getSentiment().toLowerCase() %>">
                                                                    <%= feedback.getSentiment() %>
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <span class="text-truncate" style="max-width: 200px; display: inline-block;">
                                                                    <%= feedback.getFeedbackText() != null ? feedback.getFeedbackText() : "No message" %>
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <button class="btn btn-sm btn-outline-primary">View Details</button>
                                                            </td>
                                                        </tr>
                                                        <% } %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Analytics Section -->
<div id="analytics" class="content-section">
    <div class="container-fluid mt-4">
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="chart-container">
                    <h5>Feedback Trends Over Time</h5>
                    <canvas id="analyticsTrendsChart"></canvas>
                </div>
            </div>
            <div class="col-md-4">
                <div class="chart-container">
                    <h5>Sentiment Distribution</h5>
                    <canvas id="analyticsSentimentChart"></canvas>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="chart-container">
                    <h5>Rating Distribution</h5>
                    <canvas id="ratingChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

               <!-- Settings Section -->
<!-- Settings Section -->
<div id="settings" class="content-section">
    <div class="container-fluid mt-4">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">Settings</h5>
                    </div>
                    <div class="card-body">
                        <!-- Profile Option - Click to open profile page -->
                        <div class="profile-option" onclick="openProfilePage()">
                            <div class="d-flex align-items-center">
                                <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" 
                                     style="width: 50px; height: 50px;">
                                    <i class="fas fa-user fa-lg"></i>
                                </div>
                                <div class="ms-3">
                                    <h6 class="mb-1">Profile</h6>
                                    <p class="text-muted mb-0">View your profile information</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Logout Option with same functionality as sidebar -->
                        <a class="logout-option" href="adminLogin" style="text-decoration: none; color: inherit;">
                            <div class="d-flex align-items-center">
                                <div class="rounded-circle bg-danger text-white d-flex align-items-center justify-content-center" 
                                     style="width: 50px; height: 50px;">
                                    <i class="fas fa-sign-out-alt fa-lg"></i>
                                </div>
                                <div class="ms-3">
                                    <h6 class="mb-1">Logout</h6>
                                    <p class="text-muted mb-0">Sign out from your account</p>
                                </div>
                            </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

    <script>
        // Section Navigation
        function showSection(sectionId) {
            // Hide all sections
            document.querySelectorAll('.content-section').forEach(section => {
                section.classList.remove('active');
            });
            
            // Show selected section
            document.getElementById(sectionId).classList.add('active');
            
            // Update active nav link
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
            });
            event.target.classList.add('active');
        }

        // Charts for Dashboard
        const trendsCtx = document.getElementById('trendsChart').getContext('2d');
        const trendsChart = new Chart(trendsCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Positive Feedback',
                    data: [65, 59, 80, 81, 56, 72],
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    fill: true,
                    tension: 0.4
                }, {
                    label: 'Negative Feedback',
                    data: [28, 48, 40, 19, 36, 27],
                    borderColor: '#ef4444',
                    backgroundColor: 'rgba(239, 68, 68, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    }
                }
            }
        });

        const sentimentCtx = document.getElementById('sentimentChart').getContext('2d');
        const sentimentChart = new Chart(sentimentCtx, {
            type: 'doughnut',
            data: {
                labels: ['Positive', 'Negative', 'Neutral'],
                datasets: [{
                    data: [<%= positiveFeedback %>, <%= negativeFeedback %>, <%= neutralFeedback %>],
                    backgroundColor: ['#10b981', '#ef4444', '#6b7280'],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                    }
                }
            }
        });

        // Analytics Charts
        const analyticsTrendsCtx = document.getElementById('analyticsTrendsChart').getContext('2d');
        const analyticsTrendsChart = new Chart(analyticsTrendsCtx, {
            type: 'line',
            data: {
                labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                datasets: [{
                    label: 'Positive',
                    data: [45, 52, 48, 60],
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    fill: true,
                    tension: 0.4
                }, {
                    label: 'Negative',
                    data: [15, 18, 22, 16],
                    borderColor: '#ef4444',
                    backgroundColor: 'rgba(239, 68, 68, 0.1)',
                    fill: true,
                    tension: 0.4
                }, {
                    label: 'Neutral',
                    data: [20, 25, 22, 24],
                    borderColor: '#6b7280',
                    backgroundColor: 'rgba(107, 114, 128, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    }
                }
            }
        });

        const analyticsSentimentCtx = document.getElementById('analyticsSentimentChart').getContext('2d');
        const analyticsSentimentChart = new Chart(analyticsSentimentCtx, {
            type: 'pie',
            data: {
                labels: ['Positive', 'Negative', 'Neutral'],
                datasets: [{
                    data: [<%= positiveFeedback %>, <%= negativeFeedback %>, <%= neutralFeedback %>],
                    backgroundColor: ['#10b981', '#ef4444', '#6b7280'],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                    }
                }
            }
        });


        const ratingCtx = document.getElementById('ratingChart').getContext('2d');
        const ratingChart = new Chart(ratingCtx, {
            type: 'bar',
            data: {
                labels: ['1 Star', '2 Stars', '3 Stars', '4 Stars', '5 Stars'],
                datasets: [{
                    label: 'Number of Ratings',
                    data: [5, 12, 25, 45, 63],
                    backgroundColor: [
                        '#ef4444',
                        '#f97316',
                        '#eab308',
                        '#84cc16',
                        '#10b981'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });

        function showProfile() {
            alert('Profile section would open here');
        }

        function logout() {
            if(confirm('Are you sure you want to logout?')) {
                window.location.href = 'adminLogin';
            }
        }

        // Add some interactive animations
        document.addEventListener('DOMContentLoaded', function() {
            // Animate metrics cards on load
            const cards = document.querySelectorAll('.metric-card');
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '1';
                }, index * 200);
            });
        });
     // Function to open profile page
        function openProfilePage() {
            // Option 1: Redirect to profile.jsp
            window.location.href = 'profile.jsp';
            
            // Option 2: Open in new tab (uncomment if preferred)
            // window.open('profile.jsp', '_blank');
        }

        // Function to logout
        function logout() {
            if(confirm('Are you sure you want to logout?')) {
                window.location.href = 'adminLogin';
            }
        }

        // Function to show profile (if you want modal instead of page)
        function showProfile() {
            // If you want to show profile in modal instead of separate page
            // You can implement a modal here
            alert('Opening profile page...');
            openProfilePage(); // Fallback to page redirect
        }
    </script>
</body>
</html>