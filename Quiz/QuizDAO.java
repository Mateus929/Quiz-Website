package Quiz;

import DataBaseConnectionPool.DataBaseConnectionPool;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import static Quiz.TaskTypes.*;

public class QuizDAO {
    public String addQuiz(Quiz quiz) {
        /// adding quiz in base
        Connection con = DataBaseConnectionPool.getInstance().getConnection();
        String query = "INSERT INTO quizzes_table (quiz_author) VALUES(?)";
        try {
            PreparedStatement stm = con.prepareStatement(query);
            stm.setString(1, quiz.author);
            stm.executeUpdate();
            ResultSet res = con.createStatement().executeQuery("SELECT LAST_INSERT_ID();");
            if(res.next()) {
                String id = res.getString(1);
                for(int i = 0; i < quiz.tasks.size(); i++) {
                    addTask(quiz.tasks.get(i), con, id);
                }
                DataBaseConnectionPool.getInstance().closeConnection(con);
                return id;
            } else {
                throw new Exception("Mysql command LAST_INSERT_ID failed");
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void addTask(QuizTask task, Connection con, String quizId) {
        String query = "INSERT INTO tasks_table (task_type, quiz_id) VALUES(?, ?)";
        try {
            PreparedStatement stm = con.prepareStatement(query);
            stm.setString(1, String.valueOf(task.getType()));
            stm.setString(2, quizId);
            stm.executeUpdate();
            ResultSet res = con.createStatement().executeQuery("SELECT LAST_INSERT_ID();");
            if(res.next()) {
                String id = res.getString(1);
                for(int i = 0; i < task.getListSize(); i++) {
                    addQuestion(task.getQuestionAt(i), con, id);
                }
            } else {
                throw new Exception("Mysql command LAST_INSERT_ID failed");
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void addQuestion(Question question, Connection con, String taskId) {
        /// adding question
        String query = "INSERT INTO questions_table (question_text, image, task_id) VALUES(?, ?, ?)";
        try {
            PreparedStatement stm = con.prepareStatement(query);
            stm.setString(1, String.valueOf(question.getQuestionText()));
            stm.setString(2, String.valueOf(question.getImgUrl()));
            stm.setString(3, taskId);
            stm.executeUpdate();
            ResultSet res = con.createStatement().executeQuery("SELECT LAST_INSERT_ID();");
            if(res.next()) {
                String id = res.getString(1);
                String ans_query = "INSERT INTO answers_table (answer_text, isCorrect, answer_order, question_id) VALUES(?, ?, ?, ?)";
                for(int i = 0; i < question.getAnswer().getCorrectAnswersNumber(); i++) {
                    PreparedStatement statement = con.prepareStatement(ans_query);
                    statement.setString(1, question.getAnswer().getCorrectAnswerAt(i));
                    statement.setString(2, "1");
                    statement.setString(3, "0");
                    statement.setString(4, id);
                    statement.executeUpdate();
                }
                for(int i = 0; i < question.getAnswer().getWrongAnswersNumber(); i++) {
                    PreparedStatement statement = con.prepareStatement(ans_query);
                    statement.setString(1, question.getAnswer().getWrongAnswerAt(i));
                    statement.setString(2, "0");
                    statement.setString(3, "0");
                    statement.setString(4, id);
                    statement.executeUpdate();
                }
            } else {
                throw new Exception("Mysql command LAST_INSERT_ID failed");
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Quiz getQuiz(String id) {
        try {
            Connection con = DataBaseConnectionPool.getInstance().getConnection();
            ResultSet res = con.createStatement().executeQuery("SELECT * FROM quizzes_table WHERE quiz_id = " + id + ";");
            if(res.next()) {
                ArrayList<QuizTask> tasks = getTasks(id, con);
                String author = res.getString("quiz_author");
                DataBaseConnectionPool.getInstance().closeConnection(con);
                return new Quiz(author, tasks);
            } else {
                DataBaseConnectionPool.getInstance().closeConnection(con);
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private ArrayList<QuizTask> getTasks(String id, Connection con) {
        try {
            ArrayList<QuizTask> tasks = new ArrayList<QuizTask>();
            ResultSet res = con.createStatement().executeQuery("SELECT * FROM tasks_table WHERE quiz_id = " + id + ";");
            while(res.next()) {
                String task_id = res.getString("task_id");
                ArrayList<Question> questions = getQuestions(task_id, con);
                if(questions == null) continue;
                int type = res.getInt("task_type");
                switch (type) {
                    case FILL_BLANK : {
                        FillBlankTask task = new FillBlankTask(questions.get(0));
                        tasks.add(task);
                        break;
                    }
                    case QUESTION_RESPONSE : {
                        QuestionResponseTask task = new QuestionResponseTask(questions.get(0));
                        tasks.add(task);
                        break;
                    }
                    case MULTIPLE_CHOICE : {
                        MultipleChoiceTask task = new MultipleChoiceTask(questions.get(0));
                        tasks.add(task);
                        break;
                    }
                    case PICTURE_RESPONSE : {
                        PictureResponseTask task = new PictureResponseTask(questions.get(0));
                        tasks.add(task);
                        break;
                    }
                }
            }
            return (!tasks.isEmpty()) ? tasks : null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private ArrayList<Question> getQuestions(String task_id, Connection con) {
        try {
            ArrayList<Question> questions = new ArrayList<Question>();
            ResultSet res = con.createStatement().executeQuery("SELECT * FROM questions_table WHERE task_id = " + task_id + ";");
            while(res.next()) {
                String question_id = res.getString("question_id");
                Answer answers = getAnswer(question_id, con);
                String question = res.getString("question_text");
                String image = res.getString("image");
                questions.add(new Question(answers, question, image));
            }
            return (!questions.isEmpty()) ? questions : null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private Answer getAnswer(String question_id, Connection con) {
        try {
            ArrayList<String> correct = new ArrayList<>(), wrong = new ArrayList<>();
            ResultSet res = con.createStatement().executeQuery("SELECT * FROM answers_table WHERE question_id = " + question_id + " ORDER BY answer_order;");
            while(res.next()) {
                String text = res.getString("answer_text");
                if(res.getString("isCorrect").equals("1")) {
                    correct.add(text);
                } else {
                    wrong.add(text);
                }
            }
            if(correct.isEmpty()) return null;
            return new Answer(correct, wrong);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
