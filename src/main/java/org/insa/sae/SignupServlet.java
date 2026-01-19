package org.insa.sae;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pronte";
    private static final String DB_USER = "root";
    private static final String DB_PWD = ""; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        
        request.setCharacterEncoding("UTF-8");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String mdp = request.getParameter("mdp");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            
            Class.forName("com.mysql.cj.jdbc.Driver");

            
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PWD);

           
            // Je suppose qu'IDUser est en AUTO_INCREMENT
            String sql = "INSERT INTO User (nom, prenom, role, username, mdp) VALUES (?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, nom);
            stmt.setString(2, prenom);
            stmt.setString(3, role);
            stmt.setString(4, username);
            stmt.setString(5, mdp); //Ne pas oublier le hashage

        
            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("login.jsp?success=1");
            } else {
                request.setAttribute("errorMessage", "Erreur lors de l'inscription.");
                request.getRequestDispatcher("sign_up.jsp").forward(request, response);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur technique : " + e.getMessage());
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        } finally {
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}