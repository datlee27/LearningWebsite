    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html lang="en" data-theme="light">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Learning Platform Homepage</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <!-- Font Awesome for Book Icon -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homePage.css"/>
        <!-- Google Fonts: Inter -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
                                <a class="nav-link" href="${pageContext.request.contextPath}/view/myCourse.jsp">Courses</a>
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

        <!-- Main Content -->
        <div class="container mt-4">
            <div class="row">
                <!-- Sidebar with Learning Roadmap -->
                <div class="col-md-3">
                    <div class="sidebar card p-3">
                        <h4>Learning Roadmap</h4>
                        <ul class="list-group">
                            <li class="list-group-item">Module 1: Introduction
                                <div class="progress mt-2">
                                    <div class="progress-bar" role="progressbar" style="width: 60%;" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100">60%</div>
                                </div>
                            </li>
                            <li class="list-group-item">Module 2: Intermediate
                                <div class="progress mt-2">
                                    <div class="progress-bar" role="progressbar" style="width: 30%;" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100">30%</div>
                                </div>
                            </li>
                            <li class="list-group-item">Module 3: Advanced
                                <div class="progress mt-2">
                                    <div class="progress-bar" role="progressbar" style="width: 10%;" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100">10%</div>
                                </div>
                            </li>
                        </ul>
                        <a href="roadmap.jsp" class="btn btn-primary mt-3">View Full Roadmap</a>
                    </div>
                </div>

                <!-- Course Section -->
                <div class="col-md-9">
                    <h2>Featured Courses</h2>
                    <div class="row">
                        <!-- Course Card 1 -->
                        <div class="col-md-4 mb-4">
                            <div class="card course-card">
                                <img src="${pageContext.request.contextPath}/img/thumbnail1.png" class="card-img-top" alt="Course Thumbnail">
                                <div class="card-body">
                                    <h5 class="card-title">Introduction to Programming</h5>
                                    <p class="card-text">Learn the basics of coding with this beginner-friendly course.</p>
                                    <p><strong>Lessons:</strong> 12</p>
                                    <div class="progress progress-container">
                                        <div class="progress-bar" role="progressbar" style="width: 50%;" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100">50%</div>
                                    </div>
                                    <a href="course1.jsp" class="btn btn-primary mt-2">Start Learning</a>
                                </div>
                            </div>
                        </div>
                        <!-- Course Card 2 -->
                        <div class="col-md-4 mb-4">
                            <div class="card course-card">
                                <img src="${pageContext.request.contextPath}/img/thumbnail2.png" class="card-img-top" alt="Course Thumbnail">
                                <div class="card-body">
                                    <h5 class="card-title">Web Development Basics</h5>
                                    <p class="card-text">Build your first website with HTML, CSS, and JavaScript.</p>
                                    <p><strong>Lessons:</strong> 15</p>
                                    <div class="progress progress-container">
                                        <div class="progress-bar" role="progressbar" style="width: 20%;" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">20%</div>
                                    </div>
                                    <a href="course2.jsp" class="btn btn-primary mt-2">Start Learning</a>
                                </div>
                            </div>
                        </div>
                        <!-- Course Card 3 -->
                        <div class="col-md-4 mb-4">
                            <div class="card course-card">
                                <img src="${pageContext.request.contextPath}/img/thumbnail3.png" class="card-img-top" alt="Course Thumbnail">
                                <div class="card-body">
                                    <h5 class="card-title">Data Science Fundamentals</h5>
                                    <p class="card-text">Explore data analysis and visualization techniques.</p>
                                    <p><strong>Lessons:</strong> 10</p>
                                    <div class="progress progress-container">
                                        <div class="progress-bar" role="progressbar" style="width: 75%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100">75%</div>
                                    </div>
                                    <a href="course3.jsp" class="btn btn-primary mt-2">Start Learning</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS and Popper.js -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Theme Toggle Script -->
        <script>
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