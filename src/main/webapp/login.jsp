<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login & Signup</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f3f4f6;
      margin: 0;
      padding: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .container {
      background: #fff;
      padding: 20px 30px;
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      width: 100%;
      max-width: 500px;
    }

    h1 {
      text-align: center;
      color: #333;
      margin-bottom: 20px;
    }

    h2 {
      text-align: center;
      color: #444;
      margin-bottom: 15px;
    }

    label {
      display: block;
      margin-bottom: 8px;
      font-weight: bold;
      color: #555;
    }

    input {
      width: 100%;
      padding: 10px;
      margin-bottom: 15px;
      border: 1px solid #ccc;
      border-radius: 5px;
      font-size: 16px;
    }

    button {
      width: 100%;
      background-color: #007BFF;
      color: #fff;
      padding: 12px;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      cursor: pointer;
    }

    button:hover {
      background-color: #0056b3;
    }

    .footer {
      text-align: center;
      margin-top: 15px;
    }

    .footer a {
      color: #007BFF;
      text-decoration: none;
      font-weight: bold;
    }

    .footer a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

<div class="container">
  <h1>Login or Sign Up</h1>

  <%-- Display error or success messages --%>
  <c:if test="${not empty message}">
    <div style="color: red; text-align: center; margin-bottom: 15px;">
        ${message}
    </div>
  </c:if>

  <!-- Login Form -->
  <form id="loginForm" action="login.jsp" method="post" style="display: block;">
    <h2>Login</h2>
    <label for="loginUsername">Username</label>
    <input type="text" id="loginUsername" name="username" required>

    <label for="loginPassword">Password</label>
    <input type="password" id="loginPassword" name="password" required>

    <button type="submit" name="action" value="login">Login</button>

    <div class="footer">
      <p>Don't have an account? <a href="personalinformation.jsp">Sign up here</a></p>

    </div>
  </form>

  <!-- Signup Form -->
  <form id="signupForm" action="login.jsp" method="post" style="display: none;">
    <h2>Sign Up</h2>
    <label for="name">Full Name</label>
    <input type="text" id="name" name="name" required>

    <label for="email">Email</label>
    <input type="email" id="email" name="email" required>

    <label for="phone">Phone</label>
    <input type="text" id="phone" name="phone" required>

    <label for="address">Address</label>
    <input type="text" id="address" name="address" required>

    <label for="username">Username</label>
    <input type="text" id="username" name="username" required>

    <label for="password">Password</label>
    <input type="password" id="password" name="password" required>

    <label for="role">Role</label>
    <input type="text" id="role" name="role" placeholder="e.g., Admin, User" required>

    <button type="submit" name="action" value="signup">Sign Up</button>

    <div class="footer">
      <p>Already have an account? <a href="javascript:void(0);" onclick="showLoginForm()">Login here</a></p>
    </div>
  </form>
</div>

<script>
  // Function to toggle forms
  function showSignupForm() {
    document.getElementById('loginForm').style.display = 'none';
    document.getElementById('signupForm').style.display = 'block';
  }

  function showLoginForm() {
    document.getElementById('loginForm').style.display = 'block';
    document.getElementById('signupForm').style.display = 'none';
  }
</script>

</body>
</html>


<%
  String action = request.getParameter("action");
  String message = "";
  String jdbcUrl = "jdbc:mysql://localhost:3307/teacherdb";
  String jdbcUsername = "root";
  String jdbcPassword = "";
  Connection conn = null;
  PreparedStatement stmt = null;
  ResultSet rs = null;
  session = request.getSession();

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    if ("login".equals(action)) {
      // Login Logic
      String username = request.getParameter("username");
      String password = request.getParameter("password");

      conn = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
      String loginQuery = "SELECT password FROM users WHERE username = ?";
      stmt = conn.prepareStatement(loginQuery);
      stmt.setString(1, username);
      rs = stmt.executeQuery();

      if (rs.next()) {
        String storedPassword = rs.getString("password");
        if (password.equals(storedPassword)) {
          message = "Login successful!";
          session.setAttribute("username", username);
          response.sendRedirect("dashboard.jsp"); // Redirect to your main page or dashboard
          return;
        } else {
          message = "Invalid credentials!";
        }
      } else {
        message = "User not found!";
      }
    } else if ("signup".equals(action)) {
      // Signup Logic
      response.sendRedirect("personalinformation.jsp");



    }
  } catch (SQLException e) {
    message = "Database error: " + e.getMessage();
    e.printStackTrace(); // Log the stack trace for debugging
  } catch (Exception e) {
    message = "Unexpected error: " + e.getMessage();
    e.printStackTrace(); // Log the stack trace for debugging
  } finally {
    // Close resources safely
    try {
      if (rs != null) rs.close();
      if (stmt != null) stmt.close();
      if (conn != null) conn.close();
    } catch (SQLException e) {
      message = "Error closing database resources: " + e.getMessage();
      e.printStackTrace(); // Log the stack trace for debugging
    }
  }
%>



</body>
</html>
