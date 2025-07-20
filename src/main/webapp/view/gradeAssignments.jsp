<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Grade Assignments</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/gradeAssignments.css" />
    <style>
        .table { width: 100%; border-collapse: collapse; }
        .table th, .table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .table th { background-color: #f2f2f2; }
        .form-control { margin: 5px 0; }
    </style>
</head>
<body>
    <jsp:include page="/view/navbar.jsp" />
     <div class="container">
    <c:if test="${not empty error}">
        <p style="color: red;">Error: ${error}</p>
    </c:if>

    <c:if test="${empty submissions}">
        <p>Không có bài nộp nào cho các bài tập của bạn.</p>
    </c:if>

    <c:if test="${not empty submissions}">
        
        <h4>All Submissions for Your Courses (as of <%= new java.text.SimpleDateFormat("hh:mm a zzz, EEEE, MMMM dd, yyyy").format(new java.util.Date()) %>)</h4>
        <table class="table">
            <thead>
                <tr>
                    <th>Course</th>
                    <th>Lecture</th>
                    <th>Assignment</th>
                    <th>Student</th>
                    <th>Submitted At</th>
                    <th>File</th>
                    <th>Grade</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${submissions}">
                    <tr>
                        <td>${s.assignment.courseName}</td>
                        <td>${s.assignment.lectureTitle != null ? s.assignment.lectureTitle : 'N/A'}</td>
                        <td>${s.assignment.title}</td>
                        <td>${s.student.firstName} ${s.student.lastName}</td>
                        <td><fmt:formatDate value="${s.submissionDateAsDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td><a href="${s.fileUrl}" target="_blank">View File</a></td>
                        <td>${s.grade != null ? s.grade : 'Not graded'} /10.0</td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/gradeAssignments">
                                <input type="hidden" name="submissionId" value="${s.id}"/>
                                <input type="hidden" name="assignmentId" value="${s.assignment.idAss}"/>
                                <input type="number" name="grade" step="0.01" min="0" max="10" required class="form-control" style="width: 100px; display:inline-block" value="${s.grade != null ? s.grade : ''}"/>
                                <button type="submit" class="btn btn-primary btn-sm">Grade</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
     </div>
</body>
</html>