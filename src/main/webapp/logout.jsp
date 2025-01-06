<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // Prevent caching of this page
  response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);

  // Invalidate the current session
  if (session != null) {
    session.invalidate();
  }

  // Redirect to the login page
  response.sendRedirect("login.jsp");
%>
