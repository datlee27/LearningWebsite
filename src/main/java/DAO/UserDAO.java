package DAO;

import Model.User;
import com.google.api.client.util.DateTime;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.logging.Logger;

public class UserDAO {
    private final DBcontext dbContext = new DBcontext();
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());

    public void save(User user) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO learning_management.Users (username, password, email, role, google_id) VALUES (?, ?, ?, ?, ?)",
                     Statement.RETURN_GENERATED_KEYS)) {
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
        }
    }

    public User authenticate(String identifier, String password, String googleIdToken) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection()) {
            if (googleIdToken != null) {
                return null;
            }
            String sql = "SELECT id, username, password, email, role, google_id FROM learning_management.Users WHERE (username = ? OR email = ?)";
            logger.info("Authenticating with identifier: " + identifier + ", password length: " + (password != null ? password.length() : 0));
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, identifier);
                pstmt.setString(2, identifier);
                try (ResultSet rs = pstmt.executeQuery()) {
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
                                logger.warning("Password mismatch for identifier: " + identifier);
                            }
                        } else {
                            logger.warning("No password found for identifier: " + identifier);
                        }
                    } else {
                        logger.warning("No user found for identifier: " + identifier);
                    }
                }
            }
        }
        return null;
    }

    public User findByUsername(String username) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT id, username, password, email, role, google_id FROM learning_management.Users WHERE username = ?")) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapToUser(rs);
                }
            }
        }
        return null;
    }

    public User findByGoogleId(String googleId) throws SQLException, Exception {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT id, username, password, email, role, google_id FROM learning_management.Users WHERE google_id = ?")) {
            pstmt.setString(1, googleId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapToUser(rs);
                }
            }
        }
        return null;
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
 public User getUserById(int studentId) throws SQLException, Exception {
    String sql = "SELECT * FROM learning_management.Users WHERE id = ?";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, studentId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFirstName(rs.getString("first_name")); // Match database column
                user.setLastName(rs.getString("last_name"));   // Match database column
                return user;
            }
        }
    }
    return null;
}
}