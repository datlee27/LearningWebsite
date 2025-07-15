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
       <jsp:include page="/view/navbar.jsp" />

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
  
    </body>
    </html>