package Servlets.Quiz.QuizPage;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

public class DisplayQuizzes extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        HttpSession session = request.getSession();
        session.setAttribute("type", type);
        System.out.println("here");
        if(type.equals("performance")) {
            request.getRequestDispatcher("jspFiles/displayPerformances.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("jspFiles/displayQuizzes.jsp").forward(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
