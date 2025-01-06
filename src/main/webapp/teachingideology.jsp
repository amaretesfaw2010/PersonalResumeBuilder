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

    // Get form parameters
    String approach = request.getParameter("approach");
    String criticalThinking = request.getParameter("criticalThinking");
    String application1 = request.getParameter("application");
    String inclusion = request.getParameter("inclusion");
    String growth = request.getParameter("growth");
    String assessment = request.getParameter("assessment");
    String safeEnvironment = request.getParameter("safeEnvironment");

    if (approach != null && !approach.trim().isEmpty() &&
            criticalThinking != null && !criticalThinking.trim().isEmpty() &&
            application != null && !application1.trim().isEmpty() &&
            inclusion != null && !inclusion.trim().isEmpty() &&
            growth != null && !growth.trim().isEmpty() &&
            assessment != null && !assessment.trim().isEmpty() &&
            safeEnvironment != null && !safeEnvironment.trim().isEmpty()) {

      String username = (String) session.getAttribute("username");

      // Get user ID from the 'users' table
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

      // Insert teaching philosophy data into TeachingFacility table
      String insertSql = "INSERT INTO TeachingFacility (personal_info_id, approach, criticalThinking, application, inclusion, growth, assessment, safeEnvironment) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
      stmt = connection.prepareStatement(insertSql);
      stmt.setInt(1, personalInfoId);
      stmt.setString(2, approach.trim());
      stmt.setString(3, criticalThinking.trim());
      stmt.setString(4, application1.trim());
      stmt.setString(5, inclusion.trim());
      stmt.setString(6, growth.trim());
      stmt.setString(7, assessment.trim());
      stmt.setString(8, safeEnvironment.trim());

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
  <h2 class="text-center mb-4">Teaching ideology</h2>
  <form method="post">
    <!-- Teaching Philosophy Form Fields -->
    <div class="mb-3">
      <label for="approach" class="form-label">Teaching Approach:</label>
      <textarea class="form-control" id="approach" name="approach" rows="4" placeholder="Describe your teaching approach"></textarea>
    </div>
    <div class="mb-3">
      <label for="criticalThinking" class="form-label">Critical Thinking:</label>
      <textarea class="form-control" id="criticalThinking" name="criticalThinking" rows="4" placeholder="How do you encourage critical thinking?"></textarea>
    </div>
    <div class="mb-3">
      <label for="application" class="form-label">Real-World Application:</label>
      <textarea class="form-control" id="application" name="application" rows="4" placeholder="How do you incorporate real-world applications in your teaching?"></textarea>
    </div>
    <div class="mb-3">
      <label for="inclusion" class="form-label">Inclusivity and Diversity:</label>
      <textarea class="form-control" id="inclusion" name="inclusion" rows="4" placeholder="How do you promote inclusivity and diversity?"></textarea>
    </div>
    <div class="mb-3">
      <label for="growth" class="form-label">Professional Growth:</label>
      <textarea class="form-control" id="growth" name="growth" rows="4" placeholder="How do you encourage professional growth?"></textarea>
    </div>
    <div class="mb-3">
      <label for="assessment" class="form-label">Assessment Methods:</label>
      <textarea class="form-control" id="assessment" name="assessment" rows="4" placeholder="Describe your assessment methods"></textarea>
    </div>
    <div class="mb-3">
      <label for="safeEnvironment" class="form-label">Safe Learning Environment:</label>
      <textarea class="form-control" id="safeEnvironment" name="safeEnvironment" rows="4" placeholder="How do you create a safe learning environment?"></textarea>
    </div>
    <button type="submit" class="btn btn-primary btn-submit">Submit Teaching Philosophy</button>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
