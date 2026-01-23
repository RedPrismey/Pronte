<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.insa.sae.*" %> 

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/svg+xml" href="assets/logo.svg">
    <title>Dashboard Enseignant</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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

        .sidebar h3 { color: var(--col-mint-light); text-align: center; margin-bottom: 5px; }
        .sidebar p { color: var(--col-mint-med); text-align: center; font-size: 0.9em; margin-bottom: 30px; }

        .sidebar hr { border: 0; border-top: 1px solid var(--col-olive); opacity: 0.5; margin: 20px 0; }

        .sidebar a {
            display: block;
            color: white;
            padding: 12px 15px;
            text-decoration: none;
            margin-bottom: 8px;
            border-radius: 6px;
            transition: 0.3s;
            font-size: 14px;
        }

        .sidebar a:hover { background: var(--col-forest); padding-left: 20px; }

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
        }

        .form-row { display: flex; gap: 15px; margin-bottom: 15px; }

        select { 
            padding: 12px; 
            border: 1px solid #ddd; 
            border-radius: 6px; 
            flex: 1; 
            background: #fcfcfc;
        }
        
        button {
            padding: 12px 24px;
            background: var(--col-forest);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        button:hover { background: var(--col-olive); }

        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; border-radius: 8px; overflow: hidden; }

        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }

        th { background-color: var(--col-midnight); color: white; font-weight: 600; }
        
        tr:hover td { background-color: #fcfcfc; }
    </style>
</head>

<body>

    <div class="sidebar">
        <div style="text-align: center; margin-bottom: 30px;">
            <img src="assets/logo.svg" alt="Logo" width="80" height="80" style="filter: brightness(0) invert(1);">
        </div>
        <h3>Enseignant</h3>
        <p>
            Bienvenue, 
            <%= ((User)request.getAttribute("prof")).getName() %> 
            <%= ((User)request.getAttribute("prof")).getSurname() %>
        </p>
        <hr>
        <a href="#mes_modules">Mes modules</a>
        <a href="#notes_module">Notes</a>
        <a href="#evaluations_etudiants">Évaluations</a>
        <hr>
        <a href="LogoutServlet">Déconnexion</a>
    </div>

    <div class="content">
        <% 
        List<ModuleEntity> modules = (List<ModuleEntity>) request.getAttribute("modulesList");
        List<String> notes = (List<String>) request.getAttribute("notesList");
        Map<String,Object> evalData = (Map<String,Object>) request.getAttribute("evaluationData");
        Integer selectedModuleId = (Integer) request.getAttribute("selectedModuleId");
        %>
    
        <div id="mes_modules" class="card">
            <h2>Mes modules</h2>
            <form action="prof" method="get">
                <div class="form-row">
                    <select name="module" onchange="this.form.submit()" required>
                        <option value="">-- Sélectionner un module --</option>
                        <% if (modules != null) { 
                            for(ModuleEntity m : modules) { 
                                String selected = (selectedModuleId != null && m.getId() == selectedModuleId) ? "selected" : "";
                        %>
                            <option value="<%= m.getId() %>" <%= selected %>>
                                <%= m.getName() %>
                            </option>
                        <%  } 
                           } %>
                    </select>
                    <button type="submit">Consulter</button>
                </div>
            </form>
        </div>
    
        <div id="notes_module" class="card">
            <h2>Notes du module</h2>
            <% if (notes != null && !notes.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Étudiant</th>
                            <th>Note</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(String n : notes) { 
                            String[] p = n.split(":");
                            if(p.length >= 2) {
                        %>
                        <tr>
                            <td><%= p[0] %></td>
                            <td>
                                 <% 
                                 float noteVal = Float.parseFloat(p[1]);
                                 String color = noteVal < 10 ? "#d9534f" : "#5E8C61";
                                 %>
                                <strong style="color:<%= color %>"><%= p[1] %>/20</strong>
                            </td>
                        </tr>
                        <%  } 
                           } %>
                    </tbody>
                </table>
            <% } else { %>
                <p style="color:#666; text-align:center;">Veuillez sélectionner un module ou aucune note n'est saisie.</p>
            <% } %>
        </div>

        <div id="evaluations_etudiants" class="card">
            <h2>Évaluations des étudiants</h2>
            
            <% if (evalData != null && (int)evalData.get("totalEvaluations") > 0) { 
                int[] stars = (int[]) evalData.get("statsArray");
            %>
                <div style="margin-bottom:20px; font-size:1.1em; color:var(--col-midnight);">
                    <strong>Note Moyenne : <span style="font-size:1.3em;"><%= evalData.get("averageRating") %>/5</span></strong> 
                    <span style="color:#666;">(<%= evalData.get("totalEvaluations") %> avis)</span>
                </div>

                <div style="height:250px;">
                    <canvas id="evalChart"></canvas>
                </div>
                <script>
                    new Chart(document.getElementById('evalChart'), {
                        type: 'bar',
                        data: {
                            labels: ['1★', '2★', '3★', '4★', '5★'],
                            datasets: [{
                                label: 'Nombre de votes',
                                data: [<%= stars[1] %>, <%= stars[2] %>, <%= stars[3] %>, <%= stars[4] %>, <%= stars[5] %>],
                                backgroundColor: ['#d9534f', '#f0ad4e', '#f39c12', '#72BDA3', '#5E8C61'],
                                borderRadius: 4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: { legend: { display: false } },
                            scales: { 
                                y: { beginAtZero: true, ticks: { stepSize: 1 } } 
                            }
                        }
                    });
                </script>
            <% } else { %>
                <p style="color:#666; text-align:center;">Aucune évaluation disponible pour ce module.</p>
            <% } %>
        </div>

        <div class="card">
            <h2>Commentaires</h2>
            <% 
            if (evalData != null) {
                List<Map<String,String>> comments = (List<Map<String,String>>) evalData.get("comments");
                if (comments != null && !comments.isEmpty()) {
                    for(Map<String,String> c : comments) {
            %>
                <div style="border-bottom:1px solid #eee; padding:15px 0; position:relative;">
                    <strong style="color:var(--col-midnight);"><%= c.get("studentName") %></strong> 
                    <span style="color:#f39c12; font-weight:bold;">
                        (<%= c.get("rating") %>★)
                    </span> :
                    <br>
                    <div style="color:#555; margin-top:5px; font-style:italic;">"<%= c.get("comment") %>"</div>

                    <form action="prof" method="post" style="position:absolute; top:15px; right:0;">
                        <input type="hidden" name="action" value="deleteComment">
                        <input type="hidden" name="id" value="<%= c.get("id") %>">
                        <input type="hidden" name="module" value="<%= selectedModuleId %>">
                        <button type="submit" style="background:none; border:none; color:#d9534f; cursor:pointer; font-size:1.5em; padding:0;" onclick="return confirm('Supprimer ce commentaire ?')">
                            &times;
                        </button>
                    </form>
                </div>
            <% 
                    }
                } else { out.print("<p style='color:#666; text-align:center;'>Aucun commentaire écrit.</p>"); }
            }
            %>
        </div>
    </div>
</body>
</html>