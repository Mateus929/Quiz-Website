<%@ page import="java.sql.SQLException" %>
<%@ page import="User.Mail" %>
<%@ page import="User.UserDAO" %><%--
  Created by IntelliJ IDEA.
  User: Pavilion
  Date: 7/6/2024
  Time: 2:33 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Mail</title>
    <link rel="stylesheet" href="../Mail/readMailStyle.css">
</head>
<body>

<div id="wrapper">
    <div id="content">
        <h1>Mail Detail</h1>
        <div class="mail-detail">
            <%
                session = request.getSession(false);
                String mailId = (String) session.getAttribute("mailId");
                if (mailId != null) {
                    UserDAO dao = new UserDAO();
                    try {
                        Mail mail = dao.getMailById(mailId);
                        String sender_username = dao.getUser(mail.getSender_id()).getUserName();
            %>
            <div class="mail-item">
    <p><strong>From: </strong><%= sender_username
    %></p>
    <p><strong>Date: </strong><%= mail.getSend_date() %></p>
    <p><%= mail.getMail_text() %></p>
</div>
<%
                } catch (SQLException e) {
                out.println("Error retrieving mail: " + e.getMessage());
            }
            } else { %>
            <p>No mail selected.</p>
            <% } %>
        </div>
        <div class="button-container">
            <form action="replay" method="get">
                <button type="submit" class="replay">Replay</button>
            </form>
            <form action="inbox" method="get">
                <button type="submit" class="back">Back to Inbox</button>
            </form>
            <form action="deleteMail" method="post">
                <button type="submit" class="delete">Delete this mail</button>
            </form>
        </div>
    </div>
</div>

</body>
</html>
