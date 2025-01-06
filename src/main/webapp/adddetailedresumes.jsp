<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="dashboard.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%

    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    // Database Configuration
    String jdbcUrl = "jdbc:mysql://localhost:3307/teacherdb";
    String jdbcUsername = "root";
    String jdbcPassword = "";

    // Database Objects
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    session = request.getSession();
    String username = (String) session.getAttribute("username");
    int personal_info_id=0;
    // Data Storage for Dropdowns
    Map<String, List<String[]>> dropdownData = new HashMap<>();
    dropdownData.put("languages", new ArrayList<>());
    dropdownData.put("projects", new ArrayList<>());
    dropdownData.put("certifications", new ArrayList<>());
    dropdownData.put("workExperiences", new ArrayList<>());

    // Action Handling
    String action = request.getParameter("action");
    String message = "";

    try {
        // Debugging the action
        System.out.println("Action: " + action);

        // Load JDBC Driver and Establish Connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
        System.out.println("Database connected successfully.");
        String userSql = "SELECT personal_info_id FROM users WHERE username = ?";
        stmt = connection.prepareStatement(userSql);
        stmt.setString(1, username);
        rs = stmt.executeQuery();

        if (rs.next()) {
            personal_info_id = rs.getInt("personal_info_id");
        }
        // Handle Add Actions
        if ("addLan".equals(action)) {
            String newLanguage = request.getParameter("new_language");
            String proficiencyLevel = request.getParameter("proficiency_level");

            if (newLanguage != null && !newLanguage.trim().isEmpty()) {
                stmt = connection.prepareStatement(
                        "INSERT INTO languages (personal_info_id, language_name, proficiency_level) VALUES (?, ?, ?)"
                );

                stmt.setInt(1,personal_info_id);
                stmt.setString(2, newLanguage.trim());
                stmt.setString(3, proficiencyLevel.trim());

                int rowsAffected = stmt.executeUpdate();
                message = (rowsAffected > 0) ? "Language added successfully!" : "Failed to add language.";
            } else {
                message = "Language name cannot be empty!";
            }
        } else if ("addProject".equals(action)) {
            String newProject = request.getParameter("new_project");
            String description = request.getParameter("description");
            String startDate = request.getParameter("start_date");
            String endDate = request.getParameter("end_date");

            if (newProject != null && !newProject.isEmpty()) {
                stmt = connection.prepareStatement("INSERT INTO Projects (personal_info_id, project_name, description, start_date, end_date) VALUES (?, ?, ?, ?, ?)");
                stmt.setInt(1,personal_info_id);
                stmt.setString(2, newProject);
                stmt.setString(3, description);
                stmt.setString(4, startDate);
                stmt.setString(5, endDate);
                stmt.executeUpdate();
                message = "Project added successfully!";
            } else {
                message = "Project name cannot be empty!";
            }
        } else if ("addCertification".equals(action)) {
            String newCertification = request.getParameter("new_certification");
            String institution = request.getParameter("institution");
            String dateObtained = request.getParameter("date_obtained");

            if (newCertification != null && !newCertification.isEmpty()) {
                stmt = connection.prepareStatement("INSERT INTO Certifications (personal_info_id, certification_name, institution, date_obtained) VALUES (?, ?, ?, ?)");
                stmt.setInt(1,personal_info_id);
                 stmt.setString(2, newCertification);
                stmt.setString(3, institution);
                stmt.setString(4, dateObtained);
                stmt.executeUpdate();
                message = "Certification added successfully!";
            } else {
                message = "Certification name cannot be empty!";
            }
        } else if ("addWorkExperience".equals(action)) {
            String courseName = request.getParameter("course_name");
            String institution = request.getParameter("institution");
            String dateCompleted = request.getParameter("date_completed");

            if (courseName != null && !courseName.isEmpty()) {
                stmt = connection.prepareStatement("INSERT INTO ProfessionalDevelopment (personal_info_id, course_name, institution, date_completed) VALUES (?, ?, ?, ?)");
                stmt.setInt(1,personal_info_id);
                 stmt.setString(2, courseName);
                stmt.setString(3, institution);
                stmt.setString(4, dateCompleted);
                stmt.executeUpdate();
                message = "Professional development record added successfully!";
            } else {
                message = "Course name cannot be empty!";
            }
        }

        // Populate Dropdown Data
        String[] tables = { "Languages", "Projects", "Certifications", "ProfessionalDevelopment" };
        String[] columns = { "language_name", "project_name", "certification_name", "course_name","personal_info_id" };
        String[] keys = { "languages", "projects", "certifications", "workExperiences" };

        for (int i = 0; i < tables.length; i++) {
            stmt = connection.prepareStatement("SELECT id, " + columns[i] + " FROM " + tables[i] + " WHERE personal_info_id = ?");
            stmt.setInt(1, personal_info_id); // Set the personal_info_id dynamically
             System.out.println("the personal_info_id is :"+personal_info_id);
            rs = stmt.executeQuery();
            while (rs.next()) {
                dropdownData.get(keys[i]).add(new String[] { rs.getString("id"), rs.getString(columns[i]) });
            }
        }

        // Add Resume
        if ("addResume".equals(action)) {
            String objective = request.getParameter("objective");
            String education = request.getParameter("education");
            String skills = request.getParameter("skills");
            String awards = request.getParameter("awards");
            String hobbies = request.getParameter("hobbies");
            String reference = request.getParameter("reference");

            int certificationId = 0;
            try {
                certificationId = Integer.parseInt(request.getParameter("certification_id"));
            } catch (NumberFormatException e) {
                // Handle invalid integer parsing
            }

            int projectId = 0;
            try {
                projectId = Integer.parseInt(request.getParameter("project_id"));
            } catch (NumberFormatException e) {
                // Handle invalid integer parsing
            }

            int languageId = 0;
            try {
                languageId = Integer.parseInt(request.getParameter("language_id"));
            } catch (NumberFormatException e) {
                // Handle invalid integer parsing
            }

            int workExperienceId = 0;
            try {
                workExperienceId = Integer.parseInt(request.getParameter("work_experience_id"));
            } catch (NumberFormatException e) {
                // Handle invalid integer parsing
            }

            try {
                // Adjust the number of placeholders and parameters
                stmt = connection.prepareStatement(
                        "INSERT INTO detailedresumes (personal_info_id, objective, education, skills, awards, hobbies, reference, certification_id, project_id, language_id, work_experience_id) " +
                                "VALUES (personal_info_id, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                );

                stmt.setString(1, objective);
                stmt.setString(2, education);
                stmt.setString(3, skills);
                stmt.setString(4, awards);
                stmt.setString(5, hobbies);
                stmt.setString(6, reference);
                stmt.setInt(7, certificationId);
                stmt.setInt(8, projectId);
                stmt.setInt(9, languageId);
                stmt.setInt(10, workExperienceId);

                int rowsAffected = stmt.executeUpdate();
                message = (rowsAffected > 0) ? "Resume added successfully!" : "Failed to add resume.";
            } catch (SQLException e) {
                message = "An error occurred while adding the resume: " + e.getMessage();
            }
        }
    } catch (Exception e) {
        message = "An error occurred: " + e.getMessage();
        e.printStackTrace();
    } finally {
        // Close Database Resources
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error closing resources: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Professional Resume Maker</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .container {
            max-width: 1200px;                  /* Set maximum width of the container */
            width: calc(100% - 200px);          /* Adjust width to account for left margin */
                  /* Top margin for space */
            margin-left: 200px;                 /* 200px margin from the left */
            padding: 20px;                      /* Optional: internal padding */
            box-sizing: border-box;             /* Include padding in width calculation */
            overflow-x: hidden;                 /* Prevent horizontal overflow */
        }





        .form-section {
            margin-bottom: 25px; /* Increase spacing between sections */
        }

        .form-container {
            max-width: 1500px; /* Increase the maximum width of the form */
            margin: 0 auto;
            padding: 40px; /* Add padding around the content */
            background-color: #f9f9f9;
            border-radius: 12px; /* Slightly rounded corners for a more modern look */
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); /* Deeper shadow for better visual separation */
        }

        .form-label {
            font-weight: bold;
            font-size: 16px; /* Slightly larger font size for labels */
            margin-bottom: 10px;
        }

        .form-control, .form-select {
            width: 100%;
            padding: 14px; /* Increase padding for more comfortable input space */
            margin-top: 8px; /* More space between fields */
            font-size: 14px; /* Larger font size for easier readability */
            border-radius: 6px; /* Rounded corners for inputs and selects */
            border: 1px solid #ddd; /* Subtle border for inputs */
        }

        .form-select {
            background-color: #fff;
            color: #333;
        }

        .btn-primary, .btn-success {
            width: 100%;
            padding: 15px; /* Increase button padding for more comfort */
            font-size: 16px; /* Slightly larger font size for buttons */
            border-radius: 6px;
            margin-top: 15px; /* More space above buttons */
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }

        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }

        .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
        }

        /* Additional Styling for textareas to match the form width */
        textarea.form-control {
            font-size: 14px; /* Consistent font size with other form fields */
            border-radius: 6px;
            padding: 14px;
        }

        /* Optional: Improve layout for mobile screens */
        @media (max-width: 768px) {
            .form-container {
                padding: 20px;
            }

            .form-control, .form-select, .btn-primary, .btn-success {
                padding: 12px; /* Reduce padding slightly on smaller screens */
            }
        }

    </style>
