<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/svg+xml" href="assets/logo.svg">
    <title>Détails Étudiant - ${etudiant.surname} ${etudiant.name}</title>
    <style>
        :root {
            --col-midnight: #090446;
            --col-mint-light: #94E8B4;
            --col-mint-med: #72BDA3;
            --col-forest: #5E8C61;
            --col-olive: #404F40;
            --col-bg: #f4f7f6;
            --col-white: #ffffff;
            --col-danger: #d9534f;
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; 
            padding: 40px 20px;
            background-color: var(--col-bg); 
            color: #333;
        }

        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
        }

        /* HEADER */
        .header { 
            background: linear-gradient(135deg, var(--col-midnight) 0%, #1a1555 100%); 
            color: white; 
            padding: 30px; 
            border-radius: 12px; 
            margin-bottom: 30px; 
            box-shadow: 0 4px 15px rgba(9, 4, 70, 0.2);
        }
        
        .header h1 { margin: 0 0 10px 0; font-size: 1.2em; opacity: 0.8; font-weight: normal; }
        .header h2 { margin: 0; font-size: 2em; }
        .header p { margin: 5px 0 0 0; opacity: 0.9; color: var(--col-mint-light); }

        .position-badge { 
            display: inline-block; 
            padding: 10px 20px; 
            background-color: var(--col-forest); 
            color: white; 
            border-radius: 50px; 
            font-weight: bold; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        /* GRIDS & CARDS */
        .info-section { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 30px; 
            margin-bottom: 30px; 
        }

        @media (max-width: 768px) {
            .info-section { grid-template-columns: 1fr; }
        }

        .info-card, .stats-card { 
            background: var(--col-white); 
            padding: 25px; 
            border-radius: 12px; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.05); 
            border-top: 4px solid var(--col-mint-med);
        }

        h3 { 
            color: var(--col-midnight); 
            margin-top: 0; 
            border-bottom: 1px solid #eee; 
            padding-bottom: 15px; 
            margin-bottom: 20px;
        }

        .info-row { display: flex; margin-bottom: 12px; border-bottom: 1px solid #f9f9f9; padding-bottom: 8px; }
        .info-label { font-weight: 600; width: 140px; color: var(--col-olive); }
        .info-value { color: #333; flex: 1; }

        /* STATS GRID */
        .stats-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); 
            gap: 15px; 
        }

        .stat-item { 
            text-align: center; 
            padding: 15px; 
            border-radius: 8px; 
            transition: transform 0.2s;
        }
        
        .stat-item:hover { transform: translateY(-2px); }

        .stat-value { font-size: 24px; font-weight: 800; color: var(--col-midnight); }
        .stat-label { font-size: 13px; color: var(--col-olive); margin-top: 5px; font-weight: 600; }

        /* Custom backgrounds for stats */
        .bg-mint-light { background-color: rgba(148, 232, 180, 0.3); }
        .bg-mint-med { background-color: rgba(114, 189, 163, 0.2); }
        .bg-blue-light { background-color: #eef2f5; }
        .bg-danger-light { background-color: #fff0f0; }

        /* TABLE */
        table { 
            width: 100%; 
            background: white; 
            border-radius: 12px; 
            overflow: hidden; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.05); 
            margin: 20px 0; 
            border-collapse: collapse;
        }

        th { 
            background-color: var(--col-midnight); 
            padding: 15px; 
            text-align: left; 
            font-weight: 600; 
            color: white; 
            font-size: 14px;
        }

        td { 
            padding: 12px 15px; 
            border-bottom: 1px solid #eee; 
            color: #444;
        }
        
        tr:last-child td { border-bottom: none; }
        tr:hover td { background-color: #fcfcfc; }

        /* NOTES STYLES */
        .note-rouge { color: var(--col-danger); font-weight: bold; background-color: #fff0f0; padding: 2px 6px; border-radius: 4px; }
        .note-verte { color: var(--col-forest); font-weight: bold; }

        /* ALERT BOX */
        .alert-box { 
            background-color: #fff9e6; 
            border-left: 5px solid #ffc107; 
            border-radius: 6px; 
            padding: 20px; 
            margin: 20px 0; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        /* BUTTONS */
        .btn { 
            padding: 12px 24px; 
            text-decoration: none; 
            border-radius: 6px; 
            display: inline-block; 
            margin-right: 10px; 
            font-weight: 600; 
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }

        .btn-primary { 
            background-color: var(--col-midnight); 
            color: white; 
        }
        .btn-primary:hover { background-color: var(--col-olive); }

        .btn-secondary { 
            background-color: var(--col-mint-med); 
            color: white; 
        }
        .btn-secondary:hover { background-color: var(--col-forest); }

    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>👨‍🎓 Détails de l'Étudiant</h1>
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h2>${etudiant.surname} ${etudiant.name}</h2>
                    <p>INE: ${inscription.ine} | Spécialité: ${nomSpecialite}</p>
                </div>
                <div class="position-badge">
                    🏆 Position: ${positionClassement}${positionClassement == 1 ? 'er' : 'ème'}
                </div>
            </div>
        </div>
        
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
            </div>
            
            <div class="stats-card">
                <h3>📊 Statistiques académiques</h3>
                <div class="stats-grid">
                    <div class="stat-item bg-blue-light">
                        <div class="stat-value">${stats.moyenneGenerale}/20</div>
                        <div class="stat-label">Moyenne générale</div>
                    </div>
                    <div class="stat-item bg-mint-light">
                        <div class="stat-value">${stats.nbNotes}</div>
                        <div class="stat-label">Notes enregistrées</div>
                    </div>
                    <div class="stat-item bg-mint-med">
                        <div class="stat-value">${stats.meilleureNote}/20</div>
                        <div class="stat-label">Meilleure note</div>
                    </div>
                    <div class="stat-item bg-danger-light">
                        <div class="stat-value" style="color:var(--col-danger);">${stats.nbNotesProblematiques}</div>
                        <div class="stat-label">Notes < 10</div>
                    </div>
                </div>
                <div style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;">
                    <div class="info-row">
                        <div class="info-label">Mention :</div>
                        <div class="info-value">
                            <span style="font-weight: bold; font-size: 1.1em; color: 
                                <% 
                                String mention = (String)((Map)request.getAttribute("stats")).get("mention");
                                if ("Très Bien".equals(mention)) out.print("#5E8C61"); // Forest Green
                                else if ("Bien".equals(mention)) out.print("#72BDA3"); // Mint Med
                                else if ("Assez Bien".equals(mention)) out.print("#404F40"); // Olive
                                else if ("Passable".equals(mention)) out.print("#d39e00");
                                else out.print("#d9534f");
                                %>">
                                ${stats.mention}
                            </span>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Taux de réussite :</div>
                        <div class="info-value" style="font-weight:bold;">${stats.pourcentageReussite}%</div>
                    </div>
                </div>
            </div>
        </div>
        
        <% 
        List<Map<String, Object>> modulesDifficulte = (List<Map<String, Object>>) request.getAttribute("modulesDifficulte");
        if (modulesDifficulte != null && !modulesDifficulte.isEmpty()) { 
        %>
        <div class="alert-box">
            <h3 style="background:none; border:none; margin:0 0 10px 0; color: #856404;">⚠️ Attention - Modules en difficulté</h3>
            <p style="margin:0 0 10px 0;">Cet étudiant a des notes inférieures à 10 dans les modules suivants :</p>
            <ul style="margin:0; padding-left: 20px;">
                <% for (Map<String, Object> module : modulesDifficulte) { %>
                <li style="margin-bottom: 5px;">
                    <strong><%= module.get("moduleNom") %></strong> : 
                    <span style="color:var(--col-danger); font-weight:bold;"><%= module.get("note") %>/20</span>
                    <% if (module.get("enseignant") != null) { %>
                    <span style="font-size:0.9em; color:#666;">(Enseignant: <%= module.get("enseignant") %>)</span>
                    <% } %>
                </li>
                <% } %>
            </ul>
        </div>
        <% } %>
        
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
                        float valeur = (float) note.get("valeur");
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
                    <td><strong><%= moduleNom %></strong></td>
                    <td class="<%= problematique ? "note-rouge" : "note-verte" %>">
                        <%= valeur %>/20
                        <% if (problematique) { %>
                        <span style="font-size: 10px;">⚠</span>
                        <% } %>
                    </td>
                    <td><%= coefficient %></td>
                    <td><span style="background:#eee; padding:2px 6px; border-radius:4px; font-size:0.9em;"><%= type %></span></td>
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
        
        <div style="margin-top: 30px; text-align: center;">
            <a href="GenererBulletinServlet?id=${etudiant.id}" class="btn btn-primary" target="_blank">
                📄 Générer le bulletin
            </a>
            <a href="${dashboardLink}" class="btn btn-secondary">
                ← Retour au dashboard
            </a>
            <button onclick="exporterDonnees()" class="btn" style="background-color:var(--col-olive); color:white;">
                💾 Exporter JSON
            </button>
        </div>
    </div>
    
    <script>
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