/**
 * Karnataka Police Feedback System - Form Validation
 * Client-side validation for feedback form
 */

class FormValidator {
    constructor() {
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.setupRealTimeValidation();
    }

    setupEventListeners() {
        const form = document.getElementById('feedbackForm');
        if (form) {
            form.addEventListener('submit', (e) => this.validateForm(e));
        }

        // Phone number formatting
        const phoneInput = document.getElementById('phone');
        if (phoneInput) {
            phoneInput.addEventListener('input', (e) => this.formatPhoneNumber(e));
        }

        // Email validation on blur
        const emailInput = document.getElementById('email');
        if (emailInput) {
            emailInput.addEventListener('blur', (e) => this.validateEmail(e.target));
        }

        // Name validation
        const nameInput = document.getElementById('name');
        if (nameInput) {
            nameInput.addEventListener('blur', (e) => this.validateName(e.target));
        }
    }

    setupRealTimeValidation() {
        // Real-time validation for all inputs
        const inputs = document.querySelectorAll('input, textarea, select');
        inputs.forEach(input => {
            input.addEventListener('blur', (e) => this.validateField(e.target));
            input.addEventListener('input', (e) => this.clearError(e.target));
        });
    }

    validateForm(e) {
        e.preventDefault();
        
        const form = e.target;
        const fields = [
            'name', 'email', 'phone', 'policeStation', 'rating', 'feedbackText'
        ];

        let isValid = true;
        let firstInvalidField = null;

        fields.forEach(fieldName => {
            const field = form.elements[fieldName];
            if (field && !this.validateField(field)) {
                isValid = false;
                if (!firstInvalidField) {
                    firstInvalidField = field;
                }
            }
        });

        if (!isValid) {
            this.showToast('Please correct the errors in the form', 'error');
            if (firstInvalidField) {
                firstInvalidField.focus();
            }
            return false;
        }

        // If all valid, show loading and submit
        this.showLoading();
        setTimeout(() => {
            form.submit();
        }, 1000);
    }

    validateField(field) {
        const value = field.value.trim();
        const fieldName = field.name;

        switch (fieldName) {
            case 'name':
                return this.validateName(field);
            case 'email':
                return this.validateEmail(field);
            case 'phone':
                return this.validatePhone(field);
            case 'policeStation':
                return this.validatePoliceStation(field);
            case 'rating':
                return this.validateRating(field);
            case 'feedbackText':
                return this.validateFeedbackText(field);
            default:
                return true;
        }
    }

    validateName(field) {
        const value = field.value.trim();
        const nameRegex = /^[a-zA-Z\s.'-]{2,50}$/;

        if (!value) {
            this.showError(field, 'Full name is required');
            return false;
        }

        if (!nameRegex.test(value)) {
            this.showError(field, 'Please enter a valid name (letters, spaces, and basic punctuation only)');
            return false;
        }

        this.clearError(field);
        return true;
    }

    validateEmail(field) {
        const value = field.value.trim();
        const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

        if (!value) {
            this.showError(field, 'Email address is required');
            return false;
        }

        if (!emailRegex.test(value)) {
            this.showError(field, 'Please enter a valid email address');
            return false;
        }

        this.clearError(field);
        return true;
    }

    validatePhone(field) {
        const value = field.value.trim().replace(/[^\d]/g, '');
        const phoneRegex = /^[6-9]\d{9}$/;

        if (!value) {
            this.showError(field, 'Phone number is required');
            return false;
        }

        if (!phoneRegex.test(value)) {
            this.showError(field, 'Please enter a valid 10-digit Indian phone number starting with 6-9');
            return false;
        }

        this.clearError(field);
        return true;
    }

    validatePoliceStation(field) {
        const value = field.value;

        if (!value) {
            this.showError(field, 'Please select a police station');
            return false;
        }

        this.clearError(field);
        return true;
    }

    validateRating(field) {
        const value = field.value;

        if (!value) {
            this.showError(field, 'Please provide a rating by clicking on the stars');
            return false;
        }

        const rating = parseInt(value);
        if (rating < 1 || rating > 5) {
            this.showError(field, 'Rating must be between 1 and 5');
            return false;
        }

        this.clearError(field);
        return true;
    }

    validateFeedbackText(field) {
        const value = field.value.trim();

        if (!value) {
            this.showError(field, 'Feedback text is required');
            return false;
        }

        if (value.length < 10) {
            this.showError(field, 'Please provide more detailed feedback (minimum 10 characters)');
            return false;
        }

        if (value.length > 1000) {
            this.showError(field, 'Feedback text is too long (maximum 1000 characters)');
            return false;
        }

        // Check for potential harmful content
        if (this.containsMaliciousContent(value)) {
            this.showError(field, 'Feedback contains inappropriate content');
            return false;
        }

        this.clearError(field);
        return true;
    }

    containsMaliciousContent(text) {
        const maliciousPatterns = [
            /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,
            /javascript:/gi,
            /onload\s*=/gi,
            /onerror\s*=/gi,
            /onclick\s*=/gi,
            /vbscript:/gi,
            /expression\s*\(/gi
        ];

        return maliciousPatterns.some(pattern => pattern.test(text));
    }

    formatPhoneNumber(e) {
        let value = e.target.value.replace(/[^\d]/g, '');
        
        // Format as XXX-XXX-XXXX
        if (value.length > 3 && value.length <= 6) {
            value = value.replace(/(\d{3})(\d{0,3})/, '$1-$2');
        } else if (value.length > 6) {
            value = value.replace(/(\d{3})(\d{3})(\d{0,4})/, '$1-$2-$3');
        }
        
        e.target.value = value;
    }

    showError(field, message) {
        this.clearError(field);
        
        field.classList.add('is-invalid');
        
        const errorDiv = document.createElement('div');
        errorDiv.className = 'invalid-feedback';
        errorDiv.textContent = message;
        errorDiv.id = `${field.id}-error`;
        
        field.parentNode.appendChild(errorDiv);
        
        // Add toaster notification for critical errors
        if (field.required) {
            this.showToast(message, 'warning');
        }
    }

    clearError(field) {
        field.classList.remove('is-invalid');
        field.classList.add('is-valid');
        
        const errorDiv = document.getElementById(`${field.id}-error`);
        if (errorDiv) {
            errorDiv.remove();
        }
    }

    showToast(message, type = 'info') {
        // Remove existing toasts
        const existingToasts = document.querySelectorAll('.validation-toast');
        existingToasts.forEach(toast => toast.remove());

        const toast = document.createElement('div');
        toast.className = `validation-toast alert alert-${this.getAlertType(type)} alert-dismissible fade show`;
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
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (toast.parentNode) {
                toast.remove();
            }
        }, 5000);
    }

