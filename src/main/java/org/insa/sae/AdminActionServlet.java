package org.insa.sae;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Models (Active Record) à créer
// import com.projet.model.Etudiant;
// import com.projet.model.Note;

@WebServlet("/AdminActionServlet")
public class AdminActionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");

        try {
            if ("createEtudiant".equals(action)) {
                String nom = request.getParameter("nom");
                String prenom = request.getParameter("prenom");
                String ine = request.getParameter("ine");
                String spe = request.getParameter("specialite");
                
                
                // Etudiant etu = new Etudiant();
                // etu.setNom(nom); etu.setPrenom(prenom); 
                // etu.save(); // Enregistre en BDD
                
                request.setAttribute("message", "Étudiant " + nom + " inscrit avec succès !");

            } else if ("addNote".equals(action)) {
                int idEtudiant = Integer.parseInt(request.getParameter("idEtudiant"));
                int idModule = Integer.parseInt(request.getParameter("idModule"));
                float valeur = Float.parseFloat(request.getParameter("valeur"));
                String type = request.getParameter("typeNote");
            
                // Note n = new Note();
                // n.setEtudiantId(idEtudiant); ...
                // n.save();

                request.setAttribute("message", "Note enregistrée !");
            }

        } catch (Exception e) {
            request.setAttribute("message", "Erreur : " + e.getMessage());
        }
        request.getRequestDispatcher("WEB-INF/admin_dashboard.jsp").forward(request, response);
    }
}
