<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Content Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homePage.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 20px;
        }
        .dashboard-title {
            text-align: center;
            font-size: 2rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 40px;
            border-bottom: 3px solid #007bff;
            padding-bottom: 10px;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            background-color: #ffffff;
            overflow: hidden;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        .card-img-top {
            height: 200px;
            object-fit: cover;
            border-bottom: 2px solid #007bff;
        }
        .card-body {
            padding: 20px;
            text-align: center;
        }
        .card-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }
        .card-text {
            color: #666;
            font-size: 1rem;
            margin-bottom: 20px;
        }
        .btn-custom {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 8px;
            font-weight: 500;
            transition: background-color 0.3s, transform 0.2s;
        }
        .btn-custom:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
        .preview-section {
            margin-top: 50px;
            padding: 20px;
            background-color: #e9ecef;
            border-radius: 10px;
            text-align: center;
        }
        .preview-section h3 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 20px;
        }
        .preview-card {
            background-color: #fff;
            border-radius: 10px;
            padding: 15px;
            margin: 10px;
            display: inline-block;
            width: 30%;
            min-width: 250px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        @media (max-width: 768px) {
            .preview-card {
                width: 100%;
            }
        }
    </style>
</head>
<body>
   <!-- Navigation Menu -->
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container-fluid">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/homePage">
                    <div class="book-icon-container">
                        <i class="fas fa-book-open book-icon"></i>
                        <div class="play-button" onclick="alert('Quay về trang chủ!')">
                            <svg viewBox="0 0 24 24">
                                <path d="M8 5v14l11-7z"/>
                            </svg>
                        </div>
                    </div>
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav mx-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="#">Home</a>
                        </li>
                        <% String role = (String) session.getAttribute("role"); %>
                        <% if ("teacher".equals(role)) { %>
                            
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/view/courseList.jsp">Course List </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/view/gradeAssignments.jsp">Grade Assignments</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/view/studentList.jsp">Student List</a>
                            </li>
                        <% } else { %>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Courses</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Roadmap</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Practice</a>
                            </li>
                        <% } %>
                    </ul>
                    <!-- User Profile, Sign In, Sign Up, Logout, and Theme Toggle -->
                    <div class="d-flex align-items-center">
                        <% if (session.getAttribute("username") == null) { %>
                            <a href="${pageContext.request.contextPath}/view/signIn.jsp" class="btn btn-outline-primary me-2">Sign In</a>
                            <a href="${pageContext.request.contextPath}/view/signUp.jsp" class="btn btn-outline-success me-2">Sign Up</a>
                        <% } else { %>
                            <div class="user-icon position-relative">
                                <button class="btn btn-outline-primary me-2" style="border: none; background: none;">
                                    <i class="bi bi-person-circle"></i>
                                </button>
                                <div class="dropdown-menu">
                                    <a href="${pageContext.request.contextPath}/view/profile.jsp"><i class="bi bi-person-fill me-2"></i>Profile</a>
                                    <a href="${pageContext.request.contextPath}/view/settings.jsp"><i class="bi bi-gear-fill me-2"></i>Settings</a>
                                    <a href="${pageContext.request.contextPath}/view/logOut.jsp"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
                                </div>
                            </div>
                        <% } %>
                        <button id="theme-toggle" class="btn btn-outline-secondary" title="Toggle Theme">
                            <i class="bi bi-sun-fill"></i>
                        </button>
                    </div>
                </div>
            </div>
        </nav>


    <div class="container">
        <h1 class="dashboard-title">Add Content Dashboard</h1>
        <div class="row g-4">
            <!-- Add Course Card -->
            <div class="col-md-4">
                <div class="card">
                  
                    <div class="card-body">
                        <h5 class="card-title">Add New Course</h5>
                        <p class="card-text">Create a new course with a title, description, and category to organize your educational content.</p>
                        <a href="${pageContext.request.contextPath}/addCourseServlet" class="btn btn-custom">Go to Add Course</a>
                    </div>
                </div>
            </div>
            <!-- Add Lecture Card -->
            <div class="col-md-4">
                <div class="card">
                   
                    <div class="card-body">
                        <h5 class="card-title">Add New Lecture</h5>
                        <p class="card-text">Add a lecture to an existing course, including a title and content URL for engaging lessons.</p>
                        <a href="${pageContext.request.contextPath}/addLecturesServlet" class="btn btn-custom">Go to Add Lecture</a>
                    </div>
                </div>
            </div>
            <!-- Add Assignment Card -->
            <div class="col-md-4">
                <div class="card">
                  
                    <div class="card-body">
                        <h5 class="card-title">Add New Assignment</h5>
                        <p class="card-text">Create assignments with titles, descriptions, and due dates to assess student progress.</p>
                        <a href="${pageContext.request.contextPath}/view/addAssignment.jsp" class="btn btn-custom">Go to Add Assignment</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Preview Section -->
        <div class="preview-section">
            <h3>Quick Preview</h3>
            <div class="preview-card">
                <h4>Course</h4>
                <p><strong>Name:</strong> Sample Course</p>
                <p><strong>Category:</strong> Programming</p>
                <p><strong>Description:</strong> Learn the basics of coding.</p>
            </div>
            <div class="preview-card">
                <h4>Lecture</h4>
                <p><strong>Course:</strong> Sample Course</p>
                <p><strong>Title:</strong> Introduction to Java</p>
                <p><strong>Content:</strong> Video URL</p>
            </div>
            <div class="preview-card">
                <h4>Assignment</h4>
                <p><strong>Course:</strong> Sample Course</p>
                <p><strong>Title:</strong> Coding Challenge</p>
                <p><strong>Due Date:</strong> 2025-07-20</p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Theme toggle functionality
        document.getElementById('theme-toggle').addEventListener('click', function() {
            document.body.classList.toggle('dark-mode');
            const icon = this.querySelector('i');
            icon.classList.toggle('bi-sun-fill');
            icon.classList.toggle('bi-moon-fill');
        });
        
          document.addEventListener('DOMContentLoaded', () => {
                const toggleButton = document.getElementById('theme-toggle');
                const htmlElement = document.documentElement;
                const currentTheme = localStorage.getItem('theme') || 'light';

                // Set initial theme
                htmlElement.setAttribute('data-theme', currentTheme);
                updateToggleIcon(currentTheme);

                // Toggle theme on button click
                toggleButton.addEventListener('click', () => {
                    const newTheme = htmlElement.getAttribute('data-theme') === 'light' ? 'dark' : 'light';
                    htmlElement.setAttribute('data-theme', newTheme);
                    localStorage.setItem('theme', newTheme);
                    updateToggleIcon(newTheme);
                });

                function updateToggleIcon(theme) {
                    const icon = toggleButton.querySelector('i');
                    icon.className = theme === 'light' ? 'bi bi-sun-fill' : 'bi bi-moon-fill';
                }
            });
    </script>
</body>
</html>