package Controller;

import DAO.DAO;
import Model.Course;
import Model.Lecture;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class AddLecturesServlet extends HttpServlet {
    private final DAO dao = new DAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("view/signIn.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("view/signIn.jsp");
            return;
        }

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String title = request.getParameter("title");
            String videoUrl = request.getParameter("videoUrl");
            String status = request.getParameter("status");

            if (title == null || title.trim().isEmpty() || status == null || status.trim().isEmpty()) {
                request.setAttribute("error", "Missing required fields");
                doGet(request, response);
                return;
            }

            // Kiểm tra courseId hợp lệ
            Course course = dao.getCoursesByTeacherId(user.getId()).stream()
                    .filter(c -> c.getIdCourse() == courseId)
                    .findFirst()
                    .orElse(null);
            if (course == null) {
                request.setAttribute("error", "Invalid course ID. Please select a valid course.");
                doGet(request, response);
                return;
            }

            dao.saveLecture(courseId, title, videoUrl, status);
            request.setAttribute("success", true);
            request.setAttribute("courseId", courseId);
            doGet(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid course ID format. Please select a valid course.");
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "DB Error: " + e.getMessage());
            doGet(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("view/signIn.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect("view/signIn.jsp");
            return;
        }

        try {
            User user = dao.findByUsername(username);
            if (user == null) {
                request.setAttribute("error", "User not found");
                request.getRequestDispatcher("/view/addLectures.jsp").forward(request, response);
                return;
            }

            int teacherId = user.getId();
            List<Course> courses = dao.getCoursesByTeacherId(teacherId);
            if (courses == null) {
                courses = new ArrayList<>();
            }
            request.setAttribute("courses", courses);

            String courseIdParam = request.getParameter("courseId");
            int courseId = -1;
            List<Lecture> lectures = new ArrayList<>();

            if (courseIdParam != null && !courseIdParam.trim().isEmpty()) {
                try {
                    courseId = Integer.parseInt(courseIdParam);
                    if (courseId > 0) { // Kiểm tra courseId hợp lệ
                        lectures = dao.getLecturesByCourseId(courseId);
                        if (lectures == null) {
                            lectures = new ArrayList<>();
                        }
                    } else {
                        request.setAttribute("error", "Invalid course ID: " + courseId);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid course ID format: " + e.getMessage());
                } catch (Exception e) {
                    request.setAttribute("error", "Error loading lectures: " + e.getMessage());
                }
            }

            request.setAttribute("courseId", courseId);
            request.setAttribute("lectures", lectures);
            request.getRequestDispatcher("/view/addLectures.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "An error occurred while loading the page: " + e.getMessage());
            request.getRequestDispatcher("/view/addLectures.jsp").forward(request, response);
        }
    }
}