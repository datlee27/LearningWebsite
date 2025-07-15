<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Assignment</title>
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
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #ced4da;
            padding: 10px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-control:focus, .form-select:focus {
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

    <!-- (Include your styles and libraries as before) -->

</head>
<body>
<div class="container">
    <div class="card">
        <div class="card-header">
            <i class="bi bi-file-earmark-text me-2"></i>Assignment Manager
        </div>
        <div class="card-body">
            <!-- Course Selection -->
            <div class="mb-3">
                <label class="form-label">Choose Course</label>
                <select class="form-select" id="courseDropdown">
                    <option value="">Select Course</option>
                    <c:forEach var="course" items="${courseList}">
                        <option value="${course.id}">${course.name}</option>
                    </c:forEach>
                </select>
            </div>


              
                <form action="${pageContext.request.contextPath}/addAssignmentServlet" method="post">
                  
                    <div class="mb-3">
                        <label for="lectureId" class="form-label"> Course Name</label>
                        <select class="form-select" id="lectureId" name="idLecture">
                            <option value="">None</option>
                            <!-- Placeholder for lecture options, to be filled later -->
                            <option value="1">Sample Lecture 1</option>
                            <option value="2">Sample Lecture 2</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="lectureId" class="form-label"> Lecture (Optional)</label>
                        <select class="form-select" id="lectureId" name="idLecture">
                            <option value="">None</option>
                            <!-- Placeholder for lecture options, to be filled later -->
                            <option value="1">Sample Lecture 1</option>
                            <option value="2">Sample Lecture 2</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="assignmentTitle" class="form-label">Assignment Title</label>
                        <input type="text" class="form-control" id="assignmentTitle" name="title" required>
                        <div class="error-message" id="assignmentTitleError">Assignment title is required.</div>
                    </div>
                    <div class="mb-3">
                        <label for="assignmentDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="assignmentDescription" name="description" rows="3" required></textarea>
                        <div class="error-message" id="assignmentDescriptionError">Description is required.</div>
                    </div>
                    <div class="mb-3">
                        <label for="dueDate" class="form-label">Due Date</label>
                        <input type="datetime-local" class="form-control" id="dueDate" name="dueDate" required>
                        <div class="error-message" id="dueDateError">Due date is required.</div>
                    </div>
                    <button type="submit" class="btn btn-primary">Add Assignment</button>
                </form>

            <!-- Lecture Selection (populated based on selected course) -->
            <div class="mb-3">
                <label class="form-label">Choose Lecture</label>
                <select class="form-select" id="lectureDropdown" disabled>
                    <option value="">Select Lecture</option>
                </select>
            </div>

            <!-- Assignment list -->
            <div id="assignmentSection" style="display:none;">
                <h5>Assignments</h5>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Due Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="assignmentTableBody">
                        <!-- Populated via JS -->
                    </tbody>
                </table>
                <button class="btn btn-primary" id="addAssignmentBtn">Add Assignment</button>

            </div>
        </div>
    </div>
</div>

<!-- Assignment Modal (Add/Edit) -->
<div class="modal fade" id="assignmentModal" tabindex="-1">
    <div class="modal-dialog">
        <form id="assignmentForm">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="assignmentModalTitle">Add/Edit Assignment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <!-- Assignment fields go here -->
                    <input type="hidden" name="assignmentId" id="assignmentId" />
                    <input type="hidden" name="lectureId" id="modalLectureId" />
                    <!-- Add fields for title, description, due date as before -->
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Save</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
// JavaScript logic for dynamic dropdowns and AJAX calls
document.getElementById('courseDropdown').addEventListener('change', function() {
    // Fetch lectures for selected course via AJAX
    // Populate lectureDropdown and enable it
});

document.getElementById('lectureDropdown').addEventListener('change', function() {
    // Fetch assignments for selected lecture via AJAX
    // Populate assignmentTableBody
    document.getElementById('assignmentSection').style.display = 'block';
});

document.getElementById('addAssignmentBtn').addEventListener('click', function() {
    // Show modal for adding assignment
    // Reset assignmentForm
});

// Assignment Edit/Delete logic
function editAssignment(id) {
    // Populate modal with assignment data and show for editing
}
function deleteAssignment(id) {
    // Confirm and send AJAX request to delete assignment
}

// Handle assignmentForm submission via AJAX for add/edit
</script>
</body>
</html>
