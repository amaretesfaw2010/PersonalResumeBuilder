<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Education Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .sidebar {
            height: 100vh;
            background-color: #343a40;
            color: #fff;
            position: fixed;
            padding-top: 20px;
            width: 250px;
        }
        .sidebar a {
            color: #adb5bd;
            text-decoration: none;
            padding: 10px 20px;
            display: block;
        }
        .sidebar a:hover {
            background-color: #495057;
            color: #fff;
        }
        .sidebar .active {
            background-color: #495057;
        }
        .content {
            margin-left: 250px;
            padding: 20px;
        }
        .card {
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!-- Sidebar -->
<div class="sidebar">
    <h3 class="text-center">Education Dashboard</h3>
    <a href="dashboard.jsp" class="active" onclick="loadContent('dashboard.jsp')"><i class="fas fa-home"></i> Dashboard</a>
    <a href="userpersonalinfo.jsp" onclick="loadContent('userPersonalInfo')"><i class="fas fa-user"></i> Personal Info</a>
    <a href="adddetailedresumes.jsp" onclick="loadContent('userPersonalInfo')"><i class="fas fa-user"></i> professional Resume </a>
    <a href="teachingphilosophy.jsp" onclick="loadContent('teachingPhilosophy')"><i class="fas fa-lightbulb"></i> Teaching Philosophy</a>
    <a href="viewteachingphilosopy.jsp" onclick="loadContent('teachingPhilosophy')"><i class="fas fa-lightbulb"></i>ViewTeaching Philosophy  </a>
    <a href="teachingideology.jsp" onclick="loadContent('teachingPhilosophy')"><i class="fas fa-lightbulb"></i>Teaching ideology  </a>
    <a href="viewteachingideology.jsp" onclick="loadContent('lessonPlans')"><i class="fas fa-book"></i>View teach ideology</a>
    <a href="teachingreflection.jsp" onclick="loadContent('reflections')"><i class="fas fa-pen"></i>Teaching  Reflections</a>
    <a href="downloadResume.jsp" onclick="loadContent('settings')"><i class="fas fa-cogs"></i> Download Resume</a>
    <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Main Content -->
<div class="content">
    <div class="container-fluid" id="mainContent">

    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery for AJAX -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>



</body>
</html>
