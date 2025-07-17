<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="DAO.ActivityDAO" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css"/>
    <title>Activity Calendar</title>
    
</head>
<body>
    <div class="activity-calendar">
        <div class="header">
            <span><%= session.getAttribute("username") != null ? "Activity for " + session.getAttribute("username") : "21 contributions" %> in the last 30 days</span>
        </div>
        <div class="calendar-container">    
            <div>
                <% 
                    Calendar now = Calendar.getInstance();
                    now.setTime(new java.util.Date()); // 01:34 AM +07, 13/07/2025
                    SimpleDateFormat monthFormat = new SimpleDateFormat("MMM");
                    SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
                    String currentMonth = monthFormat.format(now.getTime());
                    String currentYear = yearFormat.format(now.getTime());
                %>
                <div class="month-label"><%= currentMonth %></div>
                <div class="calendar-grid" id="calendarGrid">
                    <% 
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String today = sdf.format(now.getTime());

                        // Lấy thời gian đăng nhập từ session
                        Long loginTime = (Long) session.getAttribute("loginTime");
                        Integer historicalMinutesToday = (Integer) session.getAttribute("historicalMinutesToday");
                        if (historicalMinutesToday == null) historicalMinutesToday = 0;

                        if (loginTime == null && session.getAttribute("username") != null) {
                            loginTime = System.currentTimeMillis();
                            session.setAttribute("loginTime", loginTime);
                            new ActivityDAO().logLogin((String) session.getAttribute("username"));
                        }
                        long currentTime = System.currentTimeMillis();
                        long sessionDuration = (loginTime != null) ? (currentTime - loginTime) / (1000 * 60) : 0;

                        // Lấy dữ liệu từ DB
                        ActivityDAO activityDAO = new ActivityDAO();
                        String username = (String) session.getAttribute("username");
                        Map<String, Integer> onlineTimes = new HashMap<>();
                        if (username != null) {
                            onlineTimes = activityDAO.getUserActivity(username);
                            // Cập nhật thời gian online cho ngày hiện tại nếu đang online
                            if (loginTime != null) {
                                onlineTimes.put(today, historicalMinutesToday + (int) sessionDuration);
                            }
                        }

                        Calendar cal = (Calendar) now.clone();
                        cal.add(Calendar.DAY_OF_MONTH, -29); // Bắt đầu từ 30 ngày trước
                        while (!cal.after(now)) {
                            String date = sdf.format(cal.getTime());
                            int dayOfMonth = cal.get(Calendar.DAY_OF_MONTH);
                            int minutes = onlineTimes.getOrDefault(date, 0);
                            String colorClass = "gray";
                            if (minutes > 180) colorClass = "dark-blue";
                            else if (minutes > 60) colorClass = "medium-blue";
                            else if (minutes > 0) colorClass = "light-blue";
                    %>
                        <div class="calendar-cell <%=colorClass%>" data-date="<%=date%>" data-minutes="<%=minutes%>">
                            <span class="day-number"><%= dayOfMonth %></span>
                            <span class="tooltip"><%= minutes > 0 ? minutes + " minutes" : "No activity" %></span>
                        </div>
                    <% 
                            cal.add(Calendar.DAY_OF_YEAR, 1);
                        }
                    %>
                </div>
                <div style="margin-top: 15px; color: #bdc3c7;"><%= currentMonth %> <%= currentYear %></div>
            </div>
        </div>
        <div class="legend">
            Less
            <span class="light-blue"></span> 
            <span class="medium-blue"></span>
            <span class="dark-blue"></span> 
            More
        </div>
        <div class="info-text">Learn how we count contributions</div>
        <div class="info-text">Contribution activity</div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const cells = document.querySelectorAll('.calendar-cell');
            cells.forEach(cell => {
                cell.addEventListener('mouseover', () => {
                    const tooltip = cell.querySelector('.tooltip');
                    tooltip.style.visibility = 'visible';
                });
                cell.addEventListener('mouseout', () => {
                    const tooltip = cell.querySelector('.tooltip');
                    tooltip.style.visibility = 'hidden';
                });
            });

            // Cập nhật thời gian thực cho ngày hiện tại
            const now = new Date();
            const today = now.toISOString().split('T')[0];
            const todayCell = document.querySelector(`[data-date="${today}"]`);
            const historicalMinutes = <%= historicalMinutesToday %>;
            if (todayCell) {
                setInterval(() => {
                    const loginTime = <%= loginTime != null ? loginTime : 0 %>;
                    if (loginTime > 0) {
                        const currentTime = new Date().getTime();
                        const realTimeDuration = Math.floor((currentTime - loginTime) / 1000 / 60);
                        const totalMinutes = historicalMinutes + realTimeDuration;
                        todayCell.dataset.minutes = totalMinutes;
                        const colorClass = totalMinutes > 180 ? 'dark-blue' :
                                          totalMinutes > 60 ? 'medium-blue' :
                                          totalMinutes > 0 ? 'light-blue' : 'gray';
                        todayCell.className = `calendar-cell ${colorClass}`;
                        todayCell.querySelector('.tooltip').textContent = totalMinutes > 0 ? totalMinutes + " minutes" : "No activity";
                    }
                }, 60000); // Cập nhật mỗi phút
            }
        });
    </script>
</body>
</html>