</head>
<body>
<div class="container">


    <form action="adddetailedresumes.jsp" method="post" class="form-container">
        <div class="two-column">
            <!-- Language Section -->
            <div class="form-section">
                <label for="language_id" class="form-label">Language:</label>
                <div class="input-group">
                    <select name="language_id" id="language_id" class="form-select">
                        <% for (String[] language : dropdownData.get("languages")) { %>
                        <option value="<%= language[0] %>"><%= language[1] %></option>
                        <% } %>
                    </select>
                    <input type="text" name="new_language" class="form-control" placeholder="Add new language" />
                    <input type="text" name="proficiency_level" class="form-control" placeholder="Proficiency Level" />
                </div>
                <button type="submit" name="action" value="addLan" class="btn btn-primary w-100 mt-2">Add Language</button>
            </div>

            <!-- Project Section -->
            <div class="form-section">
                <label for="project_id" class="form-label">Project:</label>
                <div class="input-group">
                    <select name="project_id" id="project_id" class="form-select">
                        <% for (String[] project : dropdownData.get("projects")) { %>
                        <option value="<%= project[0] %>"><%= project[1] %></option>
                        <% } %>
                    </select>
                    <input type="text" name="new_project" class="form-control" placeholder="Add new project" />
                    <input type="text" name="description" class="form-control" placeholder="Description" />
                    <label for="date_obtained" class="form-label">start date:</label> <input type="date" name="start_date" class="form-control" placeholder="Start Date" />
                    <label for="date_obtained" class="form-label">End Date:</label> <input type="date" name="end_date" class="form-control" placeholder="End Date" />
                </div>
                <button type="submit" name="action" value="addProject" class="btn btn-primary w-100 mt-2">Add Project</button>
            </div>

            <!-- Certification Section -->
            <div class="form-section">
                <label for="certification_id" class="form-label">Certification:</label>
                <div class="input-group">
                    <select name="certification_id" id="certification_id" class="form-select">
                        <% for (String[] certification : dropdownData.get("certifications")) { %>
                        <option value="<%= certification[0] %>"><%= certification[1] %></option>
                        <% } %>
                    </select>
                    <input type="text" name="new_certification" class="form-control" placeholder="Add new certification" />
                    <input type="text" name="institution" class="form-control" placeholder="Institution" />
                    <label for="date_obtained" class="form-label">Date Obtained:</label>
                    <input type="date" name="date_obtained" id="date_obtained" class="form-control" />


                </div>
                <button type="submit" name="action" value="addCertification" class="btn btn-primary w-100 mt-2">Add Certification</button>
            </div>

            <!-- Professional Development Section -->
            <div class="form-section">
                <label for="work_experience_id" class="form-label">Professional Development:</label>
                <div class="input-group">
                    <select name="work_experience_id" id="work_experience_id" class="form-select">
                        <% for (String[] experience : dropdownData.get("workExperiences")) { %>
                        <option value="<%= experience[0] %>"><%= experience[1] %></option>
                        <% } %>
                    </select>
                    <input type="text" name="course_name" class="form-control" placeholder="Course Name" />
                    <input type="text" name="institution" class="form-control" placeholder="Institution" />
                    <label for="date_obtained" class="form-label">Date completed:</label><input type="date" name="date_completed" class="form-control" placeholder="Date Completed" />
                </div>
                <button type="submit" name="action" value="addWorkExperience" class="btn btn-primary w-100 mt-2">Add Development</button>
            </div>
        </div>

        <!-- Additional Sections -->
        <div class="form-section">
            <label for="objective" class="form-label">Objective:</label>
            <textarea name="objective" id="objective" rows="4" class="form-control" placeholder="Enter your career objective"></textarea>
        </div>

        <div class="form-section">
            <label for="skills" class="form-label">Skills:</label>
            <textarea name="skills" id="skills" rows="4" class="form-control" placeholder="Enter your skills"></textarea>
        </div>

        <!-- Submit Button -->
        <div class="form-section">
            <button type="submit" name="action" value="addResume" class="btn btn-success w-100">Add Resume</button>
        </div>
    </form>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


