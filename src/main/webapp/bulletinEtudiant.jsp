<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/svg+xml" href="assets/logo.svg">
    <title>Bulletin de Notes - ${etudiant.surname} ${etudiant.name}</title>
    <style>
        :root {
            --col-midnight: #090446;
            --col-mint-light: #94E8B4;
            --col-mint-med: #72BDA3;
            --col-forest: #5E8C61;
            --col-white: #ffffff;
        }

        @media print { 
            .no-print { display: none !important; } 
            body { background: white !important; }
            .bulletin { border: none !important; box-shadow: none !important; }
            -webkit-print-color-adjust: exact;
        }

        body { 
            font-family: 'Segoe UI', serif; 
            margin: 0; 
            padding: 20px;
            background-color: #f0f2f5;
        }

        .bulletin { 
            background: white; 
            border: 1px solid #ddd;
            border-top: 10px solid var(--col-midnight);
            border-bottom: 10px solid var(--col-mint-med);
            border-radius: 4px; 
            padding: 40px;
            max-width: 900px; 
            margin: 0 auto; 
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .header { 
            text-align: center;
            border-bottom: 2px solid var(--col-midnight); 
            padding-bottom: 20px; 
            margin-bottom: 30px; 
        }

        .header h1 { 
            color: var(--col-midnight); 
            margin: 0 0 10px 0; 
            font-size: 28px; 
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .info-etudiant { 
            display: grid;
            grid-template-columns: repeat(2, 1fr); 
            gap: 20px; 
            margin-bottom: 30px; 
            background: #fcfcfc; 
            padding: 20px; 
            border: 1px solid #eee;
            border-radius: 8px;
        }

        .info-item { font-size: 15px; }
        .info-item strong { color: var(--col-midnight); margin-right: 10px; }

        .note-rouge { color: #d9534f; font-weight: bold; }
        .note-verte { color: var(--col-forest); font-weight: bold; }

        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin: 30px 0; 
            font-size: 15px; 
        }

        th { 
            background-color: var(--col-midnight); 
            color: white; 
            padding: 12px 10px; 
            text-align: left;
            font-weight: 600; 
            border-bottom: 3px solid var(--col-mint-med);
        }

        td { 
            padding: 12px 10px; 
            border-bottom: 1px solid #eee; 
        }

        tr:nth-child(even) { background-color: #f9f9f9; }

        .moyenne-section { 
            text-align: center; 
            margin: 40px 0; 
            padding: 30px;
            background: linear-gradient(to right, #f8f9fa, #fff, #f8f9fa); 
            border: 1px solid #eee;
            border-radius: 8px; 
        }

        .moyenne-valeur { 
            font-size: 40px; 
            font-weight: bold; 
            color: var(--col-midnight); 
            margin: 15px 0; 
        }

        .moyenne-texte { 
            font-size: 18px; 
            color: #555; 
        }

        .actions { 
            display: flex; 
            justify-content: center; 
            gap: 15px; 
            margin-top: 40px; 
            padding-top: 20px;
            border-top: 1px solid #eee; 
        }

        .btn { 
            padding: 12px 25px; 
            border: none;
            border-radius: 6px; 
            cursor: pointer; 
            font-weight: 600; 
            text-decoration: none; 
            display: inline-block; 
            transition: all 0.3s;
        }

        .btn-primary { background-color: var(--col-midnight); color: white; }
        .btn-primary:hover { background-color: #050225; }
        
        .btn-secondary { background-color: var(--col-mint-med); color: white; }
        .btn-secondary:hover { background-color: var(--col-forest); }

        .footer { 
            text-align: center; 
            margin-top: 40px; 
            color: #888; 
            font-size: 11px;
            font-style: italic;
        }

        .date-gen { 
            float: right; 
            color: #888; 
            font-size: 12px; 
            font-weight: normal;
        }
    </style>
</head>
<body>
    <div class="bulletin">
        <div class="header">
            <h1>Bulletin de Notes</h1>
            <div class="date-gen no-print">
                Généré le : ${dateGeneration}
            </div>
            <div style="color: var(--col-forest); font-weight: bold;">Année Universitaire 2023-2024</div>
        </div>
    
        <div class="info-etudiant">
            <div class="info-item">
                <strong>Nom :</strong> ${etudiant.surname}
            </div>
            <div class="info-item">
                <strong>Prénom :</strong> ${etudiant.name}
            </div>
            <% if (request.getAttribute("ine") != null && !((String)request.getAttribute("ine")).isEmpty()) { %>
                <div class="info-item">
                    <strong>N° INE :</strong> ${ine}
                </div>
            <% } %>
            <div class="info-item">
                <strong>Spécialité :</strong> ${not empty specialite ? specialite : 'Non spécifiée'}
            </div>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th style="width: 40%;">Module</th>
                    <th style="width: 15%;">Note /20</th>
                    <th style="width: 25%;">Enseignant</th>
                    <th style="width: 20%;">Appréciation</th>
                </tr>
            </thead>
            <tbody>
                <% 
                List<Map<String, Object>> notes = (List<Map<String, Object>>) request.getAttribute("notes");
                if (notes == null || notes.isEmpty()) { 
                %>
                    <tr>
                        <td colspan="4" style="text-align: center; padding: 30px; color: #666;">
                            Aucune note enregistrée pour cet étudiant.
                        </td>
                    </tr>
                <% 
                } else { 
                    for (Map<String, Object> note : notes) {
                        String module = (String) note.get("module");
                        float noteValue = (float) note.get("note");
                        String enseignant = (String) note.get("enseignant");
                        
                        String noteClass = noteValue < 10 ? "note-rouge" : "note-verte";
                        
                        String appreciation;
                        if (noteValue >= 16) appreciation = "Excellent";
                        else if (noteValue >= 14) appreciation = "Très bien";
                        else if (noteValue >= 12) appreciation = "Bien";
                        else if (noteValue >= 10) appreciation = "Satisfaisant";
                        else appreciation = "Insuffisant";
                %>
                        <tr>
                            <td><strong><%= module %></strong></td>
                            <td class="<%= noteClass %>">
                                <%= noteValue %>/20
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
        
        <div class="moyenne-section">
            <div class="moyenne-texte">Moyenne Générale</div>
            <div class="moyenne-valeur">${moyenne}/20</div>
            <div class="moyenne-texte">
                <% 
                double moyenne = Double.parseDouble(((String)request.getAttribute("moyenne")).replace(",", "."));
                if (moyenne >= 16) out.print("<span style='color:var(--col-forest)'>🌟 Mention Très Bien</span>");
                else if (moyenne >= 14) out.print("<span style='color:var(--col-mint-med)'>⭐ Mention Bien</span>");
                else if (moyenne >= 12) out.print("<span style='color:#404F40'>✅ Mention Assez Bien</span>");
                else if (moyenne >= 10) out.print("✓ Admis");
                else out.print("<span style='color:#d9534f'>❌ Ajourné</span>");
                %>
            </div>
        </div>
        
        <div class="actions no-print">
            <button class="btn btn-primary" onclick="window.print()">
                🖨️ Imprimer le bulletin
            </button>
            <button class="btn btn-secondary" onclick="window.history.back()">
                ← Retour
            </button>
            <a href="admin_dashboard.jsp" class="btn btn-secondary">
                📊 Tableau de bord
            </a>
        </div>
        
        <div class="footer">
            <p>Université Polytechnique Hauts-de-France</p>
            <p>Ce document est généré informatiquement et ne nécessite pas de signature.</p>
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