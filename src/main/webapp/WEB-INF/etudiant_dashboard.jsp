<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.insa.sae.*" %> 

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/svg+xml" href="assets/logo.svg">
    <title>Espace Étudiant</title>
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
            --col-success: #5E8C61;
        }

        * { box-sizing: border-box; }
        
        html { scroll-behavior: smooth; }
        
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; 
            background-color: var(--col-bg);
            color: #333;
        }

        .sidebar { 
            width: 260px; 
            background: var(--col-midnight); 
            color: white; 
            height: 100vh; 
            padding: 25px; 
            position: fixed; 
            top: 0; left: 0;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 4px 0 10px rgba(9, 4, 70, 0.1);
        }

        .sidebar h3 {
            color: var(--col-mint-light);
            text-align: center;
            margin-bottom: 5px;
        }

        .sidebar p {
            color: var(--col-mint-med);
            text-align: center;
            font-size: 0.9em;
            margin-top: 0;
            margin-bottom: 30px;
        }

        .sidebar hr {
            border: 0;
            border-top: 1px solid var(--col-olive);
            opacity: 0.5;
            margin: 20px 0;
        }

        .sidebar a { 
            display: block; 
            color: white; 
            padding: 12px 15px; 
            text-decoration: none; 
            margin-bottom: 8px; 
            border-radius: 6px; 
            transition: all 0.3s ease;
            font-size: 14px;
        }
        
        .sidebar a:hover { 
            background: var(--col-forest); 
            padding-left: 20px;
        }

        .content { 
            margin-left: 260px; 
            padding: 40px; 
            min-height: 100vh;
        }

        .card { 
            background: var(--col-white); 
            padding: 30px; 
            margin-bottom: 30px; 
            border-radius: 12px; 
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05); 
            border-left: 5px solid var(--col-mint-med);
            scroll-margin-top: 20px;
        }

        h2 { 
            color: var(--col-midnight); 
            border-bottom: 2px solid var(--col-mint-light); 
            padding-bottom: 15px; 
            margin-top: 0;
            font-weight: 700;
        }

        .form-row { 
            display: flex; 
            gap: 15px; 
            margin-bottom: 15px; 
            flex-wrap: wrap;
        }

        select, input, textarea { 
            padding: 12px; 
            width: 100%; 
            border: 1px solid #ddd; 
            border-radius: 6px; 
            box-sizing: border-box;
            background-color: #fcfcfc;
            font-family: inherit;
        }

        select:focus, input:focus, textarea:focus {
            outline: none;
            border-color: var(--col-mint-med);
        }

        button { 
            padding: 12px 24px; 
            background: var(--col-forest); 
            color: white; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-weight: 600;
            transition: background 0.3s;
        }

        button:hover { background: var(--col-olive); }

        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px; 
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }

        th, td { 
            padding: 15px; 
            text-align: left; 
            border-bottom: 1px solid #eee; 
        }

        th { 
            background-color: var(--col-midnight); 
            color: white; 
            font-weight: 600;
        }

        .alert { 
            color: var(--col-olive); 
            background-color: var(--col-mint-light); 
            border-left: 5px solid var(--col-forest); 
            padding: 15px; 
            margin-bottom: 25px; 
            border-radius: 6px;
            font-weight: bold;
        }

        .note-bad { color: var(--col-danger); font-weight: bold; }
        .note-good { color: var(--col-success); font-weight: bold; }
    </style>
</head>

<body>

    <div class="sidebar">
        <div style="text-align: center; margin-bottom: 30px;">
            <img src="assets/logo.svg" alt="Logo" width="80" height="80" style="filter: brightness(0) invert(1);">
        </div>
        <h3>Espace Étudiant</h3>
        <p>
            Bienvenue, 
            <%= ((User)request.getAttribute("etudiant")).getName() %> 
            <%= ((User)request.getAttribute("etudiant")).getSurname() %>
        </p>
        <hr>
        <a href="#mes_notes">📘 Mes notes</a>
        
        <a href="DetailEtudiantServlet?id=<%= ((User)request.getAttribute("etudiant")).getId() %>">
            🔍 Mon Dossier Détaillé
        </a>
        
        <a href="#evaluer_module">📝 Évaluer un module</a>
        <hr>
        <a href="LogoutServlet">Déconnexion</a>
    </div>

    <div class="content">

        <% if (request.getAttribute("message") != null) { %>
            <div class="alert">
                <%= request.getAttribute("message") %>
            </div>
        <% } %>

        <div id="mes_notes" class="card">
            <h2>Aperçu de mes notes</h2>
            
            <% 
            List<Map<String, Object>> mesNotes = (List<Map<String, Object>>) request.getAttribute("mesNotes");
            if (mesNotes != null && !mesNotes.isEmpty()) { 
            %>
                <table>
                    <thead>
                        <tr>
                            <th>Module</th>
                            <th>Type</th>
                            <th>Note</th>
                            <th>Coef</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> note : mesNotes) { 
                            float val = (float) note.get("note");
                            String cssClass = (val < 10) ? "note-bad" : "note-good";
                        %>
                            <tr>
                                <td><strong><%= note.get("module") %></strong></td>
                                <td><span style="background:#eee; padding:2px 6px; border-radius:4px; font-size:0.9em;"><%= note.get("type") %></span></td>
                                <td class="<%= cssClass %>"><%= val %> / 20</td>
                                <td><%= note.get("coef") %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p style="text-align:center; color:#666; padding:20px;">Aucune note enregistrée pour le moment.</p>
            <% } %>
        </div>

        <div id="evaluer_module" class="card">
            <h2>Évaluer un module</h2>

            <form method="post" action="etudiant">
                <input type="hidden" name="action" value="evaluerModule">

                <div class="form-row">
                    <select name="module" required>
                        <option value="">-- Sélectionner un module --</option>
                        <% 
                        List<ModuleEntity> listeModules = (List<ModuleEntity>) request.getAttribute("listeModules");
                        if (listeModules != null) {
                            for(ModuleEntity m : listeModules) {
                        %>
                            <option value="<%= m.getId() %>"><%= m.getName() %></option>
                        <% 
                            }
                        } 
                        %>
                    </select>
                </div>

                <div class="form-row">
                    <input type="number" name="supports" min="1" max="5" placeholder="Qualité des supports (1-5)" required>
                    <input type="number" name="equipe" min="1" max="5" placeholder="Équipe pédagogique (1-5)" required>
                    <input type="number" name="charge" min="1" max="5" placeholder="Charge de travail (1-5)" required>
                </div>

                <div class="form-row">
                    <textarea name="commentaire" placeholder="Votre avis (optionnel)" rows="3"></textarea>
                </div>

                <button type="submit">Envoyer l’évaluation</button>
            </form>
        </div>

    </div>

</body>
</html>