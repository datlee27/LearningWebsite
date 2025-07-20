package DAO;

import Model.Lecture;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class LectureDAO {
    private final DBcontext dbContext = new DBcontext();
    private static final Logger logger = Logger.getLogger(LectureDAO.class.getName());

    public int saveLecture(int courseId, String title, String videoUrl, String status) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO learning_management.Lectures (course_id, title, video_url, status) VALUES (?, ?, ?, ?)",
                     Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, courseId);
            pstmt.setString(2, title);
            pstmt.setString(3, videoUrl != null ? videoUrl : "");
            pstmt.setString(4, status);
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating lecture failed, no rows affected.");
            }

            try (ResultSet keys = pstmt.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                } else {
                    throw new SQLException("Creating lecture failed, no ID obtained.");
                }
            }
        }
    }

    public List<Lecture> getLecturesByCourseId(int courseId) throws SQLException, Exception {
        List<Lecture> lectures = new ArrayList<>();
        logger.info("Attempting to load lectures for courseId: " + courseId);
        if (courseId <= 0) {
            logger.warning("Invalid courseId: " + courseId);
            return lectures;
        }

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT id, course_id, title, video_url, status FROM learning_management.Lectures WHERE course_id = ?")) {
            pstmt.setInt(1, courseId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Lecture lecture = new Lecture();
                    lecture.setId(rs.getInt("id"));
                    lecture.setIdCourse(rs.getInt("course_id"));
                    lecture.setTitle(rs.getString("title"));
                    lecture.setVideoUrl(rs.getString("video_url"));
                    lecture.setStatus(rs.getString("status"));
                    lectures.add(lecture);
                }
            }
            logger.info("Loaded " + lectures.size() + " lectures for courseId: " + courseId);
        } catch (SQLException e) {
            logger.severe("Database error in getLecturesByCourseId: " + e.getMessage());
            throw e;
        }
        return lectures;
    }
    public Lecture getLectureById(int id) throws SQLException, Exception {
    Lecture lecture = null;
    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(
                 "SELECT id, course_id, title, video_url, status FROM learning_management.Lectures WHERE id = ?")) {
        pstmt.setInt(1, id);
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                lecture = new Lecture();
                lecture.setIdLecture(rs.getInt("id"));
                lecture.setIdCourse(rs.getInt("course_id"));
                lecture.setTitle(rs.getString("title"));
                lecture.setVideoUrl(rs.getString("video_url"));
                lecture.setStatus(rs.getString("status"));
            }
        }
    }
    return lecture;
}
}