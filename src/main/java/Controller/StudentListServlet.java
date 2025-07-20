package Controller;

import DAO.CourseDAO;
import DAO.EnrollmentDAO;
import Model.Course;
import Model.Enrollment;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class StudentListServlet extends HttpServlet {
    private final CourseDAO courseDAO = new CourseDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("view/signIn.jsp");
            return;
        }

        try {
            Integer teacherIdObj = (Integer) session.getAttribute("teacherId");
            if (teacherIdObj == null) {
                request.setAttribute("error", "Teacher ID is not set in session. Please log in again.");
                request.getRequestDispatcher("/view/studentList.jsp").forward(request, response);
                return;
            }
            int teacherId = teacherIdObj.intValue();

            List<Course> courses = courseDAO.getCoursesByTeacherId(teacherId);
            if (courses != null && !courses.isEmpty()) {
                for (Course course : courses) {
                    List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByCourseId(course.getIdCourse());
                    course.setEnrollments(enrollments);
                    if (enrollments != null) {
                        List<User> students = new ArrayList<>();
                        for (Enrollment enrollment : enrollments) {
                            students.add(enrollment.getStudent());
                        }
                        course.setStudents(students);
                    }
                }
            } else {
                System.out.println("No courses found for teacherId: " + teacherId);
            }

            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/view/studentList.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving student list: " + e.getMessage());
            request.getRequestDispatcher("/view/studentList.jsp").forward(request, response);
        }
    }
}