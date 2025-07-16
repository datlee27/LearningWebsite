<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="DAO.DAO, Model.Course, Model.User, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    DAO dao = new DAO();
    User user = dao.findByUsername(username);
    List<Course> myCourses = dao.getCoursesByTeacherId(user.getId());
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <title>Add Course</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/coursePage.css"/>
</head>
<body>
    <jsp:include page="/view/navbar.jsp" />
<div class="container mt-4">
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <h2>Your Courses</h2>
    <button class="btn btn-toggle-form" onclick="toggleForm()">Add Course</button>

    <!-- Add form -->
    <div id="addCourseForm" class="card p-3 mb-4" style="display: none;">
        <form action="${pageContext.request.contextPath}/addCourseServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="teacher_id" value="<%= user.getId() %>">
            <div class="mb-3">
                <label>Course Name</label>
                <input type="text" class="form-control" name="name" required>
            </div>
            <div class="mb-3">
                <label>Description</label>
                <textarea class="form-control" name="description" required></textarea>
            </div>
            <div class="mb-3">
                <label>Image Course</label>
                <input type="file" class="form-control" name="image" accept="image/*" required>
            </div>
            <button type="submit" class="btn btn-primary">Save</button>
        </form>
    </div>
           
    <!-- Course list -->
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Num</th><th>Name</th><th>Description</th><th>Image Course(url)</th><th>Action</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="c" items="<%= myCourses %>" varStatus="i">
            <tr class="table table-child">
                <td>${i.index + 1}</td>
                <td>${c.name}</td>
                <td>${c.description}</td>
                <td>${c.image}</td>
                <td>
                    <button class="btn btn-warning btn-sm" onclick="openEditModal(${c.idCourse}, '${c.name}', '${c.description}', '${c.image}')">Edit</button>
                    <form action="${pageContext.request.contextPath}/deleteControl" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="${c.idCourse}">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- Modal for edit -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/editControl" method="post" class="modal-content" enctype="multipart/form-data">
            <input type="hidden" name="id" id="editId">
            <input type="hidden" name="currentImage" id="editCurrentImage">
            <div class="modal-header">
                <h5 class="modal-title">Edit Course</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label>Course Name</label>
                    <input type="text" class="form-control" name="name" id="editName" required>
                </div>
                <div class="mb-3">
                    <label>Description</label>
                    <textarea class="form-control" name="description" id="editDescription" required></textarea>
                </div>
                <div class="mb-3">
                    <label>Image Course (leave blank to keep current image)</label>
                    <input type="file" class="form-control" name="image" id="editImage" accept="image/*">
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Save Changes</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
function toggleForm() {
    const form = document.getElementById('addCourseForm');
    form.style.display = (form.style.display === 'none') ? 'block' : 'none';
}

function openEditModal(id, name, description, image) {
    document.getElementById('editId').value = id;
    document.getElementById('editName').value = name;
    document.getElementById('editDescription').value = description;
    document.getElementById('editCurrentImage').value = image;
    new bootstrap.Modal(document.getElementById('editModal')).show();
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>