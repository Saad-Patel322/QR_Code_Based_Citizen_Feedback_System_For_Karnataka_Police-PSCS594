<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="dao.FeedbackDAO, model.*, java.util.*" %>
<%
    // Check admin session
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    FeedbackDAO feedbackDAO = new FeedbackDAO();
    // Get stations with most negative feedback
    List<Object[]> negativeStations = feedbackDAO.getStationsWithMostNegativeFeedback();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alerts - Karnataka Police</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --police-blue: #1a365d;
            --police-light-blue: #2d74da;
            --negative-red: #ef4444;
            --warning-orange: #f59e0b;
        }
        
        .alert-header {
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .alert-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--negative-red);
        }
        
        .alert-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .alert-card.warning {
            border-left-color: var(--warning-orange);
        }
        
        .alert-count {
            font-size: 2rem;
            font-weight: bold;
            color: var(--negative-red);
        }
        
        .email-btn {
            background: linear-gradient(135deg, var(--police-blue), var(--police-light-blue));
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
            color: white;
            transition: all 0.3s ease;
        }
        
        .email-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(26, 54, 93, 0.3);
        }
        
        .priority-high {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            border-left: 4px solid #dc2626;
        }
        
        .priority-medium {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            border-left: 4px solid #d97706;
        }
        
        @keyframes pulseAlert {
            0% {
                box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.4);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(239, 68, 68, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(239, 68, 68, 0);
            }
        }
        
        .pulse {
            animation: pulseAlert 2s infinite;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Header -->
        <div class="alert-header">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="d-flex align-items-center">
                            <img src="images/police-logo.png" alt="Karnataka Police Logo" 
                                 style="height: 50px; margin-right: 15px; filter: brightness(0) invert(1);">
                            <div>
                                <h1 class="h3 mb-2">Karnataka State Police</h1>
                                <h2 class="h5 mb-0">Alert Management System</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="dashboard.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            <!-- Alert Summary -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card alert-card pulse">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h4 class="card-title text-danger">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        Negative Feedback Alert
                                    </h4>
                                    <p class="card-text mb-0">
                                        The following police stations have received significant negative feedback and require immediate attention.
                                    </p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <button class="btn email-btn" onclick="openGmail()">
                                        <i class="fas fa-envelope me-2"></i>Send Email Alert
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Negative Feedback Stations -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">
                                <i class="fas fa-list me-2"></i>
                                Stations with Most Negative Feedback
                            </h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Station Name</th>
                                            <th>Negative Feedback Count</th>
                                            <th>Total Feedback</th>
                                            <th>Negative Percentage</th>
                                            <th>Priority</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            int rank = 1;
                                            for(Object[] stationData : negativeStations) {
                                                String stationName = (String) stationData[0];
                                                Long negativeCount = (Long) stationData[1];
                                                Long totalCount = (Long) stationData[2];
                                                double percentage = totalCount > 0 ? (negativeCount.doubleValue() / totalCount.doubleValue()) * 100 : 0;
                                                String priority = percentage > 50 ? "High" : percentage > 25 ? "Medium" : "Low";
                                                String priorityClass = percentage > 50 ? "priority-high" : percentage > 25 ? "priority-medium" : "";
                                        %>
                                        <tr class="<%= priorityClass %>">
                                            <td><strong><%= stationName %></strong></td>
                                            <td>
                                                <span class="text-danger fw-bold"><%= negativeCount %></span>
                                            </td>
                                            <td><%= totalCount %></td>
                                            <td>
                                                <div class="progress" style="height: 8px;">
                                                    <div class="progress-bar bg-danger" 
                                                         style="width: <%= percentage %>%;"
                                                         role="progressbar">
                                                    </div>
                                                </div>
                                                <small class="text-muted"><%= String.format("%.1f", percentage) %>%</small>
                                            </td>
                                            <td>
                                                <span class="badge bg-<%= 
                                                    priority.equals("High") ? "danger" : 
                                                    priority.equals("Medium") ? "warning" : "secondary" 
                                                %>">
                                                    <%= priority %>
                                                </span>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary" 
                                                        onclick="viewStationDetails('<%= stationName %>')">
                                                    <i class="fas fa-eye me-1"></i>View
                                                </button>
                                            </td>
                                        </tr>
                                        <%
                                            rank++;
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Required Section -->
            <div class="row mt-4">
                <div class="col-md-6">
                    <div class="card alert-card warning">
                        <div class="card-body">
                            <h5 class="card-title text-warning">
                                <i class="fas fa-clock me-2"></i>
                                Immediate Actions Required
                            </h5>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    Review negative feedback comments
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    Contact station in-charge
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    Schedule performance review
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    Implement corrective measures
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="fas fa-chart-line me-2"></i>
                                Alert Statistics
                            </h5>
                            <div class="row text-center">
                                <div class="col-4">
                                    <div class="alert-count"><%= negativeStations.size() %></div>
                                    <small class="text-muted">Stations Alert</small>
                                </div>
                                <div class="col-4">
                                    <div class="alert-count text-warning">3</div>
                                    <small class="text-muted">High Priority</small>
                                </div>
                                <div class="col-4">
                                    <div class="alert-count text-info">24h</div>
                                    <small class="text-muted">Response Time</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openGmail() {
            const subject = "Urgent: Negative Feedback Alert - Karnataka Police";
            const body = "Dear Team,\n\nThis is an automated alert regarding police stations with significant negative feedback that requires immediate attention.\n\nPlease review the dashboard for detailed information.\n\nBest regards,\nKarnataka Police Admin System";
            
            const gmailUrl = 'https://mail.google.com/mail/u/0/#inbox';
            window.open(gmailUrl, '_blank');
        }

        function viewStationDetails(stationName) {
            alert('Viewing details for: ' + stationName + '\n\nThis would open a detailed view with all feedback for this station.');
        }

        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            const alertCards = document.querySelectorAll('.alert-card');
            alertCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 200);
            });
        });
    </script>
</body>
</html>