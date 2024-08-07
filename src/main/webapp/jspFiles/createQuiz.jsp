<%@ page import="java.util.ArrayList" %>
<%@ page import="Quiz.QuizTask" %>
<%@ page import="Quiz.TaskTypes" %> <%--
  Created by IntelliJ IDEA.
  User: User
  Date: 27.06.2024
  Time: 15:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>createQuiz</title>
    <link rel="stylesheet" href="../createQuiz/quizStyles.css">
</head>
<body>
    <div id = "Wrapper">
        <div id = "TasksWrapper">
            <h2>Tasks:</h2>
            <ol>
                <%
                   ArrayList<QuizTask> tasks = (ArrayList<QuizTask>) session.getAttribute("Tasks");
                   for(QuizTask task : tasks) {
                %>
                <li>
                        <%
                            switch (task.getType()){
                                case TaskTypes.QUESTION_RESPONSE:
                                    out.print("Question-Response Task");
                                    break;
                                case TaskTypes.FILL_BLANK:
                                    out.print("Fill In The Blank Task");
                                    break;
                                case TaskTypes.MULTIPLE_CHOICE:
                                    out.print("Multiple Choice Task");
                                    break;
                                case TaskTypes.PICTURE_RESPONSE:
                                    out.print("Picture-Response Task");
                                    break;
                            }
                        %>
                </li>
                <%
                    }
                %>
            </ol>
        </div>
        <div id = "QuizProperties">
            <form action = 'addTask' method = 'GET'>
                <label for = "TaskType">Choose Task Type: </label>
                <select name = "TaskType" id = "TaskType">
                    <option value = "FillBlankTask">Fill In The Blank Task</option>
                    <option value = "MultipleChoiceTask">Multiple Choice Task</option>
                    <option value = "QuestionResponseTask">Question-Response Task</option>
                    <option value = "PictureResponseTask">Picture-Response Task</option>
                </select>
                <input type = "submit" value = "Add Task">
            </form>
            <form action="createQuiz" method="post" id = "CreateQuizForm">
                <label for="quizAppearence">Choose How To Appear The Quiz: </label>
                <select name="quizAppearence" id="quizAppearence">
                    <option value="MultiplePage">Multiple-Page</option>
                    <option value="OnePage">One-Page</option>
                </select><br>
                <label for="tasksOrder">Choose In What Order The Tasks Should Appear: </label>
                <select name="tasksOrder" id="tasksOrder">
                    <option value="AlwaysSameOrder">Order of Creation</option>
                    <option value="RandomizedOrder">Randomized Order</option>
                </select><br>
                <label for="quizDescription">Enter Quiz Description:</label>
                <textarea name="quizDescription" id="quizDescription"></textarea>
                <label for="quizName">Enter Quiz Name:</label>
                <input type="text" id="quizName" name="quizName" required>
                <input type="submit" value="Add Quiz">
            </form>
        </div>
    </div>
</body>
</html>
