package DAO;

import Model.Course;
import Model.Lecture;
import Model.Assignment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class CourseDAO {
    private final DBcontext dbContext = new DBcontext();
    private static final Logger logger = Logger.getLogger(CourseDAO.class.getName());

    public int saveCourse(String name, String description, int teacherId, String image) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO learning_management.Courses (name, description, teacher_id, image) VALUES (?, ?, ?, ?)",
                     Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, name);
            pstmt.setString(2, description);
            pstmt.setInt(3, teacherId);
            pstmt.setString(4, image);
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating course failed, no rows affected.");
            }

            try (ResultSet keys = pstmt.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                } else {
                    throw new SQLException("Creating course failed, no ID obtained.");
                }
            }
        }
    }

    public List<Course> getCourses() throws SQLException, Exception {
        List<Course> courses = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT id, name, description, teacher_id, image FROM learning_management.Courses");
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Course course = new Course(
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("teacher_id"),
                        rs.getString("image")
                );
                course.setIdCourse(rs.getInt("id"));
                courses.add(course);
            }

            for (Course course : courses) {
                // Get Lectures
                try (PreparedStatement lectureStmt = conn.prepareStatement(
                        "SELECT id, course_id, title, video_url, status FROM learning_management.Lectures WHERE course_id = ?")) {
                    lectureStmt.setInt(1, course.getIdCourse());
                    try (ResultSet lectureRs = lectureStmt.executeQuery()) {
                        List<Lecture> lectures = new ArrayList<>();
                        while (lectureRs.next()) {
                            Lecture lecture = new Lecture(
                                    course.getIdCourse(),
                                    lectureRs.getString("title"),
                                    lectureRs.getString("video_url"),
                                    lectureRs.getString("status")
                            );
                            lecture.setIdLecture(lectureRs.getInt("id"));
                            lectures.add(lecture);
                        }
                        course.setLectures(lectures);
                    }
                }

                // Get Assignments
                try (PreparedStatement assignStmt = conn.prepareStatement(
                        "SELECT * FROM learning_management.Assignments WHERE course_id = ?")) {
                    assignStmt.setInt(1, course.getIdCourse());
                    try (ResultSet assignRs = assignStmt.executeQuery()) {
                        List<Assignment> assignments = new ArrayList<>();
                        while (assignRs.next()) {
                            Assignment assignment = new Assignment(
                                    course.getIdCourse(),
                                    assignRs.getInt("lecture_id") > 0 ? assignRs.getInt("lecture_id") : null,
                                    assignRs.getString("title"),
                                    assignRs.getString("description"),
                                    new com.google.api.client.util.DateTime(assignRs.getTimestamp("due_date")),
                                    assignRs.getString("status")
                            );
                            assignment.setIdAss(assignRs.getInt("id"));
                            assignments.add(assignment);
                        }
                        course.setAssignments(assignments);
                    }
                }
            }
        }
        return courses;
    }

   public List<Course> getCoursesByTeacherId(int teacherId) throws SQLException, Exception {
    List<Course> courses = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = dbContext.getConnection();
        String sql = "SELECT id, name, description, teacher_id,image FROM learning_management.Courses WHERE teacher_id = ?;";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, teacherId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Course course = new Course(
                rs.getString("name"),
                rs.getString("description"),
                rs.getInt("teacher_id"),
                rs.getString("image")
            );
            course.setIdCourse(rs.getInt("id"));
            courses.add(course);
        }

        return courses;

    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) dbContext.closeConnection(conn);
    }
}

    public void deleteCourse(int id) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "DELETE FROM learning_management.Courses WHERE id = ?")) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }

    public void updateCourse(int id, String name, String description, String image) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "UPDATE learning_management.Courses SET name = ?, description = ?, image = ? WHERE id = ?;")) {
            pstmt.setString(1, name);
            pstmt.setString(2, description);
            pstmt.setString(3, image);
            pstmt.setInt(4, id);
            pstmt.executeUpdate();
        }
    }
    public Course getCourseById(int id) throws SQLException, Exception {
    Course course = null;
    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(
                 "SELECT id, name, description, teacher_id, image FROM learning_management.Courses WHERE id = ?;")) {
        pstmt.setInt(1, id);
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                course = new Course(
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("teacher_id"),
                        rs.getString("image")
                );
                course.setIdCourse(rs.getInt("id"));
            }
        }
    }
    return course;
}
}