<%@ page import="java.util.ArrayList" %>
<%@ page import="Quiz.*" %>
<%@ page import="java.util.Random" %><%--
  Created by IntelliJ IDEA.
  User: User
  Date: 06.07.2024
  Time: 15:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quiz Page</title>
    <link rel="stylesheet" href="../quizPage/styles.css">
</head>
<body>
    <%
        ArrayList<QuizTask> tasks = ((ArrayList<QuizTask>)session.getAttribute("tasks"));
        String index = request.getParameter("index");
        String quiz_id = request.getParameter("quiz_id");
        int i = Integer.parseInt(index);
        QuizTask quizTask = tasks.get(i);
    %>
    <form action="../quizPage" method="post" class = "wrapper">
        <%
            ArrayList<String> values = (ArrayList<String>) session.getAttribute("values");
            String value = "";
            if(values.size() > i) value = values.get(i);
            switch (quizTask.getType()) {
                case TaskTypes.QUESTION_RESPONSE:
                    QuestionResponseTask taskQRT = (QuestionResponseTask)quizTask;
                    out.println("<p>Question:" +  taskQRT.getQuestion().getQuestionText() + "</p>");
                    out.println("<label>Answer: <input type=\"text\" name=\"answer\" value = " + value + "></label>");
                break;
                case TaskTypes.FILL_BLANK:
                    FillBlankTask taskFBT = (FillBlankTask) quizTask;
                    out.println("<p>Fill in the blank:</p>");
                    out.println("<p>" + taskFBT.getQuestion().getQuestionText() + " <label><input type=\"text\" name=\"answer\" value = " + value + "></label>");
                break;
                case TaskTypes.MULTIPLE_CHOICE:
                    MultipleChoiceTask taskMCT = (MultipleChoiceTask) quizTask;
                    String questionText = taskMCT.getQuestion().getQuestionText();
                    out.println("<p>Question:" + questionText + "</p>");
                    String correctAnswer = taskMCT.getQuestion().getAnswer().getCorrectAnswerAt(0);
                    Answer wrongAnswer = taskMCT.getQuestion().getAnswer();
                    Random random = new Random();
                    int idx = random.nextInt(wrongAnswer.getWrongAnswersNumber());
                    for(int j = 0; j < wrongAnswer.getWrongAnswersNumber(); j++) {
                        String text = wrongAnswer.getWrongAnswerAt(j);
                        if(j == idx) {
                            text = correctAnswer;
                            j--;
                            idx = -1;
                        }
                        if(text.equals(value)) out.println("<label><input type=\"radio\" name=\"answer\" value=\"" + text + "\" autocomplete=\"off\" checked />" + text + "</label>");
                        else out.println("<label><input type=\"radio\" name=\"answer\" value=\"" + text + "\" autocomplete=\"off\" />" + text + "</label>");
                    }
                break;
                case TaskTypes.PICTURE_RESPONSE:
                    PictureResponseTask taskPRT = (PictureResponseTask) quizTask;
                    out.println("<p>Question:" +  taskPRT.getQuestion().getQuestionText() + "</p>");
                    out.println("<img src=\"" + taskPRT.getQuestion().getImgUrl() + "\" alt=\"sorry image does not load\">");
                    out.println("<label>Answer: <input type=\"text\" name=\"answer\" value = " + value + "></label>");
                break;
            }
        %>
        <input type="hidden" name="quiz_id" value=<%=quiz_id%>>
        <input type="hidden" name="index" value="<%=i%>">
        <input type="submit" value="Next Task">
    </form>
</body>
</html>
