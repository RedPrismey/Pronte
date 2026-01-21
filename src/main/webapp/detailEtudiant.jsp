<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Détails Étudiant - ${etudiant.surname} ${etudiant.name}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f8f9fa; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { background: linear-gradient(135deg, #6f42c1 0%, #5a32a3 100%); color: white; padding: 20px; border-radius: 10px; margin-bottom: 30px; }
        .info-section { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 30px; }
        .info-card, .stats-card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .info-row { display: flex; margin-bottom: 10px; }
        .info-label { font-weight: bold; width: 150px; color: #495057; }
        .info-value { color: #212529; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; }
        .stat-item { text-align: center; padding: 15px; border-radius: 5px; }
        .stat-value { font-size: 28px; font-weight: bold; }
        .stat-label { font-size: 12px; color: #6c757d; }
        .note-rouge { color: #dc3545; font-weight: bold; background-color: #f8d7da; padding: 2px 8px; border-radius: 3px; }
        .note-verte { color: #28a745; font-weight: bold; }
        table { width: 100%; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin: 20px 0; }
        th { background-color: #e9ecef; padding: 15px; text-align: left; font-weight: 600; color: #495057; }
        td { padding: 12px 15px; border-bottom: 1px solid #dee2e6; }
        .alert-box { background-color: #fff3cd; border: 1px solid #ffc107; border-radius: 5px; padding: 15px; margin: 20px 0; }
        .btn { padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin-right: 10px; }
        .btn-primary { background-color: #0056b3; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-danger { background-color: #dc3545; color: white; }
        .position-badge { display: inline-block; padding: 5px 15px; background-color: #0056b3; color: white; border-radius: 20px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <!-- En-tête -->
        <div class="header">
            <h1>👨‍🎓 Détails de l'Étudiant</h1>
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h2>${etudiant.surname} ${etudiant.name}</h2>
                    <p>INE: ${inscription.ine} | Spécialité: ${nomSpecialite}</p>
                </div>
                <div class="position-badge">
                    🏆 Position: ${positionClassement}${positionClassement == 1 ? 'er' : 'ème'}
                </div>
            </div>
        </div>
        
        <!-- Informations et statistiques -->
        <div class="info-section">
            <div class="info-card">
                <h3>📋 Informations personnelles</h3>
                <div class="info-row">
                    <div class="info-label">Nom :</div>
                    <div class="info-value">${etudiant.surname}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Prénom :</div>
                    <div class="info-value">${etudiant.name}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">INE :</div>
                    <div class="info-value">${inscription.ine != null ? inscription.ine : 'Non renseigné'}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Spécialité :</div>
                    <div class="info-value">${nomSpecialite}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Rôle :</div>
                    <div class="info-value">Étudiant</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Date d'inscription :</div>
                    <div class="info-value">À compléter</div>
                </div>
            </div>
            
            <div class="stats-card">
                <h3>📊 Statistiques académiques</h3>
                <div class="stats-grid">
                    <div class="stat-item" style="background-color: #e7f1ff;">
                        <div class="stat-value">${stats.moyenneGenerale}/20</div>
                        <div class="stat-label">Moyenne générale</div>
                    </div>
                    <div class="stat-item" style="background-color: #d4edda;">
                        <div class="stat-value">${stats.nbNotes}</div>
                        <div class="stat-label">Notes enregistrées</div>
                    </div>
                    <div class="stat-item" style="background-color: #fff3cd;">
                        <div class="stat-value">${stats.meilleureNote}/20</div>
                        <div class="stat-label">Meilleure note</div>
                    </div>
                    <div class="stat-item" style="background-color: #f8d7da;">
                        <div class="stat-value">${stats.nbNotesProblematiques}</div>
                        <div class="stat-label">Notes < 10</div>
                    </div>
                </div>
                <div style="margin-top: 15px;">
                    <div class="info-row">
                        <div class="info-label">Mention :</div>
                        <div class="info-value">
                            <span style="font-weight: bold; color: 
                                <% 
                                String mention = (String)((Map)request.getAttribute("stats")).get("mention");
                                if ("Très Bien".equals(mention)) out.print("#28a745");
                                else if ("Bien".equals(mention)) out.print("#17a2b8");
                                else if ("Assez Bien".equals(mention)) out.print("#ffc107");
                                else if ("Passable".equals(mention)) out.print("#fd7e14");
                                else out.print("#dc3545");
                                %>">
                                ${stats.mention}
                            </span>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Taux de réussite :</div>
                        <div class="info-value">${stats.pourcentageReussite}%</div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Alertes pour les modules en difficulté -->
        <% 
        List<Map<String, Object>> modulesDifficulte = (List<Map<String, Object>>) request.getAttribute("modulesDifficulte");
        if (modulesDifficulte != null && !modulesDifficulte.isEmpty()) { 
        %>
        <div class="alert-box">
            <h3>⚠️ Attention - Modules en difficulté</h3>
            <p>Cet étudiant a des notes inférieures à 10 dans les modules suivants :</p>
            <ul>
                <% for (Map<String, Object> module : modulesDifficulte) { %>
                <li>
                    <strong><%= module.get("moduleNom") %></strong> : 
                    <%= module.get("note") %>/20 
                    <% if (module.get("enseignant") != null) { %>
                    (Enseignant: <%= module.get("enseignant") %>)
                    <% } %>
                </li>
                <% } %>
            </ul>
            <p><strong>Suggestion :</strong> Proposer des séances de rattrapage ou un tutorat.</p>
        </div>
        <% } %>
        
        <!-- Tableau des notes détaillées -->
        <h3>📝 Notes détaillées par module</h3>
        <table>
            <thead>
                <tr>
                    <th>Module</th>
                    <th>Note /20</th>
                    <th>Coefficient</th>
                    <th>Type</th>
                    <th>Enseignant</th>
                    <th>Appréciation</th>
                </tr>
            </thead>
            <tbody>
                <% 
                List<Map<String, Object>> notes = (List<Map<String, Object>>) request.getAttribute("notes");
                if (notes != null && !notes.isEmpty()) {
                    for (Map<String, Object> note : notes) {
                        String moduleNom = (String) note.get("moduleNom");
                        int valeur = (int) note.get("valeur");
                        double coefficient = (double) note.get("coefficient");
                        String type = (String) note.get("type");
                        String enseignant = (String) note.get("enseignantNom");
                        boolean problematique = (boolean) note.get("problematique");
                        
                        String appreciation;
                        if (valeur >= 16) appreciation = "Excellent";
                        else if (valeur >= 14) appreciation = "Très bien";
                        else if (valeur >= 12) appreciation = "Bien";
                        else if (valeur >= 10) appreciation = "Satisfaisant";
                        else appreciation = "Insuffisant";
                %>
                <tr>
                    <td><%= moduleNom %></td>
                    <td class="<%= problematique ? "note-rouge" : "note-verte" %>">
                        <%= valeur %>/20
                        <% if (problematique) { %>
                        <span style="font-size: 10px;">⚠</span>
                        <% } %>
                    </td>
                    <td><%= coefficient %></td>
                    <td><%= type %></td>
                    <td><%= enseignant != null ? enseignant : "-" %></td>
                    <td><%= appreciation %></td>
                </tr>
                <% 
                    }
                } else { 
                %>
                <tr>
                    <td colspan="6" style="text-align: center; padding: 30px; color: #6c757d;">
                        Aucune note enregistrée pour cet étudiant.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <!-- Actions -->
        <div style="margin-top: 30px; text-align: center;">
            <a href="GenererBulletinServlet?id=${etudiant.id}" class="btn btn-primary" target="_blank">
                📄 Générer le bulletin
            </a>
            <a href="adminDashboard.jsp" class="btn btn-secondary">
                ← Retour au dashboard
            </a>
            <a href="StatsServlet?type=classement" class="btn" style="background-color: #28a745; color: white;">
                🏆 Voir le classement
            </a>
        </div>
    </div>
    
    <script>
        // Script pour exporter les données (optionnel)
        function exporterDonnees() {
            const data = {
                etudiant: "${etudiant.surname} ${etudiant.name}",
                ine: "${inscription.ine}",
                moyenne: "${stats.moyenneGenerale}",
                notes: <%= notes != null ? notes.size() : 0 %>
            };
            
            const dataStr = JSON.stringify(data, null, 2);
            const dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);
            const exportFileDefaultName = 'etudiant_${etudiant.surname}_${etudiant.name}.json';
            
            const linkElement = document.createElement('a');
            linkElement.setAttribute('href', dataUri);
            linkElement.setAttribute('download', exportFileDefaultName);
            linkElement.click();
        }
    </script>
</body>
</html>
