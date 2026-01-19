<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Admin</title>
    <style>
        body { font-family: sans-serif; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #2c3e50; color: white; min-height: 100vh; padding: 20px; }
        .sidebar a { display: block; color: white; padding: 10px; text-decoration: none; margin-bottom: 5px; }
        .sidebar a:hover { background: #34495e; }
        .content { flex: 1; padding: 20px; background: #f4f4f9; }
        .card { background: white; padding: 20px; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        h2 { border-bottom: 2px solid #0056b3; padding-bottom: 10px; }
        .form-row { display: flex; gap: 10px; margin-bottom: 10px; }
        input, select { padding: 8px; border: 1px solid #ccc; border-radius: 4px; flex: 1; }
        button { padding: 10px 20px; background: #0056b3; color: white; border: none; border-radius: 4px; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #eee; }
        .alert { color: green; font-weight: bold; margin-bottom: 15px; }
    </style>
</head>
<body>

<div class="sidebar">
    <h3>Administration</h3>
    <p>Bienvenue, <%= session.getAttribute("user") %></p>
    <hr>
    <a href="#inscription">Inscrire un étudiant</a>
    <a href="#notes">Saisir des notes</a>
    <a href="#consultation">Listes & Résultats</a>
    <a href="#evaluations">Évaluations & Qualité</a>
    <hr>
    <a href="LogoutServlet">Déconnexion</a>
</div>

<div class="content">

    <% if (request.getAttribute("message") != null) { %>
        <div class="alert"><%= request.getAttribute("message") %></div>
    <% } %>

    <div id="inscription" class="card">
        <h2>Inscrire un étudiant</h2>
        <form action="AdminActionServlet" method="post">
            <input type="hidden" name="action" value="createEtudiant">
            <div class="form-row">
                <input type="text" name="nom" placeholder="Nom" required>
                <input type="text" name="prenom" placeholder="Prénom" required>
            </div>
            <div class="form-row">
                <input type="text" name="ine" placeholder="Numéro INE" required>
                <select name="specialite">
                    <option value="Informatique">Informatique</option>
                    <option value="Cybersecurite">Cybersécurité</option>
                    <option value="Reseau">Réseau</option>
                </select>
            </div>
            <div class="form-row">
                 <input type="text" name="photo" placeholder="URL Photo (optionnel)">
            </div>
            <button type="submit">Inscrire l'étudiant</button>
        </form>
    </div>

    <div id="notes" class="card">
        <h2>Saisir une note</h2>
        <form action="AdminActionServlet" method="post">
            <input type="hidden" name="action" value="addNote">
            
            <div class="form-row">
                <select name="idEtudiant" required>
                    <option value="">-- Sélectionner un étudiant --</option>
                    <% 
                    /* List<Etudiant> etuds = (List<Etudiant>) request.getAttribute("listeEtudiants");
                       if(etuds != null) {
                           for(Etudiant e : etuds) { */
                    %>
                        <% /* } } */ %>
                    <option value="1">Dupont Jean (Simulé)</option>
                </select>

                <select name="idModule" required>
                    <option value="">-- Sélectionner un module --</option>
                    <option value="1">Java Avancé</option>
                    <option value="2">Bases de Données</option>
                </select>
            </div>

            <div class="form-row">
                <input type="number" step="0.5" name="valeur" placeholder="Note /20" required>
                <select name="typeNote">
                    <option value="Exam">Examen Final</option>
                    <option value="CC">Contrôle Continu</option>
                    <option value="TP">TP</option>
                </select>
                <input type="number" step="0.1" name="coef" placeholder="Coefficient" value="1.0">
            </div>
            <button type="submit">Enregistrer la note</button>
        </form>
    </div>

    <div id="consultation" class="card">
        <h2>Listes et Consultations</h2>
        
        <form action="admin" method="get" style="margin-bottom: 20px;">
            <label>Afficher les étudiants par spécialité :</label>
            <div class="form-row">
                <select name="filtreSpecialite">
                    <option value="Informatique">Informatique</option>
                    <option value="Cybersecurite">Cybersécurité</option>
                </select>
                <button type="submit">Filtrer</button>
            </div>
        </form>

        <table>
            <thead>
                <tr>
                    <th>INE</th>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Spécialité</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1234567A</td>
                    <td>Martin</td>
                    <td>Alice</td>
                    <td>Informatique</td>
                    <td>
                        <a href="GenererBulletinServlet?id=1" target="_blank">📄 Bulletin</a> |
                        <a href="DetailEtudiantServlet?id=1">🔍 Détails</a>
                    </td>
                </tr>
            </tbody>
        </table>
        
        <h3 style="margin-top:20px;">Notes par Module</h3>
         <form action="admin" method="get">
             <div class="form-row">
                <select name="filtreModule">
                    <option>Java Avancé</option>
                </select>
                <button type="submit">Voir les notes</button>
             </div>
         </form>
    </div>

    <div id="evaluations" class="card">
        <h2>Suivi Qualité & Statistiques</h2>
        <div class="form-row">
            <a href="StatsServlet?type=evaluations"><button>📊 Voir résultats évaluations modules</button></a>
            <a href="StatsServlet?type=classement"><button style="background:#e67e22;"> Voir Classement Promo</button></a>
            <a href="LogoutServlet" class="btn-logout">Se déconnecter</a>
        </div>
    </div>

</div>

</body>
</html>