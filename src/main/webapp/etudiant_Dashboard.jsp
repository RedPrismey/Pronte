<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>

        <!DOCTYPE html>
        <html>

        <head>
            <title>Espace Étudiant</title>
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

                select,
                input,
                textarea {
                    padding: 8px;
                    width: 100%;
                }

                button {
                    padding: 10px;
                    background: #0056b3;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 10px;
                }

                th,
                td {
                    border: 1px solid #ccc;
                    padding: 8px;
                }

                .alert {
                    color: green;
                    font-weight: bold;
                    margin-bottom: 10px;
                }
            </style>
        </head>

        <body>

            <div class="sidebar">
                <h3>Espace Étudiant</h3>
                <p>Bienvenue, <%= session.getAttribute("user") %>
                </p>
                <hr>
                <a href="#notes">📘 Mes notes</a>
                <a href="#evaluation">📝 Évaluer un module</a>
                <hr>
                <a href="LogoutServlet">Déconnexion</a>
            </div>

            <div class="content">

                <% if (request.getAttribute("message") !=null) { %>
                    <div class="alert">
                        <%= request.getAttribute("message") %>
                    </div>
                    <% } %>

                        <!-- ================= Notes ================= -->
                        <div id="notes" class="card">
                            <h2>Mes notes</h2>

                            <form method="get" action="etudiant">
                                <div class="form-row">
                                    <select name="semestre" required>
                                        <option value="">-- Choisir un semestre --</option>
                                        <% List<String> semestres = (List<String>) request.getAttribute("semestres");
                                                if (semestres != null) {
                                                for (String s : semestres) { %>
                                                <option value="<%= s %>">
                                                    <%= s %>
                                                </option>
                                                <% }} %>
                                    </select>
                                    <button type="submit">Afficher</button>
                                </div>
                            </form>

                            <% List<String> notes = (List<String>) request.getAttribute("notesList");
                                    if (notes != null) { %>
                                    <table>
                                        <tr>
                                            <th>Module</th>
                                            <th>Note</th>
                                        </tr>
                                        <% for (String n : notes) { String[] p=n.split(":"); %>
                                            <tr>
                                                <td>
                                                    <%= p[0] %>
                                                </td>
                                                <td>
                                                    <%= p[1] %> /20
                                                </td>
                                            </tr>
                                            <% } %>
                                    </table>
                                    <% } %>
                        </div>

                        <!-- ================= Évaluation ================= -->
                        <div id="evaluation" class="card">
                            <h2>Évaluer un module</h2>

                            <form method="post" action="etudiant">
                                <input type="hidden" name="action" value="evaluerModule">

                                <div class="form-row">
                                    <select name="module" required>
                                        <option value="Java Avancé">Java Avancé</option>
                                        <option value="Bases de Données">Bases de Données</option>
                                    </select>
                                </div>

                                <div class="form-row">
                                    <input type="number" name="supports" min="1" max="5"
                                        placeholder="Qualité des supports (1-5)" required>
                                    <input type="number" name="equipe" min="1" max="5"
                                        placeholder="Équipe pédagogique (1-5)" required>
                                    <input type="number" name="charge" min="1" max="5"
                                        placeholder="Charge de travail (1-5)" required>
                                </div>

                                <textarea name="commentaire" placeholder="Commentaire libre"></textarea>

                                <button type="submit">Envoyer l’évaluation</button>
                            </form>
                        </div>

            </div>

        </body>

        </html>