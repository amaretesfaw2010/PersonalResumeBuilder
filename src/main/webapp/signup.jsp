
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Signup</title>
</head>
<body>

<h1>User Signup</h1>

<%-- Display error or success messages --%>
<% if (request.getAttribute("message") != null) { %>
<p style="color:red;"><%= request.getAttribute("message") %></p>
<% } %>

<form action="SignupServlet" method="post">
    <div>
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required>
    </div>
    <div>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>
    </div>
    <div>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
    </div>
    <div>
        <label for="role">Role:</label>
        <input type="text" id="role" name="role" required>
    </div>
    <div>
        <button type="submit" name="action" value="signup">Sign Up</button>
    </div>
</form>

<p>Already have an account? <a href="login.jsp">Login here</a></p>

</body>
</html>

