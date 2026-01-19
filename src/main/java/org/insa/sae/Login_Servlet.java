package org.insa.sae;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/LoginServlet")
public class Login_Servlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        
        String u = request.getParameter("username");
        String p = request.getParameter("mdp");
        
        //Appel à la classe BDD   pour test connexion
        boolean estValide = false; 
        String role = ""; 

        // À supprimer
        if ("admin".equals(u) && "1234".equals(p)) {
            estValide = true;
            role = "Admin";
        } else if ("etudiant".equals(u) && "1234".equals(p)) {
            estValide = true;
            role = "Etudiant";
        }
        

        if (estValide) {
            HttpSession session = request.getSession();
            session.setAttribute("user", u); 
            session.setAttribute("role", role);
            switch (role) {
                case "Admin" -> response.sendRedirect("admin_dashboard.jsp");
                case "Etudiant" -> response.sendRedirect("etudiant_dashboard.jsp");
                default -> response.sendRedirect("prof_dashboard.jsp");
            }

        } else {
            request.setAttribute("errorMessage", "Identifiant ou mot de passe incorrect.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}