<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <div class="row">
                    <c:forEach var="course" items="${courses}">
                        <div class="col-md-4 mb-4">
                            <div class="card course-card">
                                <img src="image/${course.image}" class="card-img-top" alt="${course.name}">
                                <div class="card-body">
                                    <h5 class="card-title">${course.name}</h5>
                                    <p class="card-text">${course.description}</p>
                                    <p><strong>Lessons:</strong> ${course.lectures.size()}</p>
                                    <div class="progress progress-container">
                                        <div class="progress-bar" role="progressbar" style="width: 50%;" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100">50%</div>
                                    </div>
                                    <a href="course${course.idCourse}.jsp" class="btn btn-primary mt-2">Start Learning</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>