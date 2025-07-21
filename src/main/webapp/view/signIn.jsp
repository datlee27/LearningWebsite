<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Learning Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/signIn.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <meta name="google-signin-client_id" content="463263011713-mrrbjqdmf75o6r3lofr88hougr4imc9a.apps.googleusercontent.com">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card course-card p-4">
                    <h2 class="text-center mb-4">Sign In</h2>
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" role="alert">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    <form action="${pageContext.request.contextPath}/loginServlet" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username or Email</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 mb-3">Sign In</button>
                    </form>
                    <div class="text-center mb-3">
                        <div id="g_id_onload"
                             data-client_id="463263011713-mrrbjqdmf75o6r3lofr88hougr4imc9a.apps.googleusercontent.com"
                             data-callback="handleCredentialResponse"
                             data-auto_prompt="false">
                        </div>
                        <div class="g_id_signin" data-type="standard" data-size="large" data-theme="outline" data-text="sign_in_with" data-shape="rectangular"></div>
                    </div>
                    <p class="text-center">Don't have an account? <a href="${pageContext.request.contextPath}/register">Sign Up</a></p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const htmlElement = document.documentElement;
            const currentTheme = localStorage.getItem('theme') || 'light';
            htmlElement.setAttribute('data-theme', currentTheme);
        });

        function handleCredentialResponse(response) {
            const idToken = response.credential;
            fetch('${pageContext.request.contextPath}/loginServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ googleIdToken: idToken })
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                console.log('Response from server:', data); // Debug log
                if (data.success && data.redirect) {
                    window.location.href = data.redirect;
                } else {
                    alert('Google Sign-In failed: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error during Google Sign-In:', error);
                alert('An error occurred during Google Sign-In: ' + error.message);
            });
        }
    </script>
</body>
</html>