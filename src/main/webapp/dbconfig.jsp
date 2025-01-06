<%@ page import="java.sql.*" %>
<%
    // Database connection details
    String jdbcUrl = "jdbc:mysql://localhost:3307/teacherdb";
    String jdbcUsername = "root";
    String jdbcPassword = "";

    Connection connection = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
