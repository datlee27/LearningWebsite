<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Content Dashboard</title>
   
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/courseList.css"/>
</head>
<body>
 <jsp:include page="/view/navbar.jsp" />


    <div class="container mt-4">
        <h1 class="dashboard-title"> Content Dashboard</h1>
        <div class="row g-4">
            <!-- Add Course Card -->
            <div class="col-md-4">
                <div class="card">
                  
                    <div class="card-body">
                        <h5 class="card-title">Add New Course</h5>
                        <p class="card-text">Create a new course with a title, description to organize your educational content.</p>
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
                        <a href="${pageContext.request.contextPath}/addAssignmentServlet" class="btn btn-custom">Go to Add Assignment</a>
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
  
</body>
</html>