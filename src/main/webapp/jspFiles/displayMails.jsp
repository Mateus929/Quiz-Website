<%@ page import="User.Mail" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="User.UserDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="User.User" %><%--
  Created by IntelliJ IDEA.
  User: Pavilion
  Date: 7/5/2024
  Time: 6:39 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Display Mails</title>
    <link rel="stylesheet" href="../Mail/InboxStyle.css">
</head>
<body>
<div id="wrapper">
    <div id="content">
        <h1>Inbox</h1>
        <div class="mail-list">
            <%-- Retrieve mails attribute from session --%>
            <% ArrayList<Mail> mails = (ArrayList<Mail>) session.getAttribute("mails"); %>
            <% if (mails != null && !mails.isEmpty()) { %>
            <ul>
                <% for (Mail mail : mails) { %>
                <li>
                    <div class="mail-item">
                        <p><strong>From: </strong><%= mail.getSender_id() %></p>
                        <p><strong>Date: </strong><%= mail.getSend_date() %></p>
                        <p><%= mail.getMail_text() %></p>
                    </div>
                </li>
                <% } %>
            </ul>
                <% } else { %>
            <p>You have no mails yet.</p>
            <%}%>
        </div>
        <div class="button-container">
            <form action="sendMessage" method="get">
                <button type="submit" class="newMessage">Send New Message</button>
            </form>
            <form action="UserHomePage" method="get">
                <button type="submit" class="homepage">Go to homepage</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>