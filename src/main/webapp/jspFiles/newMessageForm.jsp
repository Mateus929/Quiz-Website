<%--
  Created by IntelliJ IDEA.
  User: Pavilion
  Date: 7/5/2024
  Time: 10:18 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>New Message</title>
    <link rel="stylesheet" href="../Mail/NewMailStyle.css">
</head>
<body>
<div id="wrapper">
    <div id="content">
        <h1>Send Message</h1>

        <form action="sendMessage" method="post">
            <div>
                <label for="recipientUsername">Recipient Username:</label>
                <input type="text" id="recipientUsername" name="recipientUsername" required>
            </div>
            <div>
                <label for="Subject">Subject:</label>
                <input type="text" id="Subject" name="Subject">
            </div>
            <div>
                <label for="mail_text">Message:</label>
                <textarea id="mail_text" name="mail_text" rows="5" cols="40" required></textarea>
            </div>
            <div>
                <input type="submit" value="Send Message">
            </div>
        </form>
        <form action="UserHomePage" method="get">
            <div>
                <input type="submit" value="Go to homepage">
            </div>
        </form>
    </div>
</div>
</body>
</html>
