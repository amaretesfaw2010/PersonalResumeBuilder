<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="dashboard.jsp" %>
<%
  if (session == null || session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  String jdbcUrl = "jdbc:mysql://localhost:3307/teacherdb";
  String jdbcUsername = "root";
  String jdbcPassword = "";
  Connection connection = null;
  PreparedStatement stmt = null;
  String message = "";

  // Variables to hold the teaching philosophy data
  String approach = "", criticalThinking = "", application1 = "", inclusion = "";
  String growth = "", assessment = "", safeEnvironment = "";

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
    String selectSql = "SELECT approach, criticalThinking, application, inclusion, growth, assessment, safeEnvironment "
            + "FROM TeachingFacility WHERE personal_info_id = ?";
    stmt = connection.prepareStatement(selectSql);
    stmt.setInt(1, personalInfoId);
    rs = stmt.executeQuery();

    if (rs.next()) {
      approach = rs.getString("approach");
      criticalThinking = rs.getString("criticalThinking");
      application1 = rs.getString("application");
      inclusion = rs.getString("inclusion");
      growth = rs.getString("growth");
      assessment = rs.getString("assessment");
      safeEnvironment = rs.getString("safeEnvironment");
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
  <title>View Teaching Philosophy</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; }
    .container {
      max-width: 800px;
      margin: 50px auto;
      padding: 20px;
      background-color: #f9f9f9;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
  </style>
</head>
<body>
<% if (message != null && !message.isEmpty()) { %>
<div class="alert alert-danger mt-3">
  <%= message %>
</div>
<% } %>

<div class="container">
  <h2 class="text-center mb-4">Your Teaching ideology</h2>
  <p><strong>Teaching Approach:</strong> <%= approach %></p>
  <p><strong>Critical Thinking:</strong> <%= criticalThinking %></p>
  <p><strong>Application of Real-World Knowledge:</strong> <%= application1 %></p>
  <p><strong>Inclusion:</strong> <%= inclusion %></p>
  <p><strong>Professional Growth:</strong> <%= growth %></p>
  <p><strong>Assessment Methods:</strong> <%= assessment %></p>
  <p><strong>Safe Learning Environment:</strong> <%= safeEnvironment %></p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
