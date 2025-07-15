<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Lecture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 20px;
        }
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            background-color: #ffffff;
        }
        .card-header {
            background-color: #007bff;
            color: white;
            font-weight: 600;
            border-radius: 12px 12px 0 0;
            padding: 15px 20px;
            font-size: 1.2rem;
        }
        .card-body {
            padding: 25px;
        }
        .form-control {
            border-radius: 8px;
            border: 1px solid #ced4da;
            padding: 10px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            transition: background-color 0.3s, transform 0.2s;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
        .form-label {
            font-weight: 500;
            color: #333;
        }
        .error-message {
            color: #dc3545;
            font-size: 0.9rem;
            display: none;
        }
    </style>
</head>
<body>
  

    <div class="container">
        <div class="card">
            <div class="card-header">
                <i class="bi bi-camera-reels me-2"></i>Add New Lecture
            </div>
            <div class="card-body">
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger">${param.error}</div>
                </c:if>
                <c:if test="${param.success == 'true'}">
                    <div class="alert alert-success">Lecture added successfully!</div>
                </c:if>

              
                <form action="${pageContext.request.contextPath}/addLecturesServlet" method="post">
                     <input type="hidden" name="courseId" value="${param.courseId}">
                    <div class="mb-3">
                        <label for="lectureTitle" class="form-label">Course</label>                      
                           <select class="form-select" id="lectureId" name="idLecture">
                            <option value="">None</option>
                            <!-- Placeholder for lecture options, to be filled later -->
                            <option value="1">Sample Lecture 1</option>
                            <option value="2">Sample Lecture 2</option>
                        </select>
                    </div>
                    <input type="hidden" name="courseId" value="${param.courseId}">
                    <div class="mb-3">
                        <label for="lectureTitle" class="form-label">Lecture Title</label>
                        <input type="text" class="form-control" id="lectureTitle" name="title" required>
                        <div class="error-message" id="lectureTitleError">Lecture title is required.</div>
                    </div>
                    <div class="mb-3">
                        <label for="lectureContent" class="form-label">Content</label>
                        <textarea class="form-control" id="lectureContent" name="content" rows="3" required></textarea>
                        <div class="error-message" id="lectureContentError">Content is required.</div>
                    </div>
                    <div class="mb-3">
                        <label for="videoUrl" class="form-label">Video URL (Optional)</label>
                        <input type="text" class="form-control" id="videoUrl" name="videoUrl">
                    </div>
                    <button type="submit" class="btn btn-primary">Add Lecture</button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Basic form validation
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function(e) {
                let isValid = true;
                form.querySelectorAll('[required]').forEach(input => {
                    if (!input.value) {
                        isValid = false;
                        const errorElement = document.getElementById(`${input.id}Error`);
                        if (errorElement) errorElement.style.display = 'block';
                    }
                });
                if (!isValid) e.preventDefault();
            });
        });

        // Theme toggle functionality
        document.getElementById('theme-toggle')?.addEventListener('click', function() {
            document.body.classList.toggle('dark-mode');
            const icon = this.querySelector('i');
            icon.classList.toggle('bi-sun-fill');
            icon.classList.toggle('bi-moon-fill');
        });
    </script>
</body>
</html>