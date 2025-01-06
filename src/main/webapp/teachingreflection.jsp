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
    String reflectionDate = request.getParameter("reflectionDate");
    String areaOfGrowth = request.getParameter("areaOfGrowth");
    String teachingExperience = request.getParameter("teachingExperience");
    String personalGrowth = request.getParameter("personalGrowth");
    String researchInsights = request.getParameter("researchInsights");
    String teachingMethodologies = request.getParameter("teachingMethodologies");
    String studentInteraction = request.getParameter("studentInteraction");
    String challengesAndLearnings = request.getParameter("challengesAndLearnings");
    String futureGoals = request.getParameter("futureGoals");

    if (reflectionDate != null && !reflectionDate.trim().isEmpty() &&
            areaOfGrowth != null && !areaOfGrowth.trim().isEmpty() &&
            teachingExperience != null && !teachingExperience.trim().isEmpty() &&
            personalGrowth != null && !personalGrowth.trim().isEmpty() &&
            researchInsights != null && !researchInsights.trim().isEmpty() &&
            teachingMethodologies != null && !teachingMethodologies.trim().isEmpty() &&
            studentInteraction != null && !studentInteraction.trim().isEmpty() &&
            challengesAndLearnings != null && !challengesAndLearnings.trim().isEmpty() &&
            futureGoals != null && !futureGoals.trim().isEmpty()) {

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

      // Insert teaching reflection data into TeachingReflections table
      String insertSql = "INSERT INTO TeachingReflections (personal_info_id, ReflectionDate, AreaOfGrowth, TeachingExperience, PersonalGrowth, ResearchInsights, TeachingMethodologies, StudentInteraction, ChallengesAndLearnings, FutureGoals) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
      stmt = connection.prepareStatement(insertSql);
      stmt.setInt(1, personalInfoId);
      stmt.setDate(2, Date.valueOf(reflectionDate.trim()));
      stmt.setString(3, areaOfGrowth.trim());
      stmt.setString(4, teachingExperience.trim());
      stmt.setString(5, personalGrowth.trim());
      stmt.setString(6, researchInsights.trim());
      stmt.setString(7, teachingMethodologies.trim());
      stmt.setString(8, studentInteraction.trim());
      stmt.setString(9, challengesAndLearnings.trim());
      stmt.setString(10, futureGoals.trim());

      int rowsAffected = stmt.executeUpdate();
      if (rowsAffected > 0) {
        message = "Reflection submitted successfully!";
      } else {
        message = "Failed to submit reflection.";
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
  <title>Teaching Reflection</title>
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
      margin-left: 300px;
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
  <h2 class="text-center mb-4">Teaching Reflection</h2>
  <form method="post">
    <!-- Reflection Form Fields -->
    <div class="mb-3">
      <label for="reflectionDate" class="form-label">Reflection Date:</label>
      <input type="date" class="form-control" id="reflectionDate" name="reflectionDate" required />
    </div>
    <div class="mb-3">
      <label for="areaOfGrowth" class="form-label">Area of Growth:</label>
      <textarea class="form-control" id="areaOfGrowth" name="areaOfGrowth" rows="4" placeholder="Identify areas of growth" required></textarea>
    </div>
    <div class="mb-3">
      <label for="teachingExperience" class="form-label">Teaching Experience:</label>
      <textarea class="form-control" id="teachingExperience" name="teachingExperience" rows="4" placeholder="Reflect on your teaching experience" required></textarea>
    </div>
    <div class="mb-3">
      <label for="personalGrowth" class="form-label">Personal Growth:</label>
      <textarea class="form-control" id="personalGrowth" name="personalGrowth" rows="4" placeholder="Reflect on your personal growth" required></textarea>
    </div>
    <div class="mb-3">
      <label for="researchInsights" class="form-label">Research Insights:</label>
      <textarea class="form-control" id="researchInsights" name="researchInsights" rows="4" placeholder="Share insights gained from research" required></textarea>
    </div>
    <div class="mb-3">
      <label for="teachingMethodologies" class="form-label">Teaching Methodologies:</label>
      <textarea class="form-control" id="teachingMethodologies" name="teachingMethodologies" rows="4" placeholder="Describe the teaching methodologies you use" required></textarea>
    </div>
    <div class="mb-3">
      <label for="studentInteraction" class="form-label">Student Interaction:</label>
      <textarea class="form-control" id="studentInteraction" name="studentInteraction" rows="4" placeholder="Describe how you interact with students" required></textarea>
    </div>
    <div class="mb-3">
      <label for="challengesAndLearnings" class="form-label">Challenges and Learnings:</label>
      <textarea class="form-control" id="challengesAndLearnings" name="challengesAndLearnings" rows="4" placeholder="Reflect on challenges and what you've learned" required></textarea>
    </div>
    <div class="mb-3">
      <label for="futureGoals" class="form-label">Future Goals:</label>
      <textarea class="form-control" id="futureGoals" name="futureGoals" rows="4" placeholder="Describe your goals for the future" required></textarea>
    </div>
    <button type="submit" class="btn btn-primary btn-submit">Submit Reflection</button>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
