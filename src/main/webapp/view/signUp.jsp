<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Learning Platform</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/signUp.css"/>
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
   
    <script src="https://accounts.google.com/gsi/client" async defer></script>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card course-card p-4">
                    <h2 class="text-center mb-4">Sign Up</h2>
                    <!-- Error Message -->
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" role="alert">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    <form action="${pageContext.request.contextPath}/register" method="post" id="signupForm">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username or Email</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        </div>
                        <!-- Hidden input for role -->
                        <input type="hidden" id="role" name="role" value="student">
                        <!-- Role Selection Buttons -->
                        <div class="btn-group w-100 mb-3" role="group">
                            <button type="button" class="btn btn-outline-primary w-50 role-btn" data-role="student">
                                <i class="bi bi-person"></i> Student
                            </button>
                            <button type="button" class="btn btn-outline-primary w-50 role-btn" data-role="teacher">
                                <i class="bi bi-person-workspace"></i> Teacher
                            </button>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 mb-3">Sign Up</button>
                    </form>
                    <!-- Google Sign-In Button -->
                   
                    <p class="text-center">Already have an account? <a href="${pageContext.request.contextPath}/loginServlet">Sign In</a></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Theme Toggle Script -->
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const htmlElement = document.documentElement;
            const currentTheme = localStorage.getItem('theme') || 'light';
            htmlElement.setAttribute('data-theme', currentTheme);

            // Role button selection logic
            const roleButtons = document.querySelectorAll('.role-btn');
            const roleInput = document.getElementById('role');
            roleButtons.forEach(button => {
                button.addEventListener('click', () => {
                    roleButtons.forEach(btn => btn.classList.remove('active'));
                    button.classList.add('active');
                    roleInput.value = button.getAttribute('data-role');
                });
            });

            // Set default active button
            roleButtons[0].classList.add('active');
        });

    
    </script>
</body>
</html>
