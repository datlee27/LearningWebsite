<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <meta charset="UTF-8">
    <title>Add Assignment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/coursePage.css"/>
</head>
<body >
<jsp:include page="/view/navbar.jsp" />
<div class="container mt-4">
<h2>Add Assignment</h2>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>
<c:if test="${success == true}">
    <div class="alert alert-success">Assignment added successfully!</div>
</c:if>

<!-- Form chọn Course -->
<form method="get" action="${pageContext.request.contextPath}/assignments">
    <div class="mb-3">
        <label for="courseDropdown" class="form-label">Choose Course</label>
        <select name="courseId" id="courseDropdown" class="form-select" onchange="this.form.submit()">
            <option value="">-- Select Course --</option>
            <c:forEach var="c" items="${courseList}">
                <option value="${c.idCourse}" ${c.idCourse == selectedCourseId ? 'selected' : ''}>${c.name}</option>
            </c:forEach>
        </select>
    </div>
</form>

<!-- Form chọn Lecture -->
<c:if test="${not empty selectedCourseId}">
<form method="get" action="${pageContext.request.contextPath}/assignments">
    <input type="hidden" name="courseId" value="${selectedCourseId}" />
    <div class="mb-3">
        <label for="lectureDropdown" class="form-label">Choose Lecture</label>
        <select name="lectureId" id="lectureDropdown" class="form-select" onchange="this.form.submit()">
            <option value="">-- Select Lecture --</option>
            <c:forEach var="l" items="${lectureList}">
                <option value="${l.id}" ${l.id == selectedLectureId ? 'selected' : ''}>${l.title}</option>
            </c:forEach>
        </select>
    </div>
</form>
</c:if>

<!-- Hiện nút Add Assignment nếu đã chọn cả course và lecture -->
<c:if test="${not empty selectedCourseId && not empty selectedLectureId}">
    <button class="btn btn-toggle-form" onclick="toggleAddAssignmentForm()"> Add Assignment</button>

    <!-- Form Thêm Assignment (ẩn mặc định) -->
    <div id="addAssignmentForm" class="card p-3 mb-4" style="display: none;">
        <form method="post" action="${pageContext.request.contextPath}/assignments">
            <input type="hidden" name="courseId" value="${selectedCourseId}" />
            <input type="hidden" name="lecture_id" value="${selectedLectureId}" />

            <div class="mb-3">
                <label for="title" class="form-label">Assignment Title</label>
                <input type="text" name="title" id="title" class="form-control" required />
            </div>

            <div class="mb-3">
                <label for="description" class="form-label">Description</label>
                <textarea name="description" id="description" class="form-control" required></textarea>
            </div>

            <div class="mb-3">
                <label for="dueDate" class="form-label">Due Date</label>
                <input type="datetime-local" name="dueDate" id="dueDate" class="form-control" required />
            </div>

            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <input type="text" name="status" id="status" class="form-control" required />
            </div>

            <button type="submit" class="btn btn-primary">Save Assignment</button>
        </form>
    </div>
</c:if>


<!-- Danh sách Assignment -->
<c:if test="${not empty assignmentList}">
    <h4 class="mt-5">Assignments for selected lecture</h4>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>Title</th>
                <th>Description</th>
                <th>Due Date</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            
            <c:forEach var="a" items="${assignmentList}">
                <tr>
                    <td>${a.title}</td>
                    <td>${a.description}</td>
                    <td> <fmt:formatDate value="${a.dueDateAsJavaUtilDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                    <td>${a.status}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</c:if>
    </div>

</body>
<!-- Script để toggle form -->
<script>
function toggleAddAssignmentForm() {
    const form = document.getElementById('addAssignmentForm');
    form.style.display = (form.style.display === 'none') ? 'block' : 'none';
}
</script>
</html>