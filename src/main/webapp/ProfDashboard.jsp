<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.util.Map" %>

            <!DOCTYPE html>
            <html>

            <head>
                <title>Dashboard Enseignant</title>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                <style>
                    body {
                        font-family: sans-serif;
                        margin: 0;
                        display: flex;
                    }

                    .sidebar {
                        width: 250px;
                        background: #2c3e50;
                        color: white;
                        min-height: 100vh;
                        padding: 20px;
                    }

                    .sidebar a {
                        display: block;
                        color: white;
                        padding: 10px;
                        text-decoration: none;
                        margin-bottom: 5px;
                    }

                    .sidebar a:hover {
                        background: #34495e;
                    }

                    .content {
                        flex: 1;
                        padding: 20px;
                        background: #f4f4f9;
                    }

                    .card {
                        background: white;
                        padding: 20px;
                        margin-bottom: 20px;
                        border-radius: 8px;
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                    }

                    h2 {
                        border-bottom: 2px solid #0056b3;
                        padding-bottom: 10px;
                    }

                    .form-row {
                        display: flex;
                        gap: 10px;
                        margin-bottom: 10px;
                    }

                    select {
                        padding: 8px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        flex: 1;
                    }

                    table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-top: 15px;
                    }

                    th,
                    td {
                        border: 1px solid #ddd;
                        padding: 10px;
                        text-align: left;
                    }

                    th {
                        background-color: #eee;
                    }
                </style>
            </head>

            <body>

                <div class="sidebar">
                    <h3>Enseignant</h3>
                    <p>Bienvenue, <%= session.getAttribute("user") %>
                    </p>
                    <hr>
                    <a href="#modules">Mes modules</a>
                    <a href="#notes">Notes</a>
                    <a href="#evaluations">Évaluations</a>
                    <hr>
                    <a href="LogoutServlet">Déconnexion</a>
                </div>

                <div class="content">

                    <% List<String> modules = (List<String>) request.getAttribute("modules");
                            List<String> notes = (List<String>) request.getAttribute("notes");
                                    Map<String,Object> evalData = (Map<String,Object>)
                                            request.getAttribute("evaluationData");
                                            %>

                                            <!-- ================= MODULES ================= -->
                                            <div id="modules" class="card">
                                                <h2>Mes modules</h2>

                                                <form action="ProfServlet" method="get">
                                                    <div class="form-row">
                                                        <select name="module" required>
                                                            <option value="">-- Sélectionner un module --</option>
                                                            <% if (modules !=null) for(String m : modules) { %>
                                                                <option value="<%= m %>">
                                                                    <%= m %>
                                                                </option>
                                                                <% } %>
                                                        </select>
                                                        <button type="submit">Consulter</button>
                                                    </div>
                                                </form>
                                            </div>

                                            <!-- ================= NOTES ================= -->
                                            <div id="notes" class="card">
                                                <h2>Notes du module</h2>

                                                <% if (notes !=null && !notes.isEmpty()) { %>
                                                    <table>
                                                        <thead>
                                                            <tr>
                                                                <th>Étudiant</th>
                                                                <th>Note</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for(String n : notes) { // Format : Nom Prenom:Note
                                                                String[] p=n.split(":"); %>
                                                                <tr>
                                                                    <td>
                                                                        <%= p[0] %>
                                                                    </td>
                                                                    <td><strong>
                                                                            <%= p[1] %>/20
                                                                        </strong></td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                    </table>
                                                    <% } else { %>
                                                        <p>Aucune note à afficher.</p>
                                                        <% } %>
                                            </div>

                                            <!-- ================= ÉVALUATIONS ================= -->
                                            <div id="evaluations" class="card">
                                                <h2>Évaluations des étudiants</h2>

                                                <% if (evalData !=null) { %>

                                                    <canvas id="evalChart" height="120"></canvas>

                                                    <script>
                                                        new Chart(document.getElementById('evalChart'), {
                                                            type: 'bar',
                                                            data: {
                                                                labels: ['1★', '2★', '3★', '4★', '5★'],
                                                                datasets: [{

                                                                    backgroundColor: '#0056b3'
                                                                }]
                                                            },
                                                            options: {
                                                                plugins: { legend: { display: false } },
                                                                scales: { y: { beginAtZero: true } }
                                                            }
                                                        });
                                                    </script>

                                                    <% } else { %>
                                                        <p>Aucune évaluation disponible.</p>
                                                        <% } %>
                                            </div>

                                            <!-- ================= COMMENTAIRES ================= -->
                                            <div class="card">
                                                <h2>Commentaires</h2>

                                                <% List<Map<String,String>> comments =
                                                    evalData != null ? (List<Map<String,String>>)
                                                        evalData.get("comments") : null;
                                                        %>

                                                        <% if (comments !=null) for(Map<String,String> c : comments) {
                                                            %>
                                                            <p><strong>
                                                                    <%= c.get("studentName") %>
                                                                </strong> :
                                                                <%= c.get("comment") %>
                                                            </p>
                                                            <% } %>
                                            </div>

                </div>
            </body>

            </html>