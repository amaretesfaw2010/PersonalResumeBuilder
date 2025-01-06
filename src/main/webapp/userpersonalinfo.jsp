
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="dashboard.jsp" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Update Personal Information</title>
    <!-- Add Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            max-width: 900px;
            margin-top: 50px;
        }
        .cv-header {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
        }
        .cv-header h2 {
            margin: 0;
            font-size: 1.8rem;
            font-weight: bold;
            color: #343a40;
        }
        .cv-header p {
            margin: 5px 0;
            font-size: 1.1rem;
            color: #6c757d;
        }
        .cv-section {
            margin-top: 30px;
        }
        .cv-section h4 {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .cv-section p {
            margin-bottom: 10px;
            font-size: 1.1rem;
            line-height: 1.6;
        }
        .label-bold {
            font-weight: bold;
        }
    </style>
    <style>
        .container {
            max-width: 800px;
        }
        .alert-info {
            font-weight: bold;
        }
        .form-group label {
            font-weight: 600;
        }
    </style>
</head>
<body>
<%
    // Fetch session object
    session = request.getSession();
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String username = (String) session.getAttribute("username");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");

    // Connect to the database
    String jdbcUrl = "jdbc:mysql://localhost:3307/teacherdb";
    String jdbcUsername = "root";
    String jdbcPassword = "";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String message = "";

    try {
        conn = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);

        // Retrieve user_id based on the username
        String userSql = "SELECT personal_info_id FROM users WHERE username = ?";
        stmt = conn.prepareStatement(userSql);
        stmt.setString(1, username);
        rs = stmt.executeQuery();

        if (rs.next()) {
            int userId = rs.getInt("personal_info_id");

            // Retrieve personal information using user_id
            String sql = "SELECT * FROM personalinformation WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                name = name != null ? name : rs.getString("name");
                email = email != null ? email : rs.getString("email");
                phone = phone != null ? phone : rs.getString("phone");
                address = address != null ? address : rs.getString("address");
            }

            // Update personal information if necessary
            if (name != null && email != null && phone != null && address != null) {
                String updateSql = "UPDATE personalinformation SET name = ?, email = ?, phone = ?, address = ? WHERE id = ?";
                stmt = conn.prepareStatement(updateSql);
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, phone);
                stmt.setString(4, address);
                stmt.setInt(5, userId);

                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    message = "Personal Information updated successfully!";
                } else {
                    message = "Error updating personal information. Try again later.";
                }
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
        message = "Database error occurred. Please try again later.";
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<div class="container mt-4">
    <h2>Welcome, <%= username %>!</h2>

    <!-- Display success or error message -->
    <% if (message != null && !message.isEmpty()) { %>
    <div class="alert alert-info mt-3">
        <%= message %>
    </div>
    <% } %>

    <!-- Personal Information Card -->
    <div class="container">
        <!-- CV Header -->
        <div class="cv-header text-center">
            <h2><%= name != null ? name : "Your Name" %></h2>
            <p>Email: <%= email != null ? email : "example@example.com" %></p>
            <p>Phone: <%= phone != null ? phone : "Your Phone" %></p>
            <p>Address: <%= address != null ? address : "Your Address" %></p>
        </div>

        <!-- Personal Information Section -->
        <div class="cv-section">
            <h4>Personal Details</h4>
            <p><span class="label-bold">Full Name:</span> <%= name != null ? name : "N/A" %></p>
            <p><span class="label-bold">Email:</span> <%= email != null ? email : "N/A" %></p>
            <p><span class="label-bold">Phone:</span> <%= phone != null ? phone : "N/A" %></p>
            <p><span class="label-bold">Address:</span> <%= address != null ? address : "N/A" %></p>
        </div>

        <!-- About Section -->
        <div class="cv-section">
            <h4>About Me</h4>
            <p>
                Experienced professional with expertise in information technology, committed to delivering high-quality results
                and contributing to professional growth. Motivated by a passion for innovation and lifelong learning.
            </p>
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            <h5 class="card-title">Your Personal Information</h5>
            <p><strong>Username: </strong><%= username %></p>
            <form method="post">
                <!-- Full Name -->
                <div class="form-group mb-3">
                    <label for="name">Full Name</label>
                    <input type="text" class="form-control" id="name" name="name" value="<%= name != null ? name : "" %>" required>
                </div>

                <!-- Email -->
                <div class="form-group mb-3">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="<%= email != null ? email : "" %>" required>
                </div>

                <!-- Phone -->
                <div class="form-group mb-3">
                    <label for="phone">Phone</label>
                    <input type="tel" class="form-control" id="phone" name="phone" value="<%= phone != null ? phone : "" %>" required>
                </div>

                <!-- Address -->
                <div class="form-group mb-3">
                    <label for="address">Address</label>
                    <input type="text" class="form-control" id="address" name="address" value="<%= address != null ? address : "" %>" required>
                </div>

                <!-- Update Button -->
                <button type="submit" class="btn btn-primary mt-3">Update Information</button>
            </form>
        </div>
    </div>
</div>

<!-- Add Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
