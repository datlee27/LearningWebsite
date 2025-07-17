package DAO;

import Model.Assignment;
import com.google.api.client.util.DateTime;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class AssignmentDAO {
    private final DBcontext dbContext = new DBcontext();
    private static final Logger logger = Logger.getLogger(AssignmentDAO.class.getName());

    public int saveAssignment(int courseId, Integer idLecture, String title, String description, Timestamp dueDate, String status) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO learning_management.Assignments (course_id, lecture_id, title, description, due_date, status) VALUES (?, ?, ?, ?, ?, ?)",
                     Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, courseId);
            if (idLecture != null && idLecture > 0) {
                pstmt.setInt(2, idLecture);
            } else {
                pstmt.setNull(2, Types.INTEGER);
            }
            pstmt.setString(3, title);
            pstmt.setString(4, description);
            pstmt.setTimestamp(5, dueDate);
            pstmt.setString(6, status);
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating assignment failed, no rows affected.");
            }

            try (ResultSet keys = pstmt.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                } else {
                    throw new SQLException("Creating assignment failed, no ID obtained.");
                }
            }
        }
    }

    public List<Assignment> getAssignmentsByLecture(int courseId, int lectureId) throws SQLException, Exception {
    List<Assignment> list = new ArrayList<>();
    String sql = "SELECT * FROM learning_management.Assignments WHERE course_id = ? AND lecture_id = ?;";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt  = conn.prepareStatement(sql)) {
        pstmt.setInt(1, courseId);
        pstmt.setInt(2, lectureId);
        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            Assignment a = new Assignment(
                rs.getInt("course_id"),
                rs.getInt("lecture_id"),
                rs.getString("title"),
                rs.getString("description"),
                new DateTime(rs.getTimestamp("due_date").getTime()),
                rs.getString("status")
            );
            a.setIdAss(rs.getInt("id"));
            list.add(a);
        }
    }
    return list;
}
}