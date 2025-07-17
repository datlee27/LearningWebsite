package Controller;


import DAO.CourseDAO;
import DAO.LectureDAO;
import DAO.UserDAO;
import Model.Course;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Giới hạn kích thước file là 5MB
public class CourseServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(CourseServlet.class.getName());
  private final CourseDAO courseDAO = new CourseDAO();
    private final LectureDAO lectureDAO = new LectureDAO();
    private final UserDAO userDAO = new UserDAO();

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
        String teacherIdStr = request.getParameter("teacher_id");
        int teacherId = 0;

        // Kiểm tra và parse teacher_id
        if (teacherIdStr == null || teacherIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Teacher ID is missing or invalid.");
            forwardToAddCourses(request, response, session);
            return;
        }
        try {
            teacherId = Integer.parseInt(teacherIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid Teacher ID format.");
            forwardToAddCourses(request, response, session);
            return;
        }

        // Xử lý file ảnh
        Part filePart = request.getPart("image");
        String imagePath = null;
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            // Sử dụng đường dẫn tuyệt đối tới thư mục image
            String uploadPath = "/Users/mac/NetBeansProjects/PRJ301/learning_project/src/main/webapp/image/" + fileName;
            logger.info("Attempting to save image to: " + uploadPath);

            // Đảm bảo thư mục image tồn tại
            File uploadDir = new File(uploadPath).getParentFile();
            if (!uploadDir.exists()) {
                logger.info("Creating directory: " + uploadDir.getAbsolutePath());
                if (!uploadDir.mkdirs()) {
                    logger.severe("Failed to create directory: " + uploadDir.getAbsolutePath());
                    request.setAttribute("error", "Failed to create image directory.");
                    forwardToAddCourses(request, response, session);
                    return;
                }
            }

            // Lưu file ảnh
            try {
                filePart.write(uploadPath);
                imagePath = "image/" + fileName; // Đường dẫn tương đối để lưu vào cơ sở dữ liệu
                logger.info("Image saved successfully with path: " + imagePath);
            } catch (IOException e) {
                logger.severe("Error saving image: " + e.getMessage());
                request.setAttribute("error", "Failed to save image: " + e.getMessage());
                forwardToAddCourses(request, response, session);
                return;
            }
        } else {
            logger.warning("No file part or file size is 0 for image.");
            request.setAttribute("error", "Image is required.");
        }

        try {
            if (name == null || name.trim().isEmpty() || description == null || description.trim().isEmpty() || imagePath == null) {
                request.setAttribute("error", "Course name, description, and image are required.");
            } else {
                courseDAO.saveCourse(name, description, teacherId, imagePath);
                request.setAttribute("success", "Course added successfully!");
            }

            forwardToAddCourses(request, response, session);

        } catch (Exception e) {
            logger.severe("Error: " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
            forwardToAddCourses(request, response, session);
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
            User user = userDAO.findByUsername(username);
            if (user == null) {
                request.setAttribute("error", "User not found.");
                request.getRequestDispatcher("/view/courses.jsp").forward(request, response);
                return;
            }
            List<Course> courses = courseDAO.getCoursesByTeacherId(user.getId());
            request.setAttribute("user", user);
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/view/courses.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void forwardToAddCourses(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        try {
            int teacherId = Integer.parseInt((String) session.getAttribute("teacher_id"));
            User user = userDAO.findByUsername((String) session.getAttribute("username"));
            List<Course> courses = courseDAO.getCoursesByTeacherId(teacherId);
            request.setAttribute("user", user);
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/view/courses.jsp").forward(request, response);
        } catch (Exception e) {
            logger.warning("Failed to load courses: " + e.getMessage());
            request.getRequestDispatcher("/view/courses.jsp").forward(request, response);
        }
    }
}