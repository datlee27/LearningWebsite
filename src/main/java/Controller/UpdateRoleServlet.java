package Controller;

import DAO.DAO;
import DAO.UserDAO;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class UpdateRoleServlet extends HttpServlet {
   
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String googleId = (String) session.getAttribute("tempGoogleId");
        String email = (String) session.getAttribute("tempEmail");
        String username = (String) session.getAttribute("tempUsername");
        String role = request.getParameter("role");

        System.out.println("Received: googleId=" + googleId + ", email=" + email + ", username=" + username + ", role=" + role); // Debug

        if (googleId != null && email != null && username != null && role != null) {
            User user = new User();
            user.setGoogleId(googleId);
            user.setEmail(email);
            user.setUsername(username);
            user.setRole(role);
            user.setPassword(""); // Không cần password cho Google login
            try {
                userDAO.save(user);
                session.setAttribute("username", username);
                session.removeAttribute("tempGoogleId");
                session.removeAttribute("tempEmail");
                session.removeAttribute("tempUsername");
                response.sendRedirect(request.getContextPath() + "/home");
            } catch (Exception e) {
                System.out.println("Save error: " + e.getMessage()); // Debug
                request.setAttribute("error", "Failed to save role: " + e.getMessage());
                request.getRequestDispatcher(request.getContextPath() + "/view/selectRole.jsp").forward(request, response);
            }
        } else {
            System.out.println("Missing required session attributes or role: googleId=" + googleId + ", email=" + email + ", username=" + username + ", role=" + role); // Debug chi tiết
            request.setAttribute("error", "Missing required data to save role");
            request.getRequestDispatcher(request.getContextPath() + "/view/selectRole.jsp").forward(request, response);
        }
    }
} 