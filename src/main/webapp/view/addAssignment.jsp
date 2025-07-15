<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
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
