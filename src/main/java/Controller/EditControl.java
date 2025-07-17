package Controller;

import DAO.CourseDAO;

import DAO.LectureDAO;
import DAO.UserDAO;
import Model.Course;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Limit file size to 5MB
public class EditControl extends HttpServlet {
    private static final Logger logger = Logger.getLogger(EditControl.class.getName());
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

        // Get form parameters
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        // Handle image upload
        String imagePath = null;
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            // Use absolute path to the image directory
            String uploadPath = "/Users/mac/NetBeansProjects/PRJ301/learning_project/src/main/webapp/image/" + fileName;
            logger.info("Attempting to save image to: " + uploadPath);

            // Ensure the image directory exists
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

            // Save the image file
            try {
                filePart.write(uploadPath);
                imagePath = "image/" + fileName; // Relative path for database storage
                logger.info("Image saved successfully with path: " + imagePath);
            } catch (IOException e) {
                logger.severe("Error saving image: " + e.getMessage());
                request.setAttribute("error", "Failed to save image: " + e.getMessage());
                forwardToAddCourses(request, response, session);
                return;
            }
        } else {
            // If no new image is uploaded, retain the existing image (you may need to fetch it from DB)
            imagePath = request.getParameter("currentImage"); // Add a hidden field in the form for current image
            if (imagePath == null || imagePath.trim().isEmpty()) {
                logger.warning("No file part or file size is 0 for image.");
                request.setAttribute("error", "Image is required.");
                forwardToAddCourses(request, response, session);
                return;
            }
        }

        try {
            if (name == null || name.trim().isEmpty() || description == null || description.trim().isEmpty()) {
                request.setAttribute("error", "Course name and description are required.");
            } else {
                courseDAO.updateCourse(id, name, description, imagePath);
                request.setAttribute("success", "Course updated successfully!");
            }
            forwardToAddCourses(request, response, session);
        } catch (Exception e) {
            logger.severe("Error updating course: " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
            forwardToAddCourses(request, response, session);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().println("EditControl Servlet is working.");
    }

    private void forwardToAddCourses(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
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
            logger.warning("Failed to load courses: " + e.getMessage());
            request.getRequestDispatcher("/view/courses.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles course editing with image upload.";
    }
}