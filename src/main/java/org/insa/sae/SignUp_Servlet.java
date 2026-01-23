package org.insa.sae;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SignUp_Servlet")
public class SignUp_Servlet extends HttpServlet {
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    
    try {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String roleStr = request.getParameter("role");
        String username = request.getParameter("username");
        String mdp = digest.digest(request.getParameter("mdp").getBytes(StandardCharsets.UTF_8));;

        
        Role role = switch(roleStr) {
            case "Etudiant" -> Role.student;
            case "Enseignant" -> Role.teacher;
            case "Admin" -> Role.admin;
            default -> Role.student;
        };

        
        User user = new User(0, username, mdp, role, nom, prenom);
        user.save();

      
        response.sendRedirect("login.jsp?success=1");

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Erreur : " + e.getMessage());
        request.getRequestDispatcher("sign_up.jsp").forward(request, response);
    }
}
}