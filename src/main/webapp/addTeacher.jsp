<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String teacherName = request.getParameter("teacherName");

    if (teacherName != null && !teacherName.trim().isEmpty()) {
        try {
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/teacherdb", "root", "");

            // Insert teacher into the database
            String query = "INSERT INTO teachers (name) VALUES (?)";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, teacherName);
            pstmt.executeUpdate();

            out.println("<p>Teacher added successfully!</p>");
            conn.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p>Please enter a valid teacher name.</p>");
    }
%>
<a href="manageTeachers.jsp">Back to Manage Teachers</a>
