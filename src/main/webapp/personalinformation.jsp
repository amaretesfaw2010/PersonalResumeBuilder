<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>

<%
  // Database connection details (adjust as needed)
  String jdbcUrl = "jdbc:mysql://localhost:3307/teacherdb";
  String jdbcUsername = "root";
  String jdbcPassword = "";

  Connection connection = null;
  Statement stmt = null;
  ResultSet rs = null;
  List<String[]> personalInfos = new ArrayList<>();
  String name = "", email = "", phone = "", address = "",username="", password="", role="";

  // Fetch all personal information records
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
    stmt = connection.createStatement();
    String query = "SELECT id, name, email, phone, address FROM PersonalInformation";
    rs = stmt.executeQuery(query);

    while (rs.next()) {
      String[] personalInfo = new String[5];
      personalInfo[0] = rs.getString("id");
      personalInfo[1] = rs.getString("name");
      personalInfo[2] = rs.getString("email");
      personalInfo[3] = rs.getString("phone");
      personalInfo[4] = rs.getString("address");
      personalInfos.add(personalInfo);
    }
  } catch (Exception e) {
    e.printStackTrace();
  } finally {
    try {
      if (rs != null) rs.close();
      if (stmt != null) stmt.close();
      if (connection != null) connection.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }

  // Process form actions
  String action = request.getParameter("action");
  String id = request.getParameter("id");

  // Add new entry to database
  if ("add".equals(action)) {
    name = request.getParameter("name");
    email = request.getParameter("email");
    phone = request.getParameter("phone");
    address = request.getParameter("address");
    username = request.getParameter("username");
    password = request.getParameter("password");
    role = request.getParameter("role");

    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);

      // Insert into PersonalInformation table
      String personalInfoQuery = "INSERT INTO PersonalInformation (name, email, phone, address) VALUES (?, ?, ?, ?)";
      PreparedStatement personalInfoStmt = connection.prepareStatement(personalInfoQuery, Statement.RETURN_GENERATED_KEYS);
      personalInfoStmt.setString(1, name);
      personalInfoStmt.setString(2, email);
      personalInfoStmt.setString(3, phone);
      personalInfoStmt.setString(4, address);
      personalInfoStmt.executeUpdate();

      // Retrieve the generated key (personal_info_id)
      ResultSet generatedKeys = personalInfoStmt.getGeneratedKeys();
      int personalInfoId = 0;
      if (generatedKeys.next()) {
        personalInfoId = generatedKeys.getInt(1); // The ID of the newly inserted row
      }

      // Insert into users table
      String userQuery = "INSERT INTO users (personal_info_id, username, email, password, role) VALUES (?, ?, ?, ?, ?)";
      PreparedStatement userStmt = connection.prepareStatement(userQuery);
      userStmt.setInt(1, personalInfoId);
      userStmt.setString(2, username);
      userStmt.setString(3, email);
      userStmt.setString(4, password); // Hash this password in production!
      userStmt.setString(5, role);
      userStmt.executeUpdate();

      // Redirect to refresh the list
      response.sendRedirect("personalinformation.jsp");
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        if (connection != null) connection.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  }


  // Update an existing record
  else if ("update".equals(action)) {
    if (id != null) {
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
        stmt = connection.createStatement();
        String query = "SELECT * FROM PersonalInformation WHERE id = " + id;
        rs = stmt.executeQuery(query);
        if (rs.next()) {
          name = rs.getString("name");
          email = rs.getString("email");
          phone = rs.getString("phone");
          address = rs.getString("address");
        }
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        try {
          if (rs != null) rs.close();
          if (stmt != null) stmt.close();
          if (connection != null) connection.close();
        } catch (SQLException e) {
          e.printStackTrace();
        }
      }
    }

    // When the form is submitted for updating, perform update action
    String newName = request.getParameter("name");
    String newEmail = request.getParameter("email");
    String newPhone = request.getParameter("phone");
    String newAddress = request.getParameter("address");

    if (newName != null) {  // Update after receiving new info
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
        stmt = connection.createStatement();
        String query = "UPDATE PersonalInformation SET name = '" + newName + "', email = '" + newEmail + "', " +
                "phone = '" + newPhone + "', address = '" + newAddress + "' WHERE id = " + id;
        stmt.executeUpdate(query);
        response.sendRedirect("personalinformation.jsp"); // Refresh the list after update
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        try {
          if (stmt != null) stmt.close();
          if (connection != null) connection.close();
        } catch (SQLException e) {
          e.printStackTrace();
        }
      }
    }
  }

  // Delete an entry from the database
  else if ("delete".equals(action)) {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
      stmt = connection.createStatement();
      String query = "DELETE FROM PersonalInformation WHERE id = " + id;
      stmt.executeUpdate(query);
      // Redirect after deleting to refresh the list
      response.sendRedirect("personalinformation.jsp");
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        if (stmt != null) stmt.close();
        if (connection != null) connection.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Personal Information Management</title>
  <!-- Include Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }

    .container {
      margin-top: 50px;
    }

    .form-title {
      margin-bottom: 20px;
    }

    table {
      margin-top: 30px;
    }

    .btn-actions {
      display: flex;
      gap: 10px;
    }

    .form-section, .table-section {
      height: 100%;
    }

    .card {
      height: 100%;
    }
  </style>
