package Controller;

import DAO.ActivityDAO;
import DAO.UserDAO;
import Model.User;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import com.google.gson.Gson;
import com.google.api.client.json.gson.GsonFactory;
import java.io.BufferedReader;
import java.text.SimpleDateFormat;
import java.util.logging.Logger;

public class LoginServlet extends HttpServlet {

    private static final String GOOGLE_CLIENT_ID = "463263011713-mrrbjqdmf75o6r3lofr88hougr4imc9a.apps.googleusercontent.com";
    private final UserDAO userDAO = new UserDAO();
    private final ActivityDAO activityDAO = new ActivityDAO();
    private final GoogleIdTokenVerifier verifier;
    private final Gson gson = new Gson();
    private static final Logger logger = Logger.getLogger(LoginServlet.class.getName());

    public LoginServlet() {
        verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new GsonFactory())
                .setAudience(Collections.singletonList(GOOGLE_CLIENT_ID))
                .build();
    }
        protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("view/signIn.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");
        String googleIdToken = null;

        HttpSession session = request.getSession();
        Map<String, Object> jsonResponse = new HashMap<>();

        // Handle JSON payload for Google Sign-In
        if (request.getContentType() != null && request.getContentType().contains("application/json")) {
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            String json = sb.toString();
            logger.info("Received JSON payload: " + json);
            Map<String, String> jsonMap = gson.fromJson(json, Map.class);
            googleIdToken = jsonMap.get("googleIdToken");
        }

        try {
            User user = null;
            if (googleIdToken != null) {
                logger.info("Processing Google Sign-In with token: " + googleIdToken);
                String googleId = verifyGoogleToken(googleIdToken);
                if (googleId != null) {
                    user = userDAO.findByGoogleId(googleId);
                    if (user == null) {
                        String email = extractEmailFromToken(googleIdToken);
                        String defaultUsername = email != null ? email.split("@")[0] : "google_user_" + googleId;
                        session.setAttribute("tempGoogleId", googleId);
                        session.setAttribute("tempEmail", email);
                        session.setAttribute("tempUsername", defaultUsername);
                        logger.info("New Google user detected. Redirecting to selectRole.jsp");
                        jsonResponse.put("success", true);
                        jsonResponse.put("redirect", request.getContextPath() + "/view/selectRole.jsp");
                    } else {
                        Integer userId = user.getId();
                        if (userId == null) {
                            logger.severe("User ID is null for Google user: " + (user.getUsername() != null ? user.getUsername() : "unknown"));
                            jsonResponse.put("success", false);
                            jsonResponse.put("message", "User ID not found.");
                        } else {
                            session.setAttribute("username", user.getUsername());
                            session.setAttribute("teacherId", userId); 
                            session.setAttribute("role", user.getRole());
                            session.setAttribute("user", user);
                            activityDAO.logLogin(user.getUsername());
                            session.setAttribute("loginTime", System.currentTimeMillis());
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            String today = sdf.format(new java.util.Date());
                            int historicalMinutes = activityDAO.getTotalActivityForDate(user.getUsername(), today);
                            session.setAttribute("historicalMinutesToday", historicalMinutes);
                            logger.info("Existing Google user logged in: " + user.getUsername() + ", teacherId: " + userId);
                            jsonResponse.put("success", true);
                            jsonResponse.put("redirect", request.getContextPath() + "/home");
                        }
                    }
                } else {
                    logger.warning("Invalid Google token received");
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Invalid Google token");
                }
            } else {
                logger.info("Processing standard login with identifier: " + usernameOrEmail + ", password length: " + (password != null ? password.length() : 0));
                user = userDAO.authenticate(usernameOrEmail, password, null);
                if (user != null) {
                    Integer userId = user.getId();
                    if (userId == null) {
                        logger.severe("User ID is null for standard user: " + (user.getUsername() != null ? user.getUsername() : "unknown"));
                        request.setAttribute("error", "User ID not found.");
                        request.getRequestDispatcher("/view/signIn.jsp").forward(request, response);
                        return;
                    }
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("teacherId", userId); // Đặt teacherId
                    session.setAttribute("role", user.getRole());
                    session.setAttribute("user", user);
                    activityDAO.logLogin(user.getUsername());
                    session.setAttribute("loginTime", System.currentTimeMillis());
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    String today = sdf.format(new java.util.Date());
                    int historicalMinutes = activityDAO.getTotalActivityForDate(user.getUsername(), today);
                    session.setAttribute("historicalMinutesToday", historicalMinutes);
                    logger.info("Standard login successful for user: " + user.getUsername() + ", teacherId: " + userId);
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                } else {
                    logger.warning("Standard login failed for username/email: " + usernameOrEmail);
                    request.setAttribute("error", "Invalid username or password");
                    request.getRequestDispatcher("/view/signIn.jsp").forward(request, response);
                    return;
                }
            }

            if (!jsonResponse.isEmpty()) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(gson.toJson(jsonResponse));
            }
        } catch (SQLException e) {
            logger.severe("Database error: " + e.getMessage());
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/view/signIn.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Unexpected error: " + e.getMessage());
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/view/signIn.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            String username = (String) session.getAttribute("username");
            try {
                activityDAO.logLogout(username); // Cập nhật thời gian đăng xuất
            } catch (Exception e) {
                logger.severe("Error logging out: " + e.getMessage());
            }
            session.invalidate();
        }
       request.getRequestDispatcher("/view/signIn.jsp").forward(request, response);
    }

    private String verifyGoogleToken(String idTokenString) throws Exception {
        GoogleIdToken idToken = verifier.verify(idTokenString);
        return (idToken != null) ? idToken.getPayload().getSubject() : null;
    }

    private String extractEmailFromToken(String idTokenString) throws Exception {
        GoogleIdToken idToken = verifier.verify(idTokenString);
        return (idToken != null) ? idToken.getPayload().getEmail() : null;
    }
}