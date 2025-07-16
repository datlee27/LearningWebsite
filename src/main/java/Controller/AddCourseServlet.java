package Controller;

import DAO.DAO;
import Model.Course;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AddCourseServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AddCourseServlet.class.getName());
    private final DAO dao = new DAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/view/signIn.jsp");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        int teacherId = Integer.parseInt(request.getParameter("teacher_id"));
        String image =request.getParameter("image");

        try {
            if (name == null || name.trim().isEmpty() || description == null || description.trim().isEmpty()) {
                request.setAttribute("error", "Course name and description are required.");
            } else {
                dao.saveCourse(name, description, teacherId,image);
                request.setAttribute("success", "Course added successfully!");
            }

            User user = dao.findByUsername((String) session.getAttribute("username"));
            List<Course> courses = dao.getCoursesByTeacherId(teacherId);
            request.setAttribute("user", user);
            request.setAttribute("courses", courses);

            request.getRequestDispatcher("/view/addCourses.jsp").forward(request, response);

        } catch (Exception e) {
            logger.severe("Error: " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
            try {
                List<Course> courses = dao.getCoursesByTeacherId(teacherId);
                request.setAttribute("courses", courses);
            } catch (Exception ex) {
                logger.warning("Failed to load courses");
            }
            request.getRequestDispatcher("/view/addCourses.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/view/signIn.jsp");
            return;
        }

        try {
            String username = (String) session.getAttribute("username");
            User user = dao.findByUsername(username);
            List<Course> courses = dao.getCoursesByTeacherId(user.getId());
            request.setAttribute("user", user);
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/view/addCourses.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
