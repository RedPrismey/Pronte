<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.insa.sae.Specialty" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/svg+xml" href="assets/logo.svg">
    <title>Statistiques - Admin</title>
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
            --col-warning: #f0ad4e;
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; 
            display: flex; 
            background: var(--col-bg); 
            color: #333;
        }

        .sidebar { 
            width: 260px; 
            background: var(--col-midnight);
            color: white; 
            min-height: 100vh; 
            padding: 25px; 
            box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar h3 { color: var(--col-mint-light); text-align: center; margin-top: 0; margin-bottom: 30px; }

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
        
        .sidebar hr { border: 0; border-top: 1px solid var(--col-olive); opacity: 0.5; margin: 20px 0; }

        .content { flex: 1; padding: 40px; }
        
        .card { 
            background: var(--col-white); 
            padding: 30px; 
            margin-bottom: 30px; 
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
            border-left: 5px solid var(--col-mint-med);
        }
        
        h1, h2 { color: var(--col-midnight); margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
        
        th { background-color: var(--col-midnight); color: white; font-weight: 600; }
        
        tr:hover { background-color: #fcfcfc; }
        
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 0.85em; font-weight: bold; color: white;}
        .badge-success { background-color: var(--col-forest); }
        .badge-warning { background-color: var(--col-warning); color: #fff; }
        .badge-danger { background-color: var(--col-danger); }
        
        .medal { font-size: 1.5em; }
        
        .nav-link.active { background: var(--col-forest); color: white; font-weight: bold; }
        
        select { 
            padding: 10px; 
            border-radius: 6px; 
            border: 1px solid #ddd; 
            font-size: 14px; 
            min-width: 250px;
            background-color: #fcfcfc;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h3>Administration</h3>
    <a href="admin">← Retour Dashboard</a>
    <hr>
    <a href="StatsServlet?type=classement" class="<%= "classement".equals(request.getAttribute("viewType")) ? "active" : "" %>">🏆 Classement Promo</a>
    <a href="StatsServlet?type=evaluations" class="<%= "evaluations".equals(request.getAttribute("viewType")) ? "active" : "" %>">📊 Évaluations & Réussite</a>
</div>

<div class="content">
    <% String viewType = (String) request.getAttribute("viewType"); %>

    <% if ("classement".equals(viewType)) { %>
        <div class="card">
            <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:20px;">
                <h1 style="border:none; margin:0;">🏆 Classement de la Promotion</h1>
                
                <form action="StatsServlet" method="get">
                    <input type="hidden" name="type" value="classement">
                    <label style="font-weight:bold; margin-right:10px; color:var(--col-olive);">Filtrer par Spécialité :</label>
                    <select name="specId" onchange="this.form.submit()">
                        <option value="">-- Toute les promos --</option>
                        <% 
                        List<Specialty> specs = (List<Specialty>) request.getAttribute("listeSpecs");
                        String selectedId = (String) request.getAttribute("selectedSpecId");
                        if (specs != null) {
                            for (Specialty s : specs) {
                                String isSel = (String.valueOf(s.getId()).equals(selectedId)) ? "selected" : "";
                        %>
                            <option value="<%= s.getId() %>" <%= isSel %>><%= s.getName() %></option>
                        <% 
                            }
                        }
                        %>
                    </select>
                </form>
            </div>
            
            <p style="color:#666; margin-top:10px;">Moyenne générale pondérée de tous les étudiants.</p>
            
            <table>
                <thead>
                    <tr>
                        <th width="80">Rang</th>
                        <th>Étudiant</th>
                        <th>Spécialité</th>
                        <th>Moyenne Générale</th>
                        <th>Mention</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    List<Map<String, Object>> list = (List<Map<String, Object>>) request.getAttribute("classementList");
                    if (list != null && !list.isEmpty()) {
                        int rank = 1;
                        for (Map<String, Object> u : list) {
                            double moy = (double) u.get("moyenne");
                            String mention = "Insuffisant";
                            String badgeClass = "badge-danger";
                            
                            if (moy >= 16) { mention = "Très Bien"; badgeClass = "badge-success"; }
                            else if (moy >= 14) { mention = "Bien"; badgeClass = "badge-success"; }
                            else if (moy >= 12) { mention = "Assez Bien"; badgeClass = "badge-warning"; }
                            else if (moy >= 10) { mention = "Passable"; badgeClass = "badge-warning"; }
                    %>
                    <tr>
                        <td style="text-align:center;">
                            <% if(rank==1) out.print("<span class='medal'>🥇</span>");
                               else if(rank==2) out.print("<span class='medal'>🥈</span>"); 
                               else if(rank==3) out.print("<span class='medal'>🥉</span>"); 
                               else out.print("<strong style='color:#666'>"+rank+"</strong>");
                            %>
                        </td>
                        <td>
                            <strong><%= u.get("nom") %></strong> <%= u.get("prenom") %>
                            <a href="DetailEtudiantServlet?id=<%= u.get("id") %>" style="text-decoration:none; margin-left:8px;" title="Voir détails">🔍</a>
                        </td>
                        <td><%= u.get("specialite") %></td>
                        <td style="font-size:1.1em; font-weight:bold; color:var(--col-midnight);"><%= String.format("%.2f", moy) %>/20</td>
                        <td><span class="badge <%= badgeClass %>"><%= mention %></span></td>
                    </tr>
                    <%      rank++;
                        } 
                    } else { %>
                        <tr><td colspan="5" style="text-align:center; padding:30px; color:#666;">Aucun étudiant trouvé pour cette sélection.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    <% } else if ("evaluations".equals(viewType)) { %>
        
        <div class="card">
            <h1>📊 Performance des Modules</h1>
            <p style="color:#666;">Comparaison entre la satisfaction des étudiants (Évaluations) et leurs résultats réels (Notes).</p>
            <div style="height: 400px; width: 100%;">
                <canvas id="moduleChart"></canvas>
            </div>
        </div>

        <div class="card">
            <h2>Détails par Module</h2>
            <table>
                <thead>
                    <tr>
                        <th>Module</th>
                        <th>Satisfaction Étudiants</th>
                        <th>Moyenne de Classe</th>
                        <th>Taux de Réussite</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    List<Map<String, Object>> stats = (List<Map<String, Object>>) request.getAttribute("statsModules");
                    
                    StringBuilder labels = new StringBuilder("[");
                    StringBuilder dataRating = new StringBuilder("[");
                    StringBuilder dataPassRate = new StringBuilder("[");
                    if (stats != null) {
                        for (Map<String, Object> m : stats) {
                            double rating = m.get("avgRating") != null ? (double) m.get("avgRating") : 0.0;
                            double passRate = (double) m.get("tauxReussite");
                            double classAvg = (double) m.get("moyenneModule");
                            int nbAvis = (int) m.get("nbAvis");
                            
                            labels.append("'").append(m.get("moduleName")).append("',");
                            dataRating.append(rating * 20).append(","); 
                            dataPassRate.append(passRate).append(",");
                    %>
                    <tr>
                        <td><strong><%= m.get("moduleName") %></strong></td>
                        <td>
                            <div style="display:flex; align-items:center;">
                                <span style="color:#f39c12; font-size:1.2em; margin-right:5px;">★</span>
                                <strong><%= String.format("%.1f", rating) %>/5</strong>
                                <span style="color:#999; font-size:0.9em; margin-left:5px;">(<%= nbAvis %> avis)</span>
                            </div>
                        </td>
                        <td><strong style="color:var(--col-midnight);"><%= String.format("%.2f", classAvg) %>/20</strong></td>
                        <td>
                            <div style="width: 100%; background-color: #eee; border-radius: 5px; height: 10px; width: 100px; display: inline-block; margin-right: 5px;">
                                <div style="width: <%= passRate %>%; background-color: <%= passRate < 50 ? "#d9534f" : "#5E8C61" %>; height: 100%; border-radius: 5px;"></div>
                            </div>
                            <strong><%= String.format("%.0f", passRate) %>%</strong>
                        </td>
                    </tr>
                    <% 
                        } 
                    } 
                    labels.append("]");
                    dataRating.append("]");
                    dataPassRate.append("]");
                    %>
                </tbody>
            </table>
        </div>

        <script>
            const ctx = document.getElementById('moduleChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: <%= labels.toString() %>,
                    datasets: [
                        {
                            label: 'Taux de Réussite (%)',
                            data: <%= dataPassRate.toString() %>,
                            backgroundColor: 'rgba(94, 140, 97, 0.7)', // Forest Green
                            borderColor: 'rgba(94, 140, 97, 1)',
                            borderWidth: 1,
                            yAxisID: 'y'
                        },
                        {
                            label: 'Satisfaction (Convertie en %)',
                            data: <%= dataRating.toString() %>,
                            type: 'line',
                            borderColor: '#f39c12',
                            backgroundColor: '#f39c12',
                            borderWidth: 3,
                            pointRadius: 5,
                            pointHoverRadius: 7,
                            yAxisID: 'y'
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100,
                            title: { display: true, text: 'Pourcentage' }
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) { label += ': '; }
                                    if (context.raw !== null) { label += Math.round(context.raw) + '%'; }
                                    return label;
                                }
                            }
                        }
                    }
                }
            });
        </script>
    <% } %>
</div>

</body>
</html>