    getAlertType(type) {
        const types = {
            'error': 'danger',
            'warning': 'warning',
            'success': 'success',
            'info': 'info'
        };
        return types[type] || 'info';
    }

    showLoading() {
        const submitBtn = document.querySelector('button[type="submit"]');
        if (submitBtn) {
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = `
                <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                Submitting...
            `;
            submitBtn.disabled = true;
            
            // Restore button after 5 seconds (fallback)
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 5000);
        }
    }

    // Character counter for textareas
    setupCharacterCounters() {
        const textareas = document.querySelectorAll('textarea[maxlength]');
        textareas.forEach(textarea => {
            const maxLength = textarea.getAttribute('maxlength');
            const counter = document.createElement('div');
            counter.className = 'form-text character-counter';
            counter.textContent = `0/${maxLength} characters`;
            
            textarea.parentNode.appendChild(counter);
            
            textarea.addEventListener('input', (e) => {
                const length = e.target.value.length;
                counter.textContent = `${length}/${maxLength} characters`;
                
                if (length > maxLength * 0.9) {
                    counter.classList.add('text-warning');
                } else {
                    counter.classList.remove('text-warning');
                }
            });
        });
    }
}

// Enhanced Star Rating System
class StarRating {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        if (this.container) {
            this.init();
        }
    }

    init() {
        this.stars = this.container.querySelectorAll('.rating-star');
        this.hiddenInput = document.getElementById('rating');
        
        this.stars.forEach(star => {
            star.addEventListener('click', (e) => this.setRating(e));
            star.addEventListener('mouseover', (e) => this.highlightStars(e));
            star.addEventListener('mouseout', () => this.resetHighlight());
        });

        this.container.addEventListener('mouseleave', () => this.resetHighlight());
    }

    setRating(e) {
        const rating = parseInt(e.target.getAttribute('data-rating'));
        this.hiddenInput.value = rating;
        
        this.stars.forEach((star, index) => {
            if (index < rating) {
                star.classList.add('selected');
                star.style.transform = 'scale(1.1)';
            } else {
                star.classList.remove('selected');
                star.style.transform = 'scale(1)';
            }
        });

        // Show feedback section if not already visible
        const feedbackSection = document.getElementById('feedbackSection');
        if (feedbackSection) {
            feedbackSection.style.display = 'block';
            feedbackSection.style.animation = 'fadeIn 0.5s ease-in';
        }

        // Show rating confirmation
        this.showRatingConfirmation(rating);
    }

    highlightStars(e) {
        const hoverRating = parseInt(e.target.getAttribute('data-rating'));
        
        this.stars.forEach((star, index) => {
            if (index < hoverRating) {
                star.style.color = '#ffd700';
                star.style.transform = 'scale(1.05)';
            } else {
                star.style.color = '#ddd';
                star.style.transform = 'scale(1)';
            }
        });
    }

    resetHighlight() {
        const currentRating = this.hiddenInput.value ? parseInt(this.hiddenInput.value) : 0;
        
        this.stars.forEach((star, index) => {
            if (index < currentRating) {
                star.style.color = '#ffc107';
                star.style.transform = 'scale(1.1)';
            } else {
                star.style.color = '#ddd';
                star.style.transform = 'scale(1)';
            }
        });
    }

    showRatingConfirmation(rating) {
        const messages = {
            1: "We're sorry to hear about your experience. Please share details so we can improve.",
            2: "Thank you for your feedback. We'll work on addressing your concerns.",
            3: "Thank you for your feedback. We're always working to improve.",
            4: "Great! We're happy to hear you had a good experience.",
            5: "Excellent! We're thrilled you had a wonderful experience with us."
        };

        const message = messages[rating];
        if (message) {
            // Create or update confirmation message
            let confirmation = document.getElementById('rating-confirmation');
            if (!confirmation) {
                confirmation = document.createElement('div');
                confirmation.id = 'rating-confirmation';
                confirmation.className = 'alert alert-info mt-3';
                this.container.parentNode.appendChild(confirmation);
            }
            confirmation.textContent = message;
        }
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize form validator
    const validator = new FormValidator();
    
    // Initialize star rating
    const starRating = new StarRating('ratingStars');
    
    // Setup character counters
    validator.setupCharacterCounters();
    
    // Add CSS animations
    const style = document.createElement('style');
    style.textContent = `
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .rating-star {
            transition: all 0.2s ease;
        }
        
        .is-invalid {
            border-color: #dc3545 !important;
        }
        
        .is-valid {
            border-color: #198754 !important;
        }
        
        .character-counter {
            text-align: right;
            font-size: 0.875rem;
        }
    `;
    document.head.appendChild(style);
});

// Export for potential module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { FormValidator, StarRating };
}