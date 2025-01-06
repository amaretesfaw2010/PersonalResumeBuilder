<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.sql.*" %>
<%
    // Database connection setup (replace with your actual connection details)
    // Database connection setup
    String jdbcUrl = "jdbc:mysql://localhost:3307/teacherdb";  // Replace 'yourdb' with your actual database name
    String jdbcUsername = "root";  // Replace 'root' with your MySQL username
    String jdbcPassword = "";  // Replace with your MySQL password

    Connection connection = null;
    Statement stmt = null;
    ResultSet rs = null;

    // Retrieve the teachers list from the application scope
    List<String> teachers = (List<String>) application.getAttribute("teachers");

    if (teachers == null) {
        // If the list doesn't exist, initialize it
        teachers = new ArrayList<>();
        teachers.add("Dr. Emily Smith");
        teachers.add("Dr. John Doe");

        // Store the initialized list in the application scope
        application.setAttribute("teachers", teachers);
    }

    // Handle add and delete actions
    String action = request.getParameter("action");
    if ("add".equals(action)) {
        String newTeacher = request.getParameter("teacherName");
        if (newTeacher != null && !newTeacher.trim().isEmpty()) {
            teachers.add(newTeacher);
            application.setAttribute("teachers", teachers); // Update application scope

            // Insert new teacher into the database
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3307/teacherdb", "root", "");
                stmt = connection.createStatement();
                String query = "INSERT INTO teachers (name) VALUES ('" + newTeacher + "')";
                stmt.executeUpdate(query);
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

    if ("view".equals(action)) {
        // Fetch teachers from the database
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
            stmt = connection.createStatement();
            String query = "SELECT name FROM teachers";
            rs = stmt.executeQuery(query);

            while (rs.next()) {
                String teacherName = rs.getString("name");
                teachers.add(teacherName);
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
    else if ("delete".equals(action)) {
        String teacherToDelete = request.getParameter("teacherName");
        if (teacherToDelete != null) {
            teachers.remove(teacherToDelete);
            application.setAttribute("teachers", teachers); // Update application scope

            // Delete teacher from the database
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3307/teacherdb", "root", "");
                stmt = connection.createStatement();
                String query = "DELETE FROM teachers WHERE name = '" + teacherToDelete + "'";
                stmt.executeUpdate(query);
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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Teachers</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background-color: #f4f6f9;
        }

        header {
            background: linear-gradient(90deg, #6a11cb, #2575fc);
            color: #fff;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
        }

        .logo-section {
            display: flex;
            align-items: center;
        }

        .logo-section img {
            height: 50px;
            margin-right: 15px;
        }

        .logo-section span {
            font-size: 1.8rem;
            font-weight: bold;
        }

        .nav-links a {
            color: #f0f0f0;
            text-decoration: none;
            margin: 0 10px;
            font-size: 1rem;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .nav-links a:hover {
            color: #ffffff;
            text-shadow: 0px 0px 6px rgba(255, 255, 255, 0.8);
        }

        .layout {
            display: flex;
            flex-wrap: nowrap;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background: #2b2f33;
            color: #fff;
            padding: 20px;
            box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
        }

        .sidebar h2 {
            font-size: 1.2rem;
            margin-bottom: 15px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            margin-bottom: 15px;
        }

        .sidebar ul li a {
            color: #b8bcc4;
            text-decoration: none;
            font-size: 1rem;
            display: flex;
            align-items: center;
        }

        .sidebar ul li a i {
            margin-right: 10px;
        }

        .sidebar ul li a:hover {
            color: #fff;
        }

        .main-content {
            flex: 1;
            padding: 20px;
        }

        h2 {
            color: #3f48cc;
            font-size: 1.5rem;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }

        input[type="text"] {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
        }

        button {
            padding: 10px 20px;
            background-color: #2575fc;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #1a4fc0;
        }

        ul {
            list-style: none;
            padding: 0;
            display: grid;
            gap: 10px;
        }

        ul li {
            background: white;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }

        ul li:hover {
            transform: translateY(-3px);
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
        }

        ul li form button {
            background: red;
            border: none;
            padding: 8px 12px;
            color: white;
            font-size: 0.9rem;
            border-radius: 3px;
        }

        ul li form button:hover {
            background: darkred;
        }

        .hidden {
            display: none;
        }
    </style>
</head>
<body>
<header>
    <div class="header-container">
        <div class="logo-section">
            <img src="https://via.placeholder.com/50x50" alt="Logo">
            <span>Teacher Management</span>
        </div>
        <nav class="nav-links">
            <a href="#" onclick="showAddTeacherForm()">Add Teacher</a>
            <a href="#" onclick="showDeleteTeacherForm()">Delete Teacher</a>
            <a href="#">View Reports</a>
        </nav>
    </div>
</header>

<div class="layout">
    <!-- Sidebar -->
    <aside class="sidebar">
        <h2>Menu</h2>
        <ul>
            <li><a href="#" onclick="showAddTeacherForm()"><i class="fas fa-user-plus"></i>Add Teacher</a></li>
            <li><a href="#" onclick="showDeleteTeacherForm()"><i class="fas fa-user-minus"></i>Delete Teacher</a></li>
            <li><a href="#"><i class="fas fa-book"></i>View Reports</a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <div class="main-content">
        <h2>Manage Teachers</h2>
        <h3>Teachers List</h3>
        <ul>
            <%
                if (teachers != null && !teachers.isEmpty()) {
                    for (String teacher : teachers) {
            %>
            <li>
                <span><%= teacher %></span>
            </li>
            <% } } else { %>
            <li>No teachers available</li>
            <% } %>
        </ul>

        <!-- Add Teacher Form -->
        <div id="addTeacherForm" class="hidden">
            <h3>Add Teacher</h3>
            <form action="teachers.jsp" method="post">
                <div class="form-group">
                    <input type="text" name="teacherName" placeholder="Enter teacher name" required>
                    <button type="submit" name="action" value="add">Add</button>
                </div>
            </form>
        </div>

        <!-- Delete Teacher Form -->
        <div id="deleteTeacherForm" class="hidden">
            <h3>Delete Teacher</h3>
            <ul>
                <% for (String teacher : teachers) { %>
                <li>
                    <span><%= teacher %></span>
                    <form action="teachers.jsp" method="post" style="margin: 0;">
                        <input type="hidden" name="teacherName" value="<%= teacher %>">
                        <button type="submit" name="action" value="delete">Delete</button>
                    </form>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</div>

<script>
    function showAddTeacherForm() {
        document.getElementById('addTeacherForm').classList.remove('hidden');
        document.getElementById('deleteTeacherForm').classList.add('hidden');
    }

    function showDeleteTeacherForm() {
        document.getElementById('addTeacherForm').classList.add('hidden');
        document.getElementById('deleteTeacherForm').classList.remove('hidden');
    }
</script>
</body>
</html>