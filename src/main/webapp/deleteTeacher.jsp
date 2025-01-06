<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
  String teacherId = request.getParameter("id");

  if (teacherId != null) {
    try {
      // Database connection
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/teacherdb", "root", "");


      // Delete teacher from the database
      String query = "DELETE FROM teachers WHERE id = ?";
      PreparedStatement pstmt = conn.prepareStatement(query);
      pstmt.setInt(1, Integer.parseInt(teacherId));
      pstmt.executeUpdate();

      out.println("<p>Teacher deleted successfully!</p>");
      conn.close();
    } catch (Exception e) {
      out.println("<p>Error: " + e.getMessage() + "</p>");
    }
  } else {
    out.println("<p>Invalid teacher ID.</p>");
  }
%>
<a href="manageTeachers.jsp">Back to Manage Teachers</a>
