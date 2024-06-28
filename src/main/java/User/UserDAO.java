package User;

import DataBaseConnectionPool.DataBaseConnectionPool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class UserDAO {
    public void addUser(User user) throws SQLException {
        Connection con = DataBaseConnectionPool.getInstance().getConnection();
        String query = "INSERT INTO users_table (username, email, password) VALUES (?, ?, ?)";
        PreparedStatement stm = con.prepareStatement(query);
        stm.setString(1, user.getUserName());
        stm.setString(2, user.getEmail());
        stm.setString(3, user.getPassword());
        stm.executeUpdate();
    }

    public String getUserId(String username) throws SQLException{
        Connection con = DataBaseConnectionPool.getInstance().getConnection();
        String query = "SELECT user_id FROM users_table WHERE username = ?";
        PreparedStatement stm = con.prepareStatement(query);
        stm.setString(1, username);
        ResultSet set = stm.executeQuery();
        String id = null;
        if(set.next()) {
            id = set.getString("user_id");
        }
        return id;
    }

    public User getUser(String id) throws SQLException{
        Connection con = DataBaseConnectionPool.getInstance().getConnection();
        String query = "SELECT * FROM users_table WHERE user_id = ?";
        PreparedStatement stm = con.prepareStatement(query);
        stm.setString(1, id);
        ResultSet set = stm.executeQuery();
        User user = null;
        if (set.next()) {
            String username = set.getString("username");
            String password = set.getString("password");
            String email = set.getString("email");
            user = new User(username, password, email);
        }
        return user;
    }

    public ArrayList<Performance> getUserPerformanceHistory(String user_id) throws SQLException{
        Connection con = DataBaseConnectionPool.getInstance().getConnection();
        String query = "SELECT * FROM performances_table WHERE user_id = ? ORDER BY date DESC";
        PreparedStatement statement = con.prepareStatement(query);
        statement.setString(1, user_id);
        ResultSet set = statement.executeQuery();
        ArrayList<Performance> result = new ArrayList<>();
        while(set.next()) {
            String quiz_id = set.getString("quiz_id");
            double score = set.getDouble("score");
            String date = set.getString("date");
            result.add(new Performance(quiz_id, score, date));
        }
        return result;
    }

    public ArrayList<User> getFriendsForUser(String userName) throws SQLException {
        Connection con = DataBaseConnectionPool.getInstance().getConnection();
        ArrayList<User> result = new ArrayList<>();
        String user_id = getUserId(userName);
        String query = "SELECT * FROM relations_table WHERE user1_id = " + user_id + " OR user2_id = " + user_id;
        PreparedStatement statement = con.prepareStatement(query);
        ResultSet rs = statement.executeQuery();
        while(rs.next()) {
            String user1_id = rs.getString("user1_id");
            String user2_id = rs.getString("user2_id");
            int isPending = rs.getInt("isPending");
            if(isPending == 0){
                User newUser;
                if(!user1_id.equals(user_id)){
                    newUser = getUser(user1_id);
                } else {
                    newUser = getUser(user2_id);
                }
                result.add(newUser);
            }
        }
        return result;
    }
}