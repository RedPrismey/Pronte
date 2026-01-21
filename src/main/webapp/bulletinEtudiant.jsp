<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bulletin de Notes - ${etudiant.surname} ${etudiant.name}</title>
    <style>
        @media print { .no-print { display: none !important; } }
        body { font-family: 'Segoe UI', sans-serif; margin: 20px; background-color: #f5f5f5; }
        .bulletin { background: white; border: 2px solid #0056b3; border-radius: 10px; padding: 30px; max-width: 900px; margin: 0 auto; }
        .header { text-align: center; border-bottom: 2px solid #0056b3; padding-bottom: 20px; margin-bottom: 30px; }
        .header h1 { color: #0056b3; margin: 0 0 10px 0; font-size: 24px; }
        .info-etudiant { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 20px; background: #f8f9fa; padding: 15px; border-radius: 5px; }
        .info-item { margin: 5px 0; }
        .info-item strong { color: #0056b3; }
        .note-rouge { color: #dc3545; font-weight: bold; }
        .note-verte { color: #28a745; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin: 25px 0; font-size: 14px; }
        th { background-color: #0056b3; color: white; padding: 12px 8px; text-align: left; font-weight: 600; }
        td { padding: 10px 8px; border-bottom: 1px solid #dee2e6; }
        tr:hover { background-color: #f8f9fa; }
        .moyenne-section { text-align: center; margin: 30px 0; padding: 20px; background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border-radius: 8px; border-left: 5px solid #0056b3; }
        .moyenne-valeur { font-size: 32px; font-weight: bold; color: #0056b3; margin: 10px 0; }
        .moyenne-texte { font-size: 18px; color: #495057; }
        .actions { display: flex; justify-content: center; gap: 15px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #dee2e6; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: 600; text-decoration: none; display: inline-block; transition: all 0.3s; }
        .btn-primary { background-color: #0056b3; color: white; }
        .btn-primary:hover { background-color: #004494; transform: translateY(-2px); }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-secondary:hover { background-color: #5a6268; }
        .footer { text-align: center; margin-top: 20px; color: #6c757d; font-size: 12px; }
        .date-gen { float: right; color: #6c757d; font-size: 12px; }
    </style>
</head>
<body>
    <div class="bulletin">
        <!-- En-tête -->
        <div class="header">
            <h1>📘 Bulletin de Notes</h1>
            <div class="date-gen no-print">
                Généré le : ${dateGeneration}
            </div>
        </div>
        
        <!-- Informations étudiant -->
        <div class="info-etudiant">
            <div class="info-item">
                <strong>Nom :</strong> ${etudiant.surname}
            </div>
            <div class="info-item">
                <strong>Prénom :</strong> ${etudiant.name}
            </div>
            <% if (request.getAttribute("ine") != null && !((String)request.getAttribute("ine")).isEmpty()) { %>
                <div class="info-item">
                    <strong>INE :</strong> ${ine}
                </div>
            <% } %>
            <div class="info-item">
                <strong>Spécialité :</strong> ${not empty specialite ? specialite : 'Non spécifiée'}
            </div>
        </div>
        
        <!-- Tableau des notes -->
        <table>
            <thead>
                <tr>
                    <th>Module</th>
                    <th>Note /20</th>
                    <th>Enseignant</th>
                    <th>Appréciation</th>
                </tr>
            </thead>
            <tbody>
                <% 
                List<Map<String, Object>> notes = (List<Map<String, Object>>) request.getAttribute("notes");
                if (notes == null || notes.isEmpty()) { 
                %>
                    <tr>
                        <td colspan="4" style="text-align: center; color: #6c757d;">
                            Aucune note enregistrée pour cet étudiant.
                        </td>
                    </tr>
                <% 
                } else { 
                    for (Map<String, Object> note : notes) {
                        String module = (String) note.get("module");
                        int noteValue = (int) note.get("note");
                        String enseignant = (String) note.get("enseignant");
                        
                        // Déterminer la classe CSS
                        String noteClass = noteValue < 10 ? "note-rouge" : "note-verte";
                        
                        // Déterminer l'appréciation
                        String appreciation;
                        if (noteValue >= 16) appreciation = "Excellent";
                        else if (noteValue >= 14) appreciation = "Très bien";
                        else if (noteValue >= 12) appreciation = "Bien";
                        else if (noteValue >= 10) appreciation = "Satisfaisant";
                        else appreciation = "Insuffisant";
                %>
                        <tr>
                            <td><%= module %></td>
                            <td class="<%= noteClass %>">
                                <%= noteValue %>/20
                                <% if (noteValue < 10) { %>
                                    <span style="font-size: 10px; color: #dc3545;">⚠</span>
                                <% } %>
                            </td>
                            <td><%= enseignant != null ? enseignant : "-" %></td>
                            <td><%= appreciation %></td>
                        </tr>
                <% 
                    }
                } 
                %>
            </tbody>
        </table>
        
        <!-- Section moyenne -->
        <div class="moyenne-section">
            <div class="moyenne-texte">Moyenne Générale</div>
            <div class="moyenne-valeur">${moyenne}/20</div>
            <div class="moyenne-texte">
                <% 
                double moyenne = Double.parseDouble(((String)request.getAttribute("moyenne")).replace(",", "."));
                if (moyenne >= 16) out.print("🌟 Mention Très Bien");
                else if (moyenne >= 14) out.print("⭐ Mention Bien");
                else if (moyenne >= 12) out.print("✅ Mention Assez Bien");
                else if (moyenne >= 10) out.print("✓ Admis");
                else out.print("❌ Non admis");
                %>
            </div>
        </div>
        
        <!-- Boutons d'action -->
        <div class="actions no-print">
            <button class="btn btn-primary" onclick="window.print()">
                🖨️ Imprimer le bulletin
            </button>
            <button class="btn btn-secondary" onclick="window.history.back()">
                ← Retour
            </button>
            <a href="adminDashboard.jsp" class="btn btn-secondary">
                📊 Tableau de bord
            </a>
        </div>
        
        <!-- Pied de page -->
        <div class="footer">
            <p>Établissement : Université Polytechnique Hauts-de-France</p>
            <p>Service de Scolarité - Système de Gestion des Notes</p>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            window.addEventListener('beforeprint', function() {
                document.title = "Bulletin_${etudiant.surname}_${etudiant.name}";
            });
            
            window.addEventListener('afterprint', function() {
                document.title = "Bulletin de Notes - ${etudiant.surname} ${etudiant.name}";
            });
        });
    </script>
</body>
</html>
