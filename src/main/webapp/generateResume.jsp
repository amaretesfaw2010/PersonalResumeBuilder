
<%@ page import="com.itextpdf.kernel.pdf.PdfWriter" %>
<%@ page import="com.itextpdf.kernel.pdf.PdfDocument" %>
<%@ page import="com.itextpdf.layout.Document" %>
<%@ page import="com.itextpdf.layout.element.Paragraph" %>
<%@ page import="com.itextpdf.layout.property.TextAlignment" %>
<%@ page import="com.itextpdf.barcodes.Barcode128" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Gather form input data from the request
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String skills = request.getParameter("skills");
    String experience = request.getParameter("experience");
    String education = request.getParameter("education");

    // Check if PDF is requested
    if ("true".equals(request.getParameter("pdf"))) {
        // Generate the PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=resume.pdf");

        // Initialize PDF document writer
        PdfWriter writer = new PdfWriter(response.getOutputStream());
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc);

        // Add content to the PDF document using iText 7 API
        document.add(new Paragraph(firstName + " " + lastName)
                .setTextAlignment(TextAlignment.CENTER).setFontSize(18));
        document.add(new Paragraph("Email: " + email).setFontSize(12));
        document.add(new Paragraph("Phone: " + phone).setFontSize(12));
        document.add(new Paragraph("Address: " + address).setFontSize(12));

        document.add(new Paragraph("\nSkills").setFontSize(14).setTextAlignment(TextAlignment.LEFT));
        document.add(new Paragraph(skills).setFontSize(12));

        document.add(new Paragraph("\nWork Experience").setFontSize(14).setTextAlignment(TextAlignment.LEFT));
        document.add(new Paragraph(experience).setFontSize(12));

        document.add(new Paragraph("\nEducation").setFontSize(14).setTextAlignment(TextAlignment.LEFT));
        document.add(new Paragraph(education).setFontSize(12));

        // Adding a Barcode128
        Barcode128 barcode = new Barcode128(pdfDoc);
        barcode.setCode("123456789");  // Example code for barcode
        document.add(barcode.createFormXObject(com.itextpdf.kernel.color.ColorConstants.BLACK, pdfDoc));

        // Closing the document
        document.close();
    } else {
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generated Resume</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <h1 class="text-center mt-5">Generated Resume</h1>

    <!-- Form to gather user input -->
    <form method="post">
        <div class="mb-3">
            <label for="firstName" class="form-label">First Name</label>
            <input type="text" id="firstName" name="firstName" class="form-control" value="<%= firstName %>" required>
        </div>
        <div class="mb-3">
            <label for="lastName" class="form-label">Last Name</label>
            <input type="text" id="lastName" name="lastName" class="form-control" value="<%= lastName %>" required>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" id="email" name="email" class="form-control" value="<%= email %>" required>
        </div>
        <div class="mb-3">
            <label for="phone" class="form-label">Phone</label>
            <input type="tel" id="phone" name="phone" class="form-control" value="<%= phone %>" required>
        </div>
        <div class="mb-3">
            <label for="address" class="form-label">Address</label>
            <textarea id="address" name="address" class="form-control" rows="3" required><%= address %></textarea>
        </div>
        <div class="mb-3">
            <label for="skills" class="form-label">Skills</label>
            <textarea id="skills" name="skills" class="form-control" rows="3" required><%= skills %></textarea>
        </div>
        <div class="mb-3">
            <label for="experience" class="form-label">Work Experience</label>
            <textarea id="experience" name="experience" class="form-control" rows="3" required><%= experience %></textarea>
        </div>
        <div class="mb-3">
            <label for="education" class="form-label">Education</label>
            <textarea id="education" name="education" class="form-control" rows="3" required><%= education %></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Generate Resume</button>
        <a href="<%= request.getRequestURI() + "?pdf=true" %>" class="btn btn-success ml-3">Download as PDF</a>
    </form>

    <hr>

    <h2><%= firstName %> <%= lastName %></h2>
    <p><strong>Email: </strong><%= email %></p>
    <p><strong>Phone: </strong><%= phone %></p>
    <p><strong>Address: </strong><%= address %></p>

    <h3>Skills</h3>
    <p><%= skills %></p>

    <h3>Work Experience</h3>
    <p><%= experience %></p>

    <h3>Education</h3>
    <p><%= education %></p>

</div>
</body>
</html>

<%
    }
%>