</head>
<body>
<div class="container">
  <h1 class="text-center mb-4">Personal Information Management</h1>
  <div class="row g-4">
    <!-- Form Section -->
    <div class="col-lg-6 form-section">
      <div class="card shadow-sm p-4 h-100">
        <h3 class="form-title text-primary"><%= ("update".equals(action)) ? "Update Information" : "Add New Information" %></h3>
        <form action="personalinformation.jsp" method="post">
          <input type="hidden" name="action" value="<%= (action != null && action.equals("update")) ? "update" : "add" %>">
          <input type="hidden" name="id" value="<%= id != null ? id : "" %>">

          <div class="row mb-3">
            <div class="col-md-6">
              <label for="name" class="form-label">Name:</label>
              <input type="text" class="form-control" name="name" id="name" value="<%= (action != null && action.equals("update")) ? name : "" %>" required>
            </div>
            <div class="col-md-6">
              <label for="email" class="form-label">Email:</label>
              <input type="email" class="form-control" name="email" id="email" value="<%= (action != null && action.equals("update")) ? email : "" %>" required>
            </div>
          </div>
          <div class="row mb-3">
            <div class="col-md-6">
              <label for="phone" class="form-label">Phone:</label>
              <input type="text" class="form-control" name="phone" id="phone" value="<%= (action != null && action.equals("update")) ? phone : "" %>">
            </div>
            <div class="col-md-6">
              <label for="role" class="form-label">Role:</label>
              <input type="text" class="form-control" name="role" id="role" required>
            </div>
          </div>
          <div class="mb-3">
            <label for="address" class="form-label">Address:</label>
            <textarea class="form-control" name="address" id="address" rows="3" required><%= (action != null && action.equals("update")) ? address : "" %></textarea>
          </div>
          <div class="row mb-3">
            <div class="col-md-6">
              <label for="username" class="form-label">Username:</label>
              <input type="text" class="form-control" name="username" id="username" required>
            </div>
            <div class="col-md-6">
              <label for="password" class="form-label">Password:</label>
              <input type="password" class="form-control" name="password" id="password" required>
            </div>
          </div>
          <button type="submit" class="btn btn-primary w-100"><%= ("update".equals(action)) ? "Update Information" : "Add Information" %></button>
        </form>
      </div>
    </div>

    <!-- Table Section -->
    <div class="col-lg-6 table-section">
      <div class="card shadow-sm p-4 h-100">
        <h3 class="text-primary">Current Personal Information</h3>
        <table class="table table-bordered table-striped mt-3">
          <thead class="table-primary">
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <% for (String[] info : personalInfos) { %>
          <tr>
            <td><%= info[0] %></td>
            <td><%= info[1] %></td>
            <td><%= info[2] %></td>
            <td class="btn-actions">
              <a href="personalinformation.jsp?action=update&id=<%= info[0] %>" class="btn btn-warning btn-sm">Update</a>
              <a href="personalinformation.jsp?action=delete&id=<%= info[0] %>" class="btn btn-danger btn-sm">Delete</a>
            </td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- Include Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


