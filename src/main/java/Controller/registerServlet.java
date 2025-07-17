package Controller;

import DAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Model.User;

import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;

public class registerServlet extends HttpServlet {
private final UserDAO userDAO = new UserDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến trang đăng ký khi nhận yêu cầu GET
        request.getRequestDispatcher("/view/signUp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        // Xác thực dữ liệu đầu vào
        if (username == null || email == null || password == null || confirmPassword == null || role == null ||
            username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || confirmPassword.trim().isEmpty() || role.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/view/signUp.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xác nhận mật khẩu
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/view/signUp.jsp").forward(request, response);
            return;
        }

        // Kiểm tra định dạng email (cơ bản)
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("error", "Invalid email format.");
            request.getRequestDispatcher("/view/signUp.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng User
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt())); // Mã hóa mật khẩu
        user.setRole(role);
        // googleId để null vì đây là đăng ký thông thường, không qua Google
        user.setGoogleId(null);

        // Lưu người dùng vào cơ sở dữ liệu
       
        try {
            userDAO.save(user);
            // Đăng ký thành công, chuyển hướng đến trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/view/signIn.jsp");
        } catch (Exception e) {
            // Xử lý lỗi (ví dụ: username hoặc email đã tồn tại)
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/view/signUp.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles user registration for the Learning Platform";
    }
}