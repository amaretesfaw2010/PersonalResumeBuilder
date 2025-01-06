<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="dashboard.jsp" %>
 <%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String jdbcUrl = "jdbc:mysql://localhost:3307/teacherdb";
    String jdbcUsername = "root";
    String jdbcPassword = "";
    Connection connection = null;
    PreparedStatement stmt = null;
    String message = "";
     String teachingBeliefs="",studentLearning="",classroomEnvironment="",teachingGoals="";
    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
        System.out.println("Database connected successfully.");

        // Get the logged-in user's username
        String username = (String) session.getAttribute("username");

        // Get user ID
        String userSql = "SELECT personal_info_id FROM users WHERE username = ?";
        stmt = connection.prepareStatement(userSql);
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();

        int personalInfoId = 0;
        if (rs.next()) {
            personalInfoId = rs.getInt("personal_info_id");
        }

        // Retrieve teaching philosophy data
        String selectSql = "SELECT teaching_beliefs, student_learning, classroom_environment, teaching_goals FROM TeachingPhilosophy WHERE personal_info_id = ?";
        stmt = connection.prepareStatement(selectSql);
        stmt.setInt(1, personalInfoId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            teachingBeliefs = rs.getString("teaching_beliefs");
            studentLearning = rs.getString("student_learning");
            classroomEnvironment = rs.getString("classroom_environment");
            teachingGoals = rs.getString("teaching_goals");
        } else {
            message = "No teaching philosophy found for this user.";
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "An error occurred: " + e.getMessage();
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teaching Philosophy</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .alert-info {
            font-weight: bold;
            margin-left:300px;
        }
        .col-lg-6 {
            padding: 20px;
        }
    </style>
</head>
<body>

<% if (message != null && !message.isEmpty()) { %>
<div class="alert alert-info mt-3">
    <%= message %>
</div>
<% } %>

<div class="container">
    <h2 class="text-center mb-4">Teaching Philosophy</h2>

    <!-- Display submitted philosophy in grid layout -->
    <div class="row">
        <div class="col-lg-6">
            <h5><strong>Beliefs about Teaching:</strong></h5>
            <p><%= teachingBeliefs != null ? teachingBeliefs : "No beliefs about teaching provided." %></p>

            <h5><strong>Approach to Student Learning:</strong></h5>
            <p><%= studentLearning != null ? studentLearning : "No approach to student learning provided." %></p>

            <h5><strong>Creating a Positive Classroom Environment:</strong></h5>
            <p><%= classroomEnvironment != null ? classroomEnvironment : "No information on classroom environment provided." %></p>

            <h5><strong>Goals for Students:</strong></h5>
            <p><%= teachingGoals != null ? teachingGoals : "No goals for students provided." %></p>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
