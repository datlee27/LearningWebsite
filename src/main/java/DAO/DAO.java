package DAO;

import Model.*;
import com.google.api.client.util.DateTime;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

public class DAO {
    private final DBcontext dbContext = new DBcontext();
    private static final Logger logger = Logger.getLogger(DAO.class.getName());

    public void save(User user) throws SQLException, Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = dbContext.getConnection();
            String sql = "INSERT INTO learning_management.Users (username, password, email, role, google_id) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword() != null ? BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()) : null);
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getRole());
            pstmt.setString(5, user.getGoogleId());
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close ResultSet: " + e.getMessage());
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close PreparedStatement: " + e.getMessage());
                }
            }
            if (conn != null) {
                dbContext.closeConnection(conn);
            }
        }
    }

    public User authenticate(String identifier, String password, String googleIdToken) throws SQLException, Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = dbContext.getConnection();
            if (googleIdToken != null) {
                return null;
            } else {
                String sql = "SELECT id, username, password, email, role, google_id FROM learning_management.Users WHERE (username = ? OR email = ?)";
                logger.info("Authenticating with identifier: " + identifier + ", password length: " + (password != null ? password.length() : 0));
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, identifier);
                pstmt.setString(2, identifier);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String logPassword = storedPassword != null && !storedPassword.isEmpty() ? storedPassword.substring(0, Math.min(10, storedPassword.length())) + "..." : "null";
                    logger.info("Found user: " + rs.getString("username") + ", stored password hash: " + logPassword);
                    if (storedPassword != null) {
                        if (BCrypt.checkpw(password, storedPassword)) {
                            logger.info("Authentication successful with BCrypt for user: " + rs.getString("username"));
                            return mapToUser(rs);
                        } else if (password != null && password.equals(storedPassword)) {
                            logger.warning("Authentication successful with plain text match (temporary) for user: " + rs.getString("username"));
                            return mapToUser(rs);
                        } else {
                            logger.warning("Password mismatch for identifier: " + identifier + ". Input: " + (password != null ? password.substring(0, Math.min(5, password.length())) + "..." : "null"));
                        }
                    } else {
                        logger.warning("No password found for identifier: " + identifier);
                    }
                } else {
                    logger.warning("No user found for identifier: " + identifier);
                }
            }
        } catch (SQLException e) {
            logger.severe("Database error during authentication: " + e.getMessage());
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) dbContext.closeConnection(conn);
        }
        return null;
    }


    public User findByUsername(String username) throws SQLException, Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {

            conn = dbContext.getConnection();
            String sql = "SELECT id, username, password, email, role, google_id FROM learning_management.Users WHERE username = ?;";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapToUser(rs);
            }
            return null;
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close ResultSet: " + e.getMessage());
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close PreparedStatement: " + e.getMessage());
                }
            }
            if (conn != null) {
                dbContext.closeConnection(conn);
            }
        }
    }

    public User findByGoogleId(String googleId) throws SQLException, Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = dbContext.getConnection();
            String sql = "SELECT id, username, password, email, role, google_id FROM learning_management.Users WHERE google_id = ?;";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, googleId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapToUser(rs);
            }
            return null;
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close ResultSet: " + e.getMessage());
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close PreparedStatement: " + e.getMessage());
                }
            }
            if (conn != null) {
                dbContext.closeConnection(conn);
            }
        }
    }

    public void logLogin(String username) throws SQLException, Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = dbContext.getConnection();
            String sql = "INSERT INTO user_activity (username, login_time) VALUES (?, NOW());";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.executeUpdate();
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close PreparedStatement: " + e.getMessage());
                }
            }
            if (conn != null) {
                dbContext.closeConnection(conn);
            }
        }
    }

    public void logLogout(String username) throws SQLException, Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = dbContext.getConnection();
            String sql = "UPDATE user_activity SET logout_time = NOW(), duration_minutes = TIMESTAMPDIFF(MINUTE, login_time, NOW()) WHERE username = ? AND logout_time IS NULL;";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.executeUpdate();
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close PreparedStatement: " + e.getMessage());
                }
            }
            if (conn != null) {
                dbContext.closeConnection(conn);
            }
        }
    }

    public Map<String, Integer> getUserActivity(String username) throws SQLException, Exception {
        Map<String, Integer> onlineTimes = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = dbContext.getConnection();
            String sql = "SELECT DATE(login_time) as activity_date, COALESCE(SUM(duration_minutes), 0) as total_minutes FROM user_activity WHERE username = ? AND login_time >= DATE_SUB(NOW(), INTERVAL 30 DAY) GROUP BY DATE(login_time);";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                String date = rs.getString("activity_date");
                int minutes = rs.getInt("total_minutes");
                onlineTimes.put(date, minutes);
            }
            return onlineTimes;
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close ResultSet: " + e.getMessage());
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close PreparedStatement: " + e.getMessage());
                }
            }
            if (conn != null) {
                dbContext.closeConnection(conn);
            }
        }
    }

    public int getTotalActivityForDate(String username, String date) throws SQLException, Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = dbContext.getConnection();
            String sql = "SELECT COALESCE(SUM(duration_minutes), 0) as total_minutes FROM user_activity WHERE username = ? AND DATE(login_time) = ?;";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, date);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_minutes");
            }
            return 0;
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close ResultSet: " + e.getMessage());
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close PreparedStatement: " + e.getMessage());
                }
            }
            if (conn != null) {
                dbContext.closeConnection(conn);
            }
        }
    }

    public int saveCourse(String name, String description, int teacherId,String image) throws SQLException, Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet generatedKeys = null;
        try {
            conn = dbContext.getConnection();
            String sql = "INSERT INTO learning_management.Courses (name, description, teacher_id,image) VALUES (?, ?, ?,?);";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
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
        } finally {
            if (generatedKeys != null) {
                try {
                    generatedKeys.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close ResultSet: " + e.getMessage());
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close PreparedStatement: " + e.getMessage());
                }
            }
            if (conn != null) {
                dbContext.closeConnection(conn);
            }
        }
    }

   public int saveLecture(int courseId, String title, String videoUrl, String status) throws SQLException, Exception {
    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO learning_management.Lectures (course_id, title, video_url, status) VALUES (?, ?, ?, ?);",
                Statement.RETURN_GENERATED_KEYS)) {

        pstmt.setInt(1, courseId);
        pstmt.setString(2, title);
        pstmt.setString(3, videoUrl != null ? videoUrl : "");
        pstmt.setString(4, status);
        int affectedRows = pstmt.executeUpdate();

        if (affectedRows == 0) throw new SQLException("Creating lecture failed, no rows affected.");

        try (ResultSet keys = pstmt.getGeneratedKeys()) {
            if (keys.next()) return keys.getInt(1);
            else throw new SQLException("Creating lecture failed, no ID obtained.");
        }
    }

}
    public int saveAssignment(int courseId, Integer idLecture, String title, String description, Timestamp dueDate, String status) throws SQLException, Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet generatedKeys = null;
        try {
            conn = dbContext.getConnection();
            String sql = "INSERT INTO learning_management.Assignments (course_id, lecture_id, title, description, due_date, status) VALUES (?, ?, ?, ?, ?, ?);";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
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
        } finally {
            if (generatedKeys != null) {
                try {
                    generatedKeys.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close ResultSet: " + e.getMessage());
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    logger.warning("Failed to close PreparedStatement: " + e.getMessage());
                }
            }
            if (conn != null) {
                dbContext.closeConnection(conn);
            }
        }
    }

   public List<Course> getCourses() throws SQLException, Exception {
    List<Course> courses = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        conn = dbContext.getConnection();
        String sql = "SELECT id, name, description, teacher_id,image FROM learning_management.Courses;";
        pstmt = conn.prepareStatement(sql);
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

        for (Course course : courses) {
            // Get Lectures
            sql = "SELECT id, course_id, title, video_url, status FROM learning_management.Lectures WHERE course_id = ?;";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, course.getIdCourse());
            rs = pstmt.executeQuery();
            List<Lecture> lectures = new ArrayList<>();
            while (rs.next()) {
                Lecture lecture = new Lecture(
                    course.getIdCourse(),
                    rs.getString("title"),
                    rs.getString("video_url"),
                    rs.getString("status")
                );
                lecture.setIdLecture(rs.getInt("id")); // Fixed: Changed idLecture to id
                lectures.add(lecture);
            }
            course.setLectures(lectures);

            // Get Assignments
            sql = "SELECT * FROM learning_management.Assignments WHERE course_id = ?;";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, course.getIdCourse());
            rs = pstmt.executeQuery();
            List<Assignment> assignments = new ArrayList<>();
            while (rs.next()) {
                Assignment assignment = new Assignment(
                    course.getIdCourse(),
                    rs.getInt("lecture_id") > 0 ? rs.getInt("lecture_id") : null,
                    rs.getString("title"),
                    rs.getString("description"),
                    new com.google.api.client.util.DateTime(rs.getTimestamp("due_date")),
                    rs.getString("status")
                );
                assignment.setIdAss(rs.getInt("id"));
                assignments.add(assignment);
            }
            course.setAssignments(assignments);
        }
        return courses;
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) dbContext.closeConnection(conn);
    }
}


    private User mapToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setGoogleId(rs.getString("google_id"));
        return user;
    }
    
    public List<Course> getCoursesByTeacherId(int teacherId) throws SQLException, Exception {
    List<Course> courses = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = dbContext.getConnection();
        String sql = "SELECT id, name, description, teacher_id,image FROM learning_management.Courses WHERE teacher_id = ?";
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
    Connection conn = dbContext.getConnection();
    String sql = "DELETE FROM learning_management.Courses WHERE id = ?;";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, id);
    pstmt.executeUpdate();
    pstmt.close(); conn.close();
}

public void updateCourse(int id, String name, String description,String image ) throws SQLException, Exception {
    Connection conn = dbContext.getConnection();
    String sql = "UPDATE learning_management.Courses SET name = ?, description = ?,image= ? WHERE id = ?;";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, name);
    pstmt.setString(2, description);
    pstmt.setInt(4, id);
    pstmt.setString(3, image);
    pstmt.executeUpdate();
    pstmt.close(); conn.close();
}
public List<Lecture> getLecturesByCourseId(int courseId) throws SQLException, Exception {
    List<Lecture> lectures = new ArrayList<>();
    logger.info("Attempting to load lectures for courseId: " + courseId);
    if (courseId <= 0) {
        logger.warning("Invalid courseId: " + courseId);
        return lectures; // Trả về danh sách rỗng nếu courseId không hợp lệ
    }

    String sql = "SELECT id, course_id, title, video_url, status FROM learning_management.Lectures WHERE course_id = ?;";
    
    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {

        pstmt.setInt(1, courseId); // ✅ phải set trước
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