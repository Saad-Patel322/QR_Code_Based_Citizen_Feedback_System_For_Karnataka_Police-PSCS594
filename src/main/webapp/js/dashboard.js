/**
 * Karnataka Police Feedback System - Dashboard JavaScript
 * Interactive features for the admin dashboard
 */

class DashboardManager {
    constructor() {
        this.currentFilter = 'lastQuarter';
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.setupCharts();
        this.setupRealTimeUpdates();
        this.setupFilters();
    }

    setupEventListeners() {
        // Filter buttons
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', (e) => this.handleFilterChange(e));
        });

        // Search functionality
        const searchInput = document.getElementById('feedbackSearch');
        if (searchInput) {
            searchInput.addEventListener('input', (e) => this.handleSearch(e));
        }

        // View feedback details
        document.querySelectorAll('.view-feedback-btn').forEach(btn => {
            btn.addEventListener('click', (e) => this.viewFeedbackDetails(e));
        });

        // Export buttons
        document.querySelectorAll('.export-btn').forEach(btn => {
            btn.addEventListener('click', (e) => this.exportData(e));
        });

        // Refresh data
        const refreshBtn = document.getElementById('refreshData');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => this.refreshDashboard());
        }
    }

    setupCharts() {
        this.initializeTrendsChart();
        this.initializeSentimentChart();
        this.initializeStationPerformanceChart();
        this.initializeCategoryDistributionChart();
    }

    initializeTrendsChart() {
        const ctx = document.getElementById('trendsChart');
        if (!ctx) return;

        this.trendsChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: this.getLastMonths(6),
                datasets: [{
                    label: 'Positive Feedback',
                    data: [65, 59, 80, 81, 76, 85],
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    fill: true,
                    tension: 0.4,
                    borderWidth: 3
                }, {
                    label: 'Negative Feedback',
                    data: [28, 48, 40, 29, 36, 27],
                    borderColor: '#ef4444',
                    backgroundColor: 'rgba(239, 68, 68, 0.1)',
                    fill: true,
                    tension: 0.4,
                    borderWidth: 3
                }, {
                    label: 'Total Feedback',
                    data: [93, 107, 120, 110, 112, 112],
                    borderColor: '#3b82f6',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    fill: true,
                    tension: 0.4,
                    borderWidth: 2,
                    borderDash: [5, 5]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            usePointStyle: true,
                            padding: 20
                        }
                    },
                    tooltip: {
                        mode: 'index',
                        intersect: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            drawBorder: false
                        },
                        ticks: {
                            callback: function(value) {
                                return value;
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                },
                interaction: {
                    mode: 'nearest',
                    axis: 'x',
                    intersect: false
                }
            }
        });
    }

    initializeSentimentChart() {
        const ctx = document.getElementById('sentimentChart');
        if (!ctx) return;

        this.sentimentChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Positive', 'Negative', 'Neutral'],
                datasets: [{
                    data: [68, 22, 10],
                    backgroundColor: [
                        '#10b981',
                        '#ef4444',
                        '#6b7280'
                    ],
                    borderWidth: 3,
                    borderColor: '#ffffff',
                    hoverOffset: 15
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.parsed;
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = Math.round((value / total) * 100);
                                return `${label}: ${value} (${percentage}%)`;
                            }
                        }
                    }
                }
            }
        });
    }

    initializeStationPerformanceChart() {
        const ctx = document.getElementById('stationPerformanceChart');
        if (!ctx) return;

        // This would be dynamically loaded from server
        const stationData = {
            labels: ['Cubbon Park', 'Shivajinagar', 'Whitefield', 'Jayanagar', 'KR Puram'],
            datasets: [{
                label: 'Average Rating',
                data: [4.2, 3.8, 4.5, 4.1, 3.9],
                backgroundColor: 'rgba(59, 130, 246, 0.8)',
                borderColor: '#3b82f6',
                borderWidth: 2
            }]
        };

        this.stationChart = new Chart(ctx, {
            type: 'bar',
            data: stationData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 5,
                        ticks: {
                            callback: function(value) {
                                return value + '★';
                            }
                        }
                    }
                }
            }
        });
    }

    initializeCategoryDistributionChart() {
        const ctx = document.getElementById('categoryChart');
        if (!ctx) return;

        this.categoryChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['Behavior', 'Timeliness', 'Infrastructure', 'Transparency', 'Other'],
                datasets: [{
                    data: [35, 25, 15, 12, 13],
                    backgroundColor: [
                        '#3b82f6',
                        '#10b981',
                        '#f59e0b',
                        '#ef4444',
                        '#6b7280'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right'
                    }
                }
            }
        });
    }

    handleFilterChange(e) {
        const filter = e.target.textContent.toLowerCase();
        this.currentFilter = filter;
        
        // Update active button
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.classList.remove('active', 'btn-light');
            btn.classList.add('btn-outline-light');
        });
        e.target.classList.add('active', 'btn-light');
        e.target.classList.remove('btn-outline-light');

        // Update charts with filtered data
        this.updateChartsWithFilter(filter);
        
        // Show loading state
        this.showLoading('Updating dashboard...');
    }

    updateChartsWithFilter(filter) {
        // Simulate API call to get filtered data
        setTimeout(() => {
            const mockData = this.generateMockData(filter);
            
            // Update trends chart
            if (this.trendsChart) {
                this.trendsChart.data.labels = mockData.trends.labels;
                this.trendsChart.data.datasets[0].data = mockData.trends.positive;
                this.trendsChart.data.datasets[1].data = mockData.trends.negative;
                this.trendsChart.update();
            }

            // Update sentiment chart
            if (this.sentimentChart) {
                this.sentimentChart.data.datasets[0].data = mockData.sentiment;
                this.sentimentChart.update();
            }

            this.hideLoading();
        }, 1000);
    }

    generateMockData(filter) {
        // Generate different data based on filter
        const baseData = {
            lastWeek: { positive: 85, negative: 15, neutral: 10 },
            lastMonth: { positive: 320, negative: 80, neutral: 50 },
            lastQuarter: { positive: 950, negative: 250, neutral: 150 }
        };

        const selectedData = baseData[this.currentFilter] || baseData.lastQuarter;

        return {
            trends: {
                labels: this.getLastMonths(6),
                positive: [65, 70, 75, 80, 78, selectedData.positive / 10],
                negative: [28, 25, 22, 20, 18, selectedData.negative / 10]
            },
            sentiment: [selectedData.positive, selectedData.negative, selectedData.neutral]
        };
    }

    getLastMonths(count) {
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        const currentMonth = new Date().getMonth();
        return Array.from({ length: count }, (_, i) => {
            const monthIndex = (currentMonth - count + i + 12) % 12;
            return months[monthIndex];
        });
    }

    handleSearch(e) {
        const searchTerm = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#feedbackTable tbody tr');

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    viewFeedbackDetails(e) {
        const feedbackId = e.target.getAttribute('data-feedback-id');
        
        // Simulate API call to get feedback details
        this.showLoading('Loading feedback details...');
        
        setTimeout(() => {
            this.showFeedbackModal(this.generateMockFeedbackDetails(feedbackId));
            this.hideLoading();
        }, 500);
    }

    showFeedbackModal(feedback) {
        // Create or update modal with feedback details
        let modal = document.getElementById('feedbackModal');
        if (!modal) {
            modal = this.createFeedbackModal();
        }

        // Populate modal with data
        modal.querySelector('#feedbackEmail').textContent = feedback.email;
        modal.querySelector('#feedbackStation').textContent = feedback.station;
        modal.querySelector('#feedbackRating').innerHTML = '★'.repeat(feedback.rating) + '☆'.repeat(5 - feedback.rating);
        modal.querySelector('#feedbackSentiment').textContent = feedback.sentiment;
        modal.querySelector('#feedbackCategory').textContent = feedback.category;
        modal.querySelector('#feedbackText').textContent = feedback.text;
        modal.querySelector('#feedbackDate').textContent = feedback.date;

        // Show modal
        const bootstrapModal = new bootstrap.Modal(modal);
        bootstrapModal.show();
    }

    createFeedbackModal() {
        const modalHTML = `
            <div class="modal fade" id="feedbackModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Feedback Details</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Email:</strong> <span id="feedbackEmail"></span></p>
                                    <p><strong>Station:</strong> <span id="feedbackStation"></span></p>
                                    <p><strong>Rating:</strong> <span id="feedbackRating"></span></p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Sentiment:</strong> <span id="feedbackSentiment"></span></p>
                                    <p><strong>Category:</strong> <span id="feedbackCategory"></span></p>
                                    <p><strong>Date:</strong> <span id="feedbackDate"></span></p>
                                </div>
                            </div>
                            <div class="mt-3">
                                <strong>Feedback Text:</strong>
                                <div class="border rounded p-3 mt-2 bg-light">
                                    <p id="feedbackText" class="mb-0"></p>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-primary">Mark as Reviewed</button>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHTML);
        return document.getElementById('feedbackModal');
    }

    generateMockFeedbackDetails(id) {
        return {
            email: `citizen${id}@email.com`,
            station: 'Sample Police Station',
            rating: Math.floor(Math.random() * 5) + 1,
            sentiment: ['Positive', 'Negative', 'Neutral'][Math.floor(Math.random() * 3)],
            category: ['Behavior', 'Timeliness', 'Infrastructure'][Math.floor(Math.random() * 3)],
            text: 'This is a sample feedback text describing the citizen experience with the police station services.',
            date: new Date().toLocaleDateString()
        };
    }

    exportData(e) {
        const format = e.target.getAttribute('data-format');
        this.showLoading(`Exporting data as ${format.toUpperCase()}...`);

        // Simulate export process
        setTimeout(() => {
            this.showToast(`Data exported successfully as ${format.toUpperCase()}`, 'success');
            this.hideLoading();
        }, 2000);
    }

    refreshDashboard() {
        this.showLoading('Refreshing dashboard data...');
        
        // Simulate API call to refresh data
        setTimeout(() => {
            this.updateMetrics();
            this.trendsChart.update();
            this.sentimentChart.update();
            this.hideLoading();
            this.showToast('Dashboard updated successfully', 'success');
        }, 1500);
    }

    updateMetrics() {
        // Update metric cards with new data
        const metrics = {
            totalFeedback: Math.floor(Math.random() * 100) + 1200,
            positiveFeedback: Math.floor(Math.random() * 50) + 800,
            negativeFeedback: Math.floor(Math.random() * 20) + 250
        };

        Object.keys(metrics).forEach(key => {
            const element = document.querySelector(`[data-metric="${key}"]`);
            if (element) {
                this.animateValue(element, parseInt(element.textContent), metrics[key], 1000);
            }
        });
    }

    animateValue(element, start, end, duration) {
        const range = end - start;
        const startTime = performance.now();

        function updateValue(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            
            const value = Math.floor(start + (range * progress));
            element.textContent = value.toLocaleString();

            if (progress < 1) {
                requestAnimationFrame(updateValue);
            }
        }

        requestAnimationFrame(updateValue);
    }

    setupRealTimeUpdates() {
        // Simulate real-time updates every 30 seconds
        setInterval(() => {
            this.updateMetrics();
        }, 30000);
    }

    setupFilters() {
        // Initialize any additional filters
        const stationFilter = document.getElementById('stationFilter');
        if (stationFilter) {
            stationFilter.addEventListener('change', (e) => this.filterByStation(e.target.value));
        }

        const sentimentFilter = document.getElementById('sentimentFilter');
        if (sentimentFilter) {
            sentimentFilter.addEventListener('change', (e) => this.filterBySentiment(e.target.value));
        }
    }

    filterByStation(stationId) {
        // Filter table by station
        const rows = document.querySelectorAll('#feedbackTable tbody tr');
        rows.forEach(row => {
            const rowStation = row.getAttribute('data-station');
            if (!stationId || rowStation === stationId) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    filterBySentiment(sentiment) {
        // Filter table by sentiment
        const rows = document.querySelectorAll('#feedbackTable tbody tr');
        rows.forEach(row => {
            const rowSentiment = row.getAttribute('data-sentiment');
            if (!sentiment || rowSentiment === sentiment) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    showLoading(message = 'Loading...') {
        // Create or show loading overlay
        let loading = document.getElementById('dashboardLoading');
        if (!loading) {
            loading = document.createElement('div');
            loading.id = 'dashboardLoading';
            loading.className = 'loading-overlay';
            loading.innerHTML = `
                <div class="loading-spinner">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">${message}</p>
                </div>
            `;
            document.body.appendChild(loading);

            // Add styles
            const styles = `
                .loading-overlay {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(255,255,255,0.9);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 9999;
                }
                .loading-spinner {
                    text-align: center;
                }
            `;
            const styleSheet = document.createElement('style');
            styleSheet.textContent = styles;
            document.head.appendChild(styleSheet);
        }
        loading.style.display = 'flex';
    }

    hideLoading() {
        const loading = document.getElementById('dashboardLoading');
        if (loading) {
            loading.style.display = 'none';
        }
    }

    showToast(message, type = 'info') {
        // Use Bootstrap toasts if available, otherwise create simple alert
        const toast = document.createElement('div');
        toast.className = `alert alert-${type} alert-dismissible fade show`;
        toast.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
        `;
        
        toast.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        document.body.appendChild(toast);
        
        setTimeout(() => {
            if (toast.parentNode) {
                toast.remove();
            }
        }, 5000);
    }
}

// Initialize dashboard when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    const dashboard = new DashboardManager();
    
    // Make dashboard globally available for debugging
    window.dashboard = dashboard;
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = DashboardManager;
}