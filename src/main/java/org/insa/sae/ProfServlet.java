package org.insa.sae;

import java.io.IOException;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/prof")
public class ProfServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        // Sécurité : uniquement enseignants
        if (role == null || !role.equals("Prof")) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            /*
             * ============================
             * Modules du professeur
             * ============================
             */
            // Exemple simulé (à remplacer par DAO)
            List<String> modules = new ArrayList<>();
            modules.add("Java Avancé");
            modules.add("Bases de Données");
            modules.add("Réseaux");

            request.setAttribute("modulesList", modules);

        } catch (Exception e) {
            e.printStackTrace();
        }

        /*
         * ============================
         * Module sélectionné
         * ============================
         */
        String moduleName = request.getParameter("module");
        request.setAttribute("moduleName", moduleName);

        if (moduleName != null && !moduleName.isEmpty()) {

            /*
             * ============================
             * Notes des étudiants
             * ============================
             */
            // Données simulées
            List<String> notesList = new ArrayList<>();
            notesList.add("Dupont Jean:15");
            notesList.add("Martin Alice:17");
            notesList.add("Diallo Amadou:12");

            request.setAttribute("notesList", notesList);

            /*
             * ============================
             * Évaluations
             * ============================
             */
            Map<String, Object> evalData = new HashMap<>();

            evalData.put("oneStar", 1);
            evalData.put("twoStars", 2);
            evalData.put("threeStars", 4);
            evalData.put("fourStars", 6);
            evalData.put("fiveStars", 5);

            int total = 1 + 2 + 4 + 6 + 5;
            double avg = (1 * 1 + 2 * 2 + 3 * 4 + 4 * 6 + 5 * 5) / (double) total;

            evalData.put("totalEvaluations", total);
            evalData.put("averageRating", String.format("%.2f", avg));

            /*
             * ============================
             * Commentaires
             * ============================
             */
            List<Map<String, String>> comments = new ArrayList<>();

            Map<String, String> c1 = new HashMap<>();
            c1.put("studentName", "Alice Martin");
            c1.put("rating", "5");
            c1.put("comment", "Cours très clair et bien expliqué");
            c1.put("date", "2025-01-10");

            Map<String, String> c2 = new HashMap<>();
            c2.put("studentName", "Jean Dupont");
            c2.put("rating", "4");
            c2.put("comment", "Bon contenu mais rythme rapide");
            c2.put("date", "2025-01-11");

            comments.add(c1);
            comments.add(c2);

            evalData.put("comments", comments);

            request.setAttribute("evaluationData", evalData);
        }

        /*
         * ============================
         * Affichage
         * ============================
         */
        request.getRequestDispatcher("WEB-INF/prof_dashboard.jsp")
                .forward(request, response);
    }
}
