package DAO;

import Model.Course;
import Model.Enrollment;
import Model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class EnrollmentDAO {
    private final DBcontext dbContext = new DBcontext();
    private static final Logger logger = Logger.getLogger(EnrollmentDAO.class.getName());

    public void save(Enrollment enrollment) throws SQLException, Exception {
        String sql = "INSERT INTO learning_management.Enrollments (student_id, course_id, enrollment_date, status) VALUES (?, ?, ?, ?);";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, enrollment.getStudent().getId());
            pstmt.setInt(2, enrollment.getCourse().getIdCourse());
            pstmt.setObject(3, enrollment.getEnrollmentDate());
            pstmt.setString(4, enrollment.getStatus());
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating enrollment failed, no rows affected.");
            }
            logger.info("Enrollment saved successfully for studentId: " + enrollment.getStudent().getId() + ", courseId: " + enrollment.getCourse().getIdCourse());
        }
    }

    public void update(Enrollment enrollment) throws SQLException, Exception {
        String sql = "UPDATE learning_management.Enrollments SET enrollment_date = ?, status = ? WHERE student_id = ? AND course_id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, enrollment.getEnrollmentDate());
            pstmt.setString(2, enrollment.getStatus());
            pstmt.setInt(3, enrollment.getStudent().getId());
            pstmt.setInt(4, enrollment.getCourse().getIdCourse());
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Updating enrollment failed, no rows affected.");
            }
            logger.info("Enrollment updated successfully for studentId: " + enrollment.getStudent().getId() + ", courseId: " + enrollment.getCourse().getIdCourse());
        }
    }

    public Enrollment findById(int studentId, int courseId) throws SQLException, Exception {
        String sql = "SELECT e.student_id, e.course_id, e.enrollment_date, e.status, u.*, c.* " +
                     "FROM learning_management.Enrollments e " +
                     "JOIN learning_management.Users u ON e.student_id = u.id " +
                     "JOIN learning_management.Courses c ON e.course_id = c.id_course " +
                     "WHERE e.student_id = ? AND e.course_id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Enrollment enrollment = mapToEnrollment(rs);
                    logger.info("Found enrollment for studentId: " + studentId + ", courseId: " + courseId);
                    return enrollment;
                }
            }
        }
        logger.warning("No enrollment found for studentId: " + studentId + ", courseId: " + courseId);
        return null;
    }

    public List<Enrollment> findByCourseId(int courseId) throws SQLException, Exception {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT e.student_id, e.course_id, e.enrollment_date, e.status, u.*, c.* " +
                     "FROM learning_management.Enrollments e " +
                     "JOIN learning_management.Users u ON e.student_id = u.id " +
                     "JOIN learning_management.Courses c ON e.course_id = c.id_course " +
                     "WHERE e.course_id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, courseId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Enrollment enrollment = mapToEnrollment(rs);
                    enrollments.add(enrollment);
                    logger.info("Found enrollment for courseId: " + courseId + ", studentId: " + rs.getInt("student_id"));
                }
            }
        }
        logger.info("Total enrollments found for courseId " + courseId + ": " + enrollments.size());
        return enrollments;
    }

    public void delete(Enrollment enrollment) throws SQLException, Exception {
        String sql = "DELETE FROM learning_management.Enrollments WHERE student_id = ? AND course_id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, enrollment.getStudent().getId());
            pstmt.setInt(2, enrollment.getCourse().getIdCourse());
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Deleting enrollment failed, no rows affected.");
            }
            logger.info("Enrollment deleted successfully for studentId: " + enrollment.getStudent().getId() + ", courseId: " + enrollment.getCourse().getIdCourse());
        }
    }

    public List<User> getStudentsByCourseId(int courseId) throws SQLException, Exception {
        List<User> students = new ArrayList<>();
        String sql = "SELECT u.* FROM learning_management.Users u " +
                     "JOIN learning_management.Enrollments e ON u.id = e.student_id " +
                     "WHERE e.course_id = ? AND u.role = 'student'";
        logger.info("Fetching students for courseId: " + courseId);
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, courseId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    User student = new User();
                    student.setId(rs.getInt("id"));
                    student.setFirstName(rs.getString("first_name"));
                    student.setLastName(rs.getString("last_name"));
                    student.setUsername(rs.getString("username"));
                    student.setEmail(rs.getString("email"));
                    student.setRole(rs.getString("role"));
                    student.setGoogleId(rs.getString("google_id"));
                    student.setDateOfBirth(rs.getDate("date_of_birth"));
                    student.setGender(rs.getString("gender"));
                    student.setAddress(rs.getString("address"));
                    student.setPhoneNumber(rs.getString("phone"));
                    student.setSchool(rs.getString("school"));
                    students.add(student);
                    logger.info("Found student: ID=" + student.getId() + ", Name=" + student.getFirstName() + " " + student.getLastName());
                }
            }
        }
        logger.info("Total students found for courseId " + courseId + ": " + students.size());
        return students;
    }
public List<Enrollment> getEnrollmentsByCourseId(int courseId) throws SQLException, Exception {
        List<Enrollment> enrollments = new ArrayList<>();
      String sql = "SELECT e.student_id, e.course_id, e.enrollment_date, e.status, " +
             "u.*, c.id AS id_course, c.name, c.description, c.teacher_id, c.image " +
             "FROM learning_management.Enrollments e " +
             "JOIN learning_management.Users u ON e.student_id = u.id " +
             "JOIN learning_management.Courses c ON e.course_id = c.id " +
             "WHERE e.course_id = ? AND u.role = 'student'";
        logger.info("Executing query: " + sql.replace("?", String.valueOf(courseId)));
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, courseId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Enrollment enrollment = mapToEnrollment(rs);
                    enrollments.add(enrollment);
                    logger.info("Found enrollment: studentId=" + rs.getInt("student_id") + ", enrollmentDate=" + rs.getObject("enrollment_date"));
                }
            }
        } catch (SQLException e) {
            logger.severe("SQL Exception: " + e.getMessage() + " | Query: " + sql + " | CourseId: " + courseId);
            throw e;
        }
        logger.info("Total enrollments found for courseId " + courseId + ": " + enrollments.size());
        return enrollments;
    }
    
    private Enrollment mapToEnrollment(ResultSet rs) throws SQLException {
        Enrollment enrollment = new Enrollment();
        enrollment.setId(new Model.EnrollmentId(rs.getInt("student_id"), rs.getInt("course_id")));
        
        User student = new User();
        student.setId(rs.getInt("id"));
        student.setFirstName(rs.getString("first_name"));
        student.setLastName(rs.getString("last_name"));
        student.setUsername(rs.getString("username"));
        student.setEmail(rs.getString("email"));
        student.setRole(rs.getString("role"));
        student.setGoogleId(rs.getString("google_id"));
        student.setDateOfBirth(rs.getDate("date_of_birth"));
        student.setGender(rs.getString("gender"));
        student.setAddress(rs.getString("address"));
        student.setPhoneNumber(rs.getString("phone"));
        student.setSchool(rs.getString("school"));
        enrollment.setStudent(student);

        Course course = new Course(
            rs.getString("name"),
            rs.getString("description"),
            rs.getInt("teacher_id"),
            rs.getString("image")
        );
        course.setIdCourse(rs.getInt("id_course"));
        enrollment.setCourse(course);

        enrollment.setEnrollmentDate(rs.getObject("enrollment_date", LocalDateTime.class));
        enrollment.setStatus(rs.getString("status"));
        return enrollment;
    }
}