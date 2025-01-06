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

  try {
    // Database connection
    Class.forName("com.mysql.cj.jdbc.Driver");
    connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
    System.out.println("Database connected successfully.");

    // Get form parameters
    String teachingBeliefs = request.getParameter("teachingBeliefs");
    String studentLearning = request.getParameter("studentLearning");
    String classroomEnvironment = request.getParameter("classroomEnvironment");
    String teachingGoals = request.getParameter("teachingGoals");

    if (teachingBeliefs != null && !teachingBeliefs.trim().isEmpty() &&
            studentLearning != null && !studentLearning.trim().isEmpty() &&
            classroomEnvironment != null && !classroomEnvironment.trim().isEmpty() &&
            teachingGoals != null && !teachingGoals.trim().isEmpty()) {

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
      rs.close();
      stmt.close();

      // Insert teaching philosophy data
      String insertSql = "INSERT INTO TeachingPhilosophy (personal_info_id, teaching_beliefs, student_learning, classroom_environment, teaching_goals) VALUES (?, ?, ?, ?, ?)";
      stmt = connection.prepareStatement(insertSql);
      stmt.setInt(1, personalInfoId);
      stmt.setString(2, teachingBeliefs.trim());
      stmt.setString(3, studentLearning.trim());
      stmt.setString(4, classroomEnvironment.trim());
      stmt.setString(5, teachingGoals.trim());

      int rowsAffected = stmt.executeUpdate();
      if (rowsAffected > 0) {
        message = "Teaching philosophy submitted successfully!";

      } else {
        message = "Failed to submit teaching philosophy.";
      }
    } else {
      message = "All fields must be completed!";
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
    .form-label {
      font-weight: bold;
      margin-top: 15px;
    }

    .btn-submit {
      width: 100%;
      margin-top: 20px;
    }

    textarea {
      resize: none;
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
  <form   method="post">
    <div class="mb-3">
      <label for="teachingBeliefs" class="form-label">Beliefs about Teaching:</label>
      <textarea class="form-control" id="teachingBeliefs" name="teachingBeliefs" rows="4" placeholder="What do you believe is the purpose of teaching?"></textarea>
    </div>
    <div class="mb-3">

      <label for="studentLearning" class="form-label">Approach to Student Learning:</label>
      <textarea class="form-control" id="studentLearning" name="studentLearning" rows="4" placeholder="How do you facilitate student learning?"></textarea>
    </div>

    <div class="mb-3">
      <label for="classroomEnvironment" class="form-label">Creating a Positive Classroom Environment:</label>
      <textarea class="form-control" id="classroomEnvironment" name="classroomEnvironment" rows="4" placeholder="How do you create an engaging and inclusive learning environment?"></textarea>
    </div>

    <div class="mb-3">
      <label for="teachingGoals" class="form-label">Goals for Students:</label>
      <textarea class="form-control" id="teachingGoals" name="teachingGoals" rows="4" placeholder="What are your aspirations for your students?"></textarea>
    </div>
    <button type="submit" class="btn btn-primary btn-submit">Submit Teaching Philosophy</button>
  </form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
