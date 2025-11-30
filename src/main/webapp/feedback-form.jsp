<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="dao.PoliceStationDAO,model.PoliceStation, java.util.*" %>
<%
    // Load all police stations for the dropdown
    PoliceStationDAO stationDAO = new PoliceStationDAO();
    List<PoliceStation> allStations = stationDAO.getAllPoliceStations();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citizen Feedback Form - Karnataka Police</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .form-header {
            background: linear-gradient(135deg, #1a365d, #2d74da);
            color: white;
            padding: 2.5rem;
            text-align: center;
        }
        .form-body {
            padding: 2.5rem;
        }
        .rating-star {
            cursor: pointer;
            font-size: 2.5rem;
            color: #ddd;
            transition: color 0.2s ease;
            margin: 0 5px;
        }
        .rating-star:hover,
        .rating-star.selected {
            color: #ffc107;
        }
        .feedback-box {
            display: none;
        }
        .required::after {
            content: " *";
            color: #dc3545;
        }
        .form-control:focus {
            border-color: #2d74da;
            box-shadow: 0 0 0 0.2rem rgba(45, 116, 218, 0.25);
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
                <a class="nav-link" href="generate-qr.jsp">
                    <i class="fas fa-qrcode"></i> QR Code
                </a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="form-container">
                    <!-- Header -->
                    <div class="form-header">
                        <h1 class="h3 mb-2">Karnataka Police Citizen Feedback Portal</h1>
                        <p class="mb-0 opacity-75">Your feedback helps us serve you better and improve our services</p>
                    </div>

                    <!-- Feedback Form -->
                    <div class="form-body">
                        <h4 class="mb-4 text-center">Citizen Feedback Form</h4>
                        
                        <form action="submitFeedback" method="post" id="feedbackForm">
                            <!-- Personal Information -->
                            <div class="row mb-4">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label required">Full Name</label>
                                    <input type="text" class="form-control form-control-lg" id="name" name="name" 
                                           placeholder="Enter your full name" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label required">Email Address</label>
                                    <input type="email" class="form-control form-control-lg" id="email" name="email" 
                                           placeholder="Enter your email address" required>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label required">Phone Number</label>
                                    <input type="tel" class="form-control form-control-lg" id="phone" name="phone" 
                                           placeholder="Enter your 10-digit phone number" required>
                                </div>
                                <!-- <div class="col-md-6 mb-3">
                                    <label class="form-label">Submit Anonymously</label>
                                    <div class="form-check form-switch mt-2">
                                        <input class="form-check-input" type="checkbox" id="anonymous" name="anonymous">
                                        <label class="form-check-label" for="anonymous">
                                            Hide my personal information from station view
                                        </label>
                                    </div>
                                </div>
                            </div> -->

                            <!-- Police Station Selection -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <label for="policeStation" class="form-label required">Select Police Station</label>
                                    <select class="form-select form-select-lg" id="policeStation" name="policeStation" required>
                                        <option value="">Choose your police station...</option>
                                        <% for (PoliceStation station : allStations) { %>
                                            <option value="<%= station.getStationId() %>">
                                                <%= station.getStationName() %> - <%= station.getDistrictName() %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                            </div>

                            <!-- Star Rating -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <label class="form-label required">Rate Your Experience</label>
                                    <div class="text-center my-3">
                                        <div class="rating" id="ratingStars">
                                            <span class="rating-star" data-rating="1">★</span>
                                            <span class="rating-star" data-rating="2">★</span>
                                            <span class="rating-star" data-rating="3">★</span>
                                            <span class="rating-star" data-rating="4">★</span>
                                            <span class="rating-star" data-rating="5">★</span>
                                        </div>
                                        <input type="hidden" id="rating" name="rating" required>
                                        <div class="text-muted mt-2">
                                            <small>1 Star (Poor) - 5 Stars (Excellent)</small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Feedback Text -->
                            <div class="row mb-4 feedback-box" id="feedbackSection">
                                <div class="col-12">
                                    <label for="feedbackText" class="form-label required">Your Feedback</label>
                                    <textarea class="form-control form-control-lg" id="feedbackText" name="feedbackText" 
                                              rows="5" placeholder="Please share details of your experience with Karnataka Police" 
                                              required></textarea>
                                </div>
                            </div>

                            <!-- Suggestions -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <label for="suggestion" class="form-label">Suggestions for Improvement</label>
                                    <textarea class="form-control form-control-lg" id="suggestion" name="suggestion" 
                                              rows="3" placeholder="Any suggestions for how we can improve our services"></textarea>
                                </div>
                            </div>

                            <!-- Submit Button -->
                            <div class="row">
                                <div class="col-12">
                                    <button type="submit" class="btn btn-primary btn-lg w-100 py-3">
                                        <i class="fas fa-paper-plane me-2"></i>Submit Feedback
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Quick Links -->
                <div class="text-center mt-4">
                    <a href="generate-qr.jsp" class="btn btn-outline-primary me-2">
                        <i class="fas fa-qrcode me-1"></i>QR Code
                    </a>
                    <a href="index.jsp" class="btn btn-outline-secondary">
                        <i class="fas fa-home me-1"></i>Back to Home
                    </a>
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
        // Star Rating System
        document.querySelectorAll('.rating-star').forEach(star => {
            star.addEventListener('click', function() {
                const rating = this.getAttribute('data-rating');
                document.getElementById('rating').value = rating;
                
                // Update star colors
                document.querySelectorAll('.rating-star').forEach(s => {
                    s.classList.remove('selected');
                    if (s.getAttribute('data-rating') <= rating) {
                        s.classList.add('selected');
                    }
                });
                
                // Show feedback textbox
                document.getElementById('feedbackSection').style.display = 'block';
            });
        });

        // Anonymous checkbox
        document.getElementById('anonymous').addEventListener('change', function() {
            if (this.checked) {
                document.getElementById('name').value = 'Anonymous';
                document.getElementById('email').value = 'anonymous@feedback.com';
                document.getElementById('phone').value = '0000000000';
                document.getElementById('name').disabled = true;
                document.getElementById('email').disabled = true;
                document.getElementById('phone').disabled = true;
            } else {
                document.getElementById('name').disabled = false;
                document.getElementById('email').disabled = false;
                document.getElementById('phone').disabled = false;
                document.getElementById('name').value = '';
                document.getElementById('email').value = '';
                document.getElementById('phone').value = '';
            }
        });

        // Form validation
        document.getElementById('feedbackForm').addEventListener('submit', function(e) {
            const rating = document.getElementById('rating').value;
            if (!rating) {
                e.preventDefault();
                alert('Please provide a rating by clicking on the stars');
                return false;
            }
        });
    </script>
</body>
</html>