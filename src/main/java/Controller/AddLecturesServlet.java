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
import java.util.logging.Logger;


public class AddLecturesServlet extends HttpServlet {
    private final DAO dao = new DAO();
    private static final Logger logger = Logger.getLogger(AddLecturesServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ... (giữ nguyên mã POST)
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

            logger.info("Received courseIdParam: " + courseIdParam);
            if (courseIdParam != null && !courseIdParam.trim().isEmpty()) {
                try {
                    courseId = Integer.parseInt(courseIdParam);
                    if (courseId > 0) {
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
                    logger.severe("Exception in doGet: " + e.getMessage());
                }
            } else {
                logger.warning("courseIdParam is null or empty");
            }

            request.setAttribute("courseId", courseId);
            request.setAttribute("lectures", lectures);
            request.getRequestDispatcher("/view/addLectures.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "An error occurred while loading the page: " + e.getMessage());
            request.getRequestDispatcher("/view/addLectures.jsp").forward(request, response);
            logger.severe("Exception in doGet: " + e.getMessage());
        }
    }
}