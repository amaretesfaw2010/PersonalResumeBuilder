<%@ page import="com.itextpdf.kernel.pdf.PdfWriter" %>
<%@ page import="com.itextpdf.kernel.pdf.PdfDocument" %>
<%@ page import="com.itextpdf.layout.element.Paragraph" %>
<%@ page import="com.itextpdf.layout.Document" %>
<%@ page import="com.itextpdf.layout.element.LineSeparator" %>
<%@ page import="com.itextpdf.kernel.pdf.canvas.draw.SolidLine" %>
<%@ page import="java.sql.*" %>
<%@ include file="dashboard.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String jdbcUrl = "jdbc:mysql://localhost:3307/teacherdb";
    String jdbcUsername = "root";
    String jdbcPassword = "";
    Connection connection = null;
    PreparedStatement stmt = null;
    PreparedStatement stmt2 = null;
    String message = "";

    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
        System.out.println("Database connected successfully.");

        String username = (String) session.getAttribute("username");

        if (username == null || username.isEmpty()) {
            out.println("<html><body><h3>Error: User not logged in.</h3></body></html>");
            return;
        }

        if (request.getParameter("submit") != null) {
            // Get user's personal info ID
            String userSql = "SELECT personal_info_id FROM users WHERE username = ?";
            stmt = connection.prepareStatement(userSql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            int personalInfoId = 0;
            if (rs.next()) {
                personalInfoId = rs.getInt("personal_info_id");
            }

            if (personalInfoId == 0) {
                out.println("<html><body><h3>Error: Personal information not found for the user.</h3></body></html>");
                return;
            }

            // Retrieve personal information
            String selectSql = "SELECT name, email, phone, address FROM personalinformation WHERE id = ?";
            stmt = connection.prepareStatement(selectSql);
            stmt.setInt(1, personalInfoId);
            rs = stmt.executeQuery();

            String name = "", email = "", phone = "", address = "";
            if (rs.next()) {
                name = rs.getString("name");
                email = rs.getString("email");
                phone = rs.getString("phone");
                address = rs.getString("address");
            }

            // Retrieve certifications
            String selectCertifications = "SELECT certification_name, institution, date_obtained FROM certifications WHERE personal_info_id = ?";
            stmt2 = connection.prepareStatement(selectCertifications);
            stmt2.setInt(1, personalInfoId);
            ResultSet rs2 = stmt2.executeQuery();

            String jobTitle = "", company = "", degree = "", institution = "", skills = "";
            Date duration = null;
            if (rs2.next()) {
                jobTitle = rs2.getString("certification_name");
                company = rs2.getString("institution");
                duration = rs2.getDate("date_obtained");
                degree = rs2.getString("certification_name");
                institution = rs2.getString("institution");
                skills = rs2.getString("certification_name"); // Placeholder for demonstration
            }

            // Set response headers for PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=CV_Europass.pdf");

            // Create the PDF
            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);

            // Title Section
            document.add(new Paragraph("Europass Curriculum Vitae").setBold().setFontSize(18).setMarginBottom(20));

            // Personal Information
            document.add(new Paragraph("Personal Information").setBold().setFontSize(14));
            document.add(new Paragraph("Name: " + name));
            document.add(new Paragraph("Email: " + email));
            document.add(new Paragraph("Phone: " + phone));
            document.add(new Paragraph("Address: " + address));
            document.add(new Paragraph(" "));

            // Line separator between sections
            LineSeparator separator = new LineSeparator(new SolidLine(1f));
            separator.setWidth(500f);
            separator.setMarginTop(10f);
            document.add(separator);

            // Job Applied For
            document.add(new Paragraph("Job Applied For").setBold().setFontSize(14));
            document.add(new Paragraph("Job Title: " + jobTitle));
            document.add(new Paragraph("Company: " + company));
            document.add(new Paragraph("Duration: " + (duration != null ? duration.toString() : "N/A")));
            document.add(new Paragraph(" "));

            // Line separator between sections
            document.add(separator);

            // Education and Training
            document.add(new Paragraph("Education and Training").setBold().setFontSize(14));
            document.add(new Paragraph("Degree: " + degree));
            document.add(new Paragraph("Institution: " + institution));
            document.add(new Paragraph("Skills: " + skills));
            document.add(new Paragraph(" "));

            // Line separator after skills
            document.add(separator);

            // Close the document
            document.close();
            connection.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<html><body><h3>Error: " + e.getMessage() + "</h3></body></html>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate CV as PDF</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        button {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Generate Your CV as a Europass PDF</h2>
    <form>
        <button type="submit" name="submit">Generate Europass PDF</button>
    </form>
</div>
</body>
</html>
