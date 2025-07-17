package Controller;

import DAO.AssignmentDAO;
import DAO.CourseDAO;

import DAO.LectureDAO;
import DAO.UserDAO;
import Model.Assignment;
import Model.Course;
import Model.Lecture;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.logging.Logger;

public class AssignmentServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AssignmentServlet.class.getName());
    private final CourseDAO courseDAO = new CourseDAO();
    private final LectureDAO lectureDAO = new LectureDAO();
    private final UserDAO userDAO = new UserDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/view/signIn.jsp");
            return;
        }

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String idLectureParam = request.getParameter("lecture_id");
        Integer idLecture = (idLectureParam != null && !idLectureParam.isEmpty()) ? Integer.parseInt(idLectureParam) : null;
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String dueDateStr = request.getParameter("dueDate"); // Format: yyyy-MM-ddTHH:mm
        String status = request.getParameter("status");
        if (title == null || title.trim().isEmpty() || description == null || description.trim().isEmpty() || dueDateStr == null) {
            request.setAttribute("error", "Assignment title, description, and due date are required.");
            request.getRequestDispatcher(request.getContextPath() + "/assignments");
            return;
        }

        try {
            // Convert input date string to SQL Timestamp
            LocalDateTime localDateTime = LocalDateTime.parse(dueDateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            Timestamp dueDate = Timestamp.valueOf(localDateTime);

           assignmentDAO.saveAssignment(courseId, idLecture, title, description, dueDate,status);
            logger.info("Assignment added successfully for course ID: " + courseId);
            session.setAttribute("success", true);
          response.sendRedirect(request.getContextPath() + "/assignments");
        } catch (SQLException e) {
            logger.severe("Database error while adding assignment: " + e.getMessage());
            request.setAttribute("error", "Failed to add assignment: " + e.getMessage());
            request.getRequestDispatcher("/view/lectures.jsp?courseId=" + courseId).forward(request, response);
        } catch (Exception e) {
            logger.severe("Unexpected error while adding assignment: " + e.getMessage());
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher(request.getContextPath() + "/assignments");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("view/signIn.jsp");
            return;
        }
            Boolean success = (Boolean) session.getAttribute("success");
            if (success != null) {
                request.setAttribute("success", true);
                session.removeAttribute("success");
            }
        String courseIdParam = request.getParameter("courseId");
        String lectureIdParam = request.getParameter("lectureId");

        try {
            List<Course> courseList = courseDAO.getCoursesByTeacherId(((User) session.getAttribute("user")).getId());
            request.setAttribute("courseList", courseList);

            if (courseIdParam != null && !courseIdParam.isEmpty()) {
                int courseId = Integer.parseInt(courseIdParam);
                request.setAttribute("selectedCourseId", courseId);

                List<Lecture> lectureList = lectureDAO.getLecturesByCourseId(courseId);
                request.setAttribute("lectureList", lectureList);

                if (lectureIdParam != null && !lectureIdParam.isEmpty()) {
                    int lectureId = Integer.parseInt(lectureIdParam);
                    request.setAttribute("selectedLectureId", lectureId);

                    List<Assignment> assignmentList = assignmentDAO.getAssignmentsByLecture(courseId, lectureId);
                    request.setAttribute("assignmentList", assignmentList);
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error loading data: " + e.getMessage());
        }

        request.getRequestDispatcher("/view/assignment.jsp").forward(request, response);
    }
}
