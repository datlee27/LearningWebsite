
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Student List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/studentList.css"/>
    <style>
        .container {
            max-width: 1200px;
            margin: 2.5rem auto;
            padding: 2rem;
        }
        .course-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .course-info {
            flex: 1;
            min-width: 0;
        }
        .toggle-button {
            background: linear-gradient(45deg, #2c5282, #63b3ed);
            color: #fff;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
            white-space: nowrap;
        }
        [data-theme="dark"] .toggle-button {
            background: linear-gradient(45deg, #63b3ed, #90cdf4);
        }
        .toggle-button:hover {
            background: linear-gradient(45deg, #1a4066, #4c8dd1);
        }
        [data-theme="dark"] .toggle-button:hover {
            background: linear-gradient(45deg, #4c8dd1, #7ab8e6);
        }
        .student-list {
            display: none;
        }
        .student-list.active {
            display: table;
        }
        @media (max-width: 768px) {
            .course-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .toggle-button {
                align-self: flex-end;
            }
        }
    </style>
</head>
<body>
     <jsp:include page="/view/navbar.jsp" />
    <div class="container">
        <h2>Student List for My Courses</h2>

        <c:if test="${not empty error}">
            <p style="color: red;">Error: ${error}</p>
        </c:if>

        <c:if test="${not empty courses}">
            <c:forEach var="course" items="${courses}" varStatus="loop">
                <div class="course-header">
                    <div class="course-info">
                        <h3>Course: ${course.name}</h3>
                        <p>Description: ${course.description}</p>
                    </div>
                    <c:if test="${not empty course.enrollments}">
                        <button class="toggle-button" onclick="toggleStudentList('student-list-${loop.index}')">View Student List</button>
                    </c:if>
                </div>

                <c:if test="${not empty course.enrollments}">
                    <table class="table student-list" id="student-list-${loop.index}">
                        <thead>
                            <tr>
                                <th>Student ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Date of Birth</th>
                                <th>Gender</th>
                                <th>Address</th>
                                <th>Phone</th>
                                <th>School</th>
                                <th>Enrollment Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="enrollment" items="${course.enrollments}">
                                <tr>
                                    <td>${enrollment.student.id}</td>
                                    <td>${enrollment.student.firstName} ${enrollment.student.lastName}</td>
                                    <td>${enrollment.student.email}</td>
                                    <td><fmt:formatDate value="${enrollment.student.dateOfBirth}" pattern="yyyy-MM-dd"/></td>
                                    <td>${enrollment.student.gender}</td>
                                    <td>${enrollment.student.address}</td>
                                    <td>${enrollment.student.phoneNumber}</td>
                                    <td>${enrollment.student.school}</td>
                                    <td>${enrollment.formattedEnrollmentDate}</td>
                                    <td>${enrollment.status}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <c:if test="${empty course.enrollments}">
                    <p>No students enrolled in this course.</p>
                </c:if>
            </c:forEach>
        </c:if>

        <c:if test="${empty courses}">
            <p>No courses found for you. Please add or select a course.</p>
        </c:if>
    </div>

    <script>
        function toggleStudentList(tableId) {
            const table = document.getElementById(tableId);
            const button = table.previousElementSibling.querySelector('.toggle-button') || table.previousElementSibling.previousElementSibling.querySelector('.toggle-button');
            if (table.classList.contains('active')) {
                table.classList.remove('active');
                button.textContent = 'View Student List';
            } else {
                table.classList.add('active');
                button.textContent = 'Hide Student List';
            }
        }
    </script>
</body>
</html>
```