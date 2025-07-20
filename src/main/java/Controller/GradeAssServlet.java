package Controller;

import DAO.AssignmentDAO;
import DAO.SubmissionDAO;
import DAO.UserDAO;
import DAO.CourseDAO;
import DAO.LectureDAO;
import Model.Assignment;
import Model.Course;
import Model.Lecture;
import Model.Submission;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class GradeAssServlet extends HttpServlet {
    private final SubmissionDAO submissionDAO = new SubmissionDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final UserDAO userDAO = new UserDAO();
    private final CourseDAO courseDAO = new CourseDAO();
    private final LectureDAO lectureDAO = new LectureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        System.out.println("Session exists: " + (session != null) + ", Role: " + (session != null ? session.getAttribute("role") : "null"));
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            System.out.println("Redirecting to signIn.jsp due to invalid session/role");
            response.sendRedirect("view/signIn.jsp");
            return;
        }

        try {
            User teacher = (User) session.getAttribute("user");
            if (teacher == null) {
                throw new Exception("Teacher user not found in session");
            }

            List<Course> courses = courseDAO.getCoursesByTeacherId(teacher.getId());
            System.out.println("Found courses for teacher: " + courses.size());

            List<Assignment> allAssignments = new ArrayList<>();
            for (Course course : courses) {
                List<Assignment> assignments = assignmentDAO.getAssignmentsByCourseId(course.getIdCourse());
                allAssignments.addAll(assignments);
            }
            System.out.println("Found assignments: " + allAssignments.size());

            List<Submission> allSubmissions = new ArrayList<>();
            for (Assignment assignment : allAssignments) {
                List<Submission> submissions = submissionDAO.getSubmissionsBeforeDueDate(assignment.getIdAss(), assignment.getDueDateAsJavaUtilDate());
                allSubmissions.addAll(submissions);
            }
            System.out.println("Total submissions found: " + allSubmissions.size());

            // Enrich submissions with course and lecture details
            for (Submission s : allSubmissions) {
                if (s.getAssignment() != null) {
                    Course course = courseDAO.getCourseById(s.getAssignment().getIdCourse());
                    if (course != null) {
                        s.getAssignment().setCourseName(course.getName());
                    }
                    if (s.getAssignment().getIdLecture() != null) {
                        Lecture lecture = lectureDAO.getLectureById(s.getAssignment().getIdLecture());
                        if (lecture != null) {
                            s.getAssignment().setLectureTitle(lecture.getTitle());
                        }
                    }
                }
            }

            request.setAttribute("submissions", allSubmissions);
            if (!allAssignments.isEmpty()) {
                request.setAttribute("assignment", allAssignments.get(0));
            }

            request.getRequestDispatcher("/view/gradeAssignments.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception occurred: " + e.getMessage());
            request.setAttribute("error", "Error retrieving submissions: " + e.getMessage());
            request.getRequestDispatcher("/view/gradeAssignments.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        System.out.println("Session exists in POST: " + (session != null) + ", Role: " + (session != null ? session.getAttribute("role") : "null"));
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            System.out.println("Redirecting to signIn.jsp in POST due to invalid session/role");
            response.sendRedirect("view/signIn.jsp");
            return;
        }

        try {
            int submissionId = Integer.parseInt(request.getParameter("submissionId"));
            double grade = Double.parseDouble(request.getParameter("grade"));
            System.out.println("Updating grade for submissionId: " + submissionId + " with grade: " + grade);

            submissionDAO.updateGrade(submissionId, grade);
            response.sendRedirect(request.getContextPath() + "/gradeAssignments");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception in POST: " + e.getMessage());
            request.setAttribute("error", "Failed to grade submission: " + e.getMessage());
            request.getRequestDispatcher("/view/gradeAssignments.jsp").forward(request, response);
        }
    }
}