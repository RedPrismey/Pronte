package org.insa.sae;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet pour la gestion de l'espace étudiant.
 * Permet à l'étudiant de :
 * 1. Consulter ses notes par module.
 * 2. Évaluer les modules suivis (critères multiples + commentaire).
 */
@WebServlet("/etudiant")
public class EtudiantServlet extends HttpServlet {

    // Informations de connexion à la base de données
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pronte?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    /**
     * Méthode appelée lors d'une requête GET (accès à la page).
     * Elle charge les notes de l'étudiant pour les afficher sur le dashboard.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Vérification de la session utilisateur
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("user");

        // Si l'utilisateur n'est pas connecté, redirection vers la page de login
        if (username == null) {
            request.setAttribute("errorMessage", "Veuillez vous connecter pour accéder à cette page.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 2. Connexion à la base de données pour récupérer l'ID de l'étudiant et ses
        // notes
        Integer studentId = null;
        Map<String, String> notesAndModules = new HashMap<>();

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

            // Étape A : Récupérer l'ID de l'utilisateur à partir de son username
            String getIdSql = "SELECT id FROM users WHERE username = ?";
            try (PreparedStatement ps = conn.prepareStatement(getIdSql)) {
                ps.setString(1, username);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        studentId = rs.getInt("id");
                    }
                }
            }

            // Si l'étudiant est trouvé, on récupère ses notes
            if (studentId != null) {
                // Étape B : Requête pour récupérer les modules et les notes associées
                // On joint la table 'notes' avec la table 'module'
                String getNotesSql = "SELECT m.name AS moduleName, n.note " +
                        "FROM notes n " +
                        "JOIN module m ON n.id_module = m.id " +
                        "WHERE n.id_student = ?";

                try (PreparedStatement ps = conn.prepareStatement(getNotesSql)) {
                    ps.setInt(1, studentId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            // On stocke chaque couple (Module, Note) dans une Map
                            // Note : On convertit la note (int) en String pour l'affichage
                            notesAndModules.put(rs.getString("moduleName"), String.valueOf(rs.getInt("note")));
                        }
                    }
                }
            }

        } catch (SQLException e) {
            // En cas d'erreur technique (ex: BDD éteinte), on affiche un message
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur technique lors du chargement des données : " + e.getMessage());
        }

        // 3. Transmission des données à la vue (JSP)
        request.setAttribute("notesBySemester", notesAndModules);

        // Affichage de la page JSP
        request.getRequestDispatcher("etudiant_dashboard.jsp").forward(request, response);
    }

    /**
     * Méthode appelée lors d'une requête POST (soumission de formulaire).
     * Gère principalement l'enregistrement des évaluations de modules.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // On force l'encodage UTF-8 pour gérer correctement les accents des
        // commentaires
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // Identification de l'étudiant (nécessaire pour enregistrer l'évaluation à son
        // nom)
        String username = (String) request.getSession().getAttribute("user");
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Si l'action est "eval", on traite l'évaluation
        if ("eval".equals(action)) {
            handleEvaluationSubmission(request, username);
        }

        // Après le traitement, on recharge la page (comportement identique au doGet)
        // pour afficher les résultats mis à jour
        doGet(request, response);
    }

    /**
     * Logique métier pour enregistrer une évaluation dans la base de données.
     */
    private void handleEvaluationSubmission(HttpServletRequest request, String username) {
        String moduleName = request.getParameter("module");
        String comment = request.getParameter("comment");

        // Récupération des 3 critères notés de 1 à 5
        int supports = Integer.parseInt(request.getParameter("supports"));
        int equipe = Integer.parseInt(request.getParameter("equipe"));
        int temps = Integer.parseInt(request.getParameter("temps"));

        // Calcul d'une moyenne simple arrondie pour la note globale (stockée en entier
        // dans la BDD actuelle)
        int globalRating = Math.round((supports + equipe + temps) / 3.0f);

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

            // 1. Récupérer l'ID de l'étudiant
            int studentId = -1;
            try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM users WHERE username = ?")) {
                ps.setString(1, username);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next())
                        studentId = rs.getInt("id");
                }
            }

            // 2. Récupérer l'ID du module
            int moduleId = -1;
            try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM module WHERE name = ?")) {
                ps.setString(1, moduleName);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next())
                        moduleId = rs.getInt("id");
                }
            }

            // 3. Insérer l'évaluation si tout est valide
            if (studentId != -1 && moduleId != -1) {
                String insertSql = "INSERT INTO evaluations (id_module, id_student, rating, comment, created_at) VALUES (?, ?, ?, ?, NOW())";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, moduleId);
                    ps.setInt(2, studentId);
                    ps.setInt(3, globalRating); // On stocke la moyenne calculée
                    ps.setString(4, comment);
                    ps.executeUpdate();
                }
                // Message de succès pour l'utilisateur
                request.setAttribute("evalMessage",
                        "Merci ! Votre évaluation pour le module " + moduleName + " a bien été enregistrée.");
            } else {
                request.setAttribute("errorMessage", "Erreur : Module ou étudiant introuvable.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de l'enregistrement de l'évaluation : " + e.getMessage());
        }
    }
}
