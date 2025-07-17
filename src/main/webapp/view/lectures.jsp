<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List, Model.Lecture" %>
<%
    List<Lecture> lectures = (List<Lecture>) request.getAttribute("lectures");
%>

<!DOCTYPE html>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <meta charset="UTF-8">
    <title>Add Lecture</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/coursePage.css"/>
    <script>
        function submitForm() {
            var select = document.querySelector("select[name='courseId']");
            if (select.value === "") {
                alert("Please select a valid course.");
                return false;
            }
            select.form.submit();
        }

        function toggleForm() {
            var form = document.getElementById("lectureForm");
            form.style.display = form.style.display === "none" ? "block" : "none";
        }
    </script>
</head>
<body>

<jsp:include page="/view/navbar.jsp" />

<div class="container mt-4">
    <h2>Add New Lecture</h2>

    <c:if test="${success == true}">
        <div class="alert alert-success">Lecture added successfully!</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- Form chỉ để chọn course -->
    <form method="get" action="${pageContext.request.contextPath}/lectures">
        <div class="mb-3">
            <label for="courseId" class="form-label">Select Course:</label>
            <select id="courseId" name="courseId" class="form-select" onchange="submitForm()" required>
                <option value="" ${empty courseId ? 'selected' : ''}>-- Select a course --</option>
                <c:choose>
                    <c:when test="${empty courses}">
                        <option value="" disabled>No courses available</option>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="c" items="${courses}">
                            <option value="${c.idCourse}" ${c.idCourse == courseId ? 'selected' : ''}>${c.name}</option>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </select>
            <c:if test="${empty courses}">
                <small class="text-danger">No courses found for this teacher. Please add a course first.</small>
            </c:if>
        </div>
    </form>

    <!-- Nút để hiển thị/ẩn form thêm lecture -->
    <c:if test="${not empty courseId}">
        <button class="btn btn-toggle-form" onclick="toggleForm()">Add Lecture</button>

        <!-- Form để thêm lecture -->
        <form id="lectureForm" class="lecture-form" method="post" action="${pageContext.request.contextPath}/lectures">
            <input type="hidden" name="courseId" value="${courseId}">
            <div class="mb-3">
                <label for="title" class="form-label">Lecture Title:</label>
                <input type="text" id="title" name="title" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <textarea id="status" name="status" class="form-control" required></textarea>
            </div>
            <div class="mb-3">
                <label for="videoUrl" class="form-label">Video URL (optional):</label>
                <input type="text" id="videoUrl" name="videoUrl" class="form-control">
            </div>
            <button type="submit" class="btn btn-primary">Save Lecture</button>
        </form>
    </c:if>

    <hr>

    <h4 class="mt-4">Current Lectures</h4>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Title</th>
            <th>Video URL</th>
            <th>Status</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="lec" items="${lectures}">
            <tr>
                <td>${lec.title}</td>
                <td>${lec.videoUrl}</td>
                <td>${lec.status}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>