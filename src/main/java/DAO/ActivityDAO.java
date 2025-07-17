package DAO;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

public class ActivityDAO {
    private final DBcontext dbContext = new DBcontext();
    private static final Logger logger = Logger.getLogger(ActivityDAO.class.getName());

    public void logLogin(String username) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO user_activity (username, login_time) VALUES (?, NOW())")) {
            pstmt.setString(1, username);
            pstmt.executeUpdate();
        }
    }

    public void logLogout(String username) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "UPDATE user_activity SET logout_time = NOW(), duration_minutes = TIMESTAMPDIFF(MINUTE, login_time, NOW()) WHERE username = ? AND logout_time IS NULL")) {
            pstmt.setString(1, username);
            pstmt.executeUpdate();
        }
    }

    public Map<String, Integer> getUserActivity(String username) throws SQLException, Exception {
        Map<String, Integer> onlineTimes = new HashMap<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT DATE(login_time) as activity_date, COALESCE(SUM(duration_minutes), 0) as total_minutes FROM user_activity WHERE username = ? AND login_time >= DATE_SUB(NOW(), INTERVAL 30 DAY) GROUP BY DATE(login_time)")) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String date = rs.getString("activity_date");
                    int minutes = rs.getInt("total_minutes");
                    onlineTimes.put(date, minutes);
                }
            }
        }
        return onlineTimes;
    }

    public int getTotalActivityForDate(String username, String date) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT COALESCE(SUM(duration_minutes), 0) as total_minutes FROM user_activity WHERE username = ? AND DATE(login_time) = ?")) {
            pstmt.setString(1, username);
            pstmt.setString(2, date);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_minutes");
                }
            }
        }
        return 0;
    }
}