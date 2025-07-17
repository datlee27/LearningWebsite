<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.ActivityDAO" %>
<%
    String username = (String) session.getAttribute("username");
    if (username != null) {
        ActivityDAO activityDAO = new ActivityDAO();
        try {
            activityDAO.logLogout(username); // Ghi nhận thời gian đăng xuất
        } catch (Exception e) {
            out.println("<p>Error logging out: " + e.getMessage() + "</p>");
        }
    }
    session.invalidate(); // Hủy session
    response.sendRedirect(request.getContextPath() + "/home"); // Chuyển hướng về trang chủ
%>