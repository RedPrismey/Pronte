<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.insa.sae.Specialty" %>
<%@ page import="org.insa.sae.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/Papillon.png" />
    <script>
        function confirmerSuppression(type, id) {
            if(confirm("Êtes-vous sûr de vouloir supprimer cet élément ? Cette action est irréversible.")) {
                var form = document.createElement("form");
                form.method = "POST";
                form.action = "admin";
                
                var inputAction = document.createElement("input");
                inputAction.type = "hidden";
                inputAction.name = "action";
                inputAction.value = "delete";
                form.appendChild(inputAction);
    
                var inputType = document.createElement("input");
                inputType.type = "hidden";
                inputType.name = "type";
                inputType.value = type;
                form.appendChild(inputType);
    
                var inputId = document.createElement("input");
                inputId.type = "hidden";
                inputId.name = "id";
                inputId.value = id;
                form.appendChild(inputId);
    
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
    <style>
        :root {
            --col-midnight: #090446;
            --col-mint-light: #94E8B4;
            --col-mint-med: #72BDA3;
            --col-forest: #5E8C61;
            --col-olive: #404F40;
            --col-bg: #f4f7f6;
            --col-white: #ffffff;
        }

        * { box-sizing: border-box; } 
        
        html { scroll-behavior: smooth; } 
        
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            background-color: var(--col-bg);
            color: var(--col-olive);
        }

        .sidebar { 
            width: 260px; 
            background: var(--col-midnight); 
            color: var(--col-white); 
            height: 100vh; 
            padding: 25px; 
            position: fixed; 
            top: 0;
            left: 0;
            overflow-y: auto; 
            z-index: 1000;
            box-shadow: 4px 0 10px rgba(9, 4, 70, 0.1);
        }

        .sidebar h3 {
            color: var(--col-mint-light);
            text-align: center;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .sidebar p {
            color: var(--col-mint-med);
            text-align: center;
            font-size: 0.9em;
            margin-top: 0;
            margin-bottom: 30px;
        }

        .menu hr {
            border: 0;
            border-top: 1px solid var(--col-olive);
            opacity: 0.3;
            margin: 15px 0;
        }

        .sidebar a { 
            display: block; 
            color: var(--col-white); 
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
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
            border-left: 5px solid var(--col-mint-med);
            scroll-margin-top: 20px;
        }

        /* Special style for the Evaluations card to match your request */
        #evaluations.card {
            border-left: 5px solid var(--col-midnight);
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
            align-items: flex-end;
            flex-wrap: wrap;
        }

        label {
            color: var(--col-olive);
            font-weight: 600;
            font-size: 0.9em;
        }

        input, select { 
            padding: 12px; 
            border: 1px solid #ddd; 
            border-radius: 6px; 
            flex: 1; 
            font-size: 14px;
            background-color: #fcfcfc;
            transition: border-color 0.3s;
        }

        input:focus, select:focus {
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
            transition: background 0.3s, transform 0.1s;
        }

        button:hover {
            background: var(--col-olive);
        }

        button:active {
            transform: scale(0.98);
        }

        [cite_start]/* Specific Button Colors based on Palette [cite: 5] */
        .btn-logout button {
            background-color: var(--col-midnight) !important;
        }
        
        .btn-secondary button {
            background-color: var(--col-mint-med) !important;
        }

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
            text-transform: uppercase;
            font-size: 0.85em;
            letter-spacing: 0.5px;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background-color: #f9fdfb;
        }

        .alert { 
            color: var(--col-olive); 
            font-weight: bold; 
            margin-bottom: 25px; 
            padding: 15px 20px; 
            background: var(--col-mint-light); 
            border-left: 5px solid var(--col-forest); 
            border-radius: 6px;
        }

        /* Custom scrollbar for sidebar */
        .sidebar::-webkit-scrollbar {
            width: 6px;
        }
        .sidebar::-webkit-scrollbar-track {
            background: var(--col-midnight);
        }
        .sidebar::-webkit-scrollbar-thumb {
            background: var(--col-forest);
            border-radius: 3px;
        }

        /* Checkbox area styling */
        .checkbox-group {
            display: flex; 
            flex-wrap: wrap; 
            gap: 15px; 
            background: #f8fcf9; 
            padding: 15px; 
            border: 1px solid #e0e0e0; 
            border-radius: 6px;
        }
        
        .delete-btn {
            color: #d9534f; /* Kept distinct for safety */
            background: none;
            border: none;
            padding: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div style="text-align: center; margin-bottom: 30px;">
        <a href="${pageContext.request.contextPath}/index.jsp">
            <img src="${pageContext.request.contextPath}/images/Papillon.png" alt="Papillon" height="50"/>
            <h3>Pronte</h3>
        </a>
    </div>
    <h3>Administration</h3>
    <p>Espace Admin</p>
    
    <div class="menu">
        <hr>
        <a href="#specialties">Gestion Spécialités</a>
        <a href="#modules">Gérer les modules</a>
        <a href="#inscription">Inscrire un étudiant</a>
        <a href="#saisie_notes">Saisir des notes</a>
        <a href="#suppression">Suppression d'User</a>
        <a href="#consultation_notes">Consultation Note</a>
        <a href="#consultation">Liste étudiants</a>
        <a href="#evaluations">Évaluations & Qualité</a>
        <hr>
        <a href="LogoutServlet">Déconnexion</a>
    </div>
</div>

<div class="content">

    <% if (request.getAttribute("message") != null) { %>
        <div class="alert"><%= request.getAttribute("message") %></div>
    <% } %>

    <div id="specialties" class="card">
        <h2>Gestion des Spécialités</h2>
        <form action="admin" method="post">
            <input type="hidden" name="action" value="createSpecialty">
            <div class="form-row">
                <input type="text" name="nomSpecialite" placeholder="Nom de la nouvelle spécialité (ex: Big Data)" required>
                <button type="submit" style="flex:0;">Ajouter</button>
            </div>
        </form>
    </div>

    <div id="modules" class="card">
        <h2>Ajouter un Module</h2>
        <form action="admin" method="post">
            <input type="hidden" name="action" value="createModule">
            
            <div class="form-row">
                <input type="text" name="moduleName" placeholder="Nom du module (ex: Algèbre)" required>
                <select name="teacherId" required>
                    <option value="" disabled selected>-- Enseignant Responsable --</option>
                    <% 
                    List<User> profs = (List<User>) request.getAttribute("listeProfs");
                    if (profs != null) {
                        for (User p : profs) { 
                    %>
                        <option value="<%= p.getId() %>">
                            <%= p.getName() %> <%= p.getSurname() %>
                        </option>
                    <% 
                        } 
                    } 
                    %>
                </select>
            </div>

            <label style="display:block; margin-top:15px; margin-bottom:8px;">Associer aux spécialités :</label>
            <div class="checkbox-group">
                <% 
                List<Specialty> listeSpecsPourModule = (List<Specialty>) request.getAttribute("listeSpecialites");
                if (listeSpecsPourModule != null) {
                    for (Specialty s : listeSpecsPourModule) { 
                %>
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <input type="checkbox" id="spec_<%= s.getId() %>" name="specialtyIds" value="<%= s.getId() %>" style="flex:none;">
                        <label for="spec_<%= s.getId() %>" style="font-weight:normal; margin:0;"><%= s.getName() %></label>
                    </div>
                <% 
                    } 
                } 
                %>
            </div>
            
            <button type="submit" style="margin-top:20px;">Créer le Module</button>
        </form>
    </div>

    <div id="inscription" class="card">
        <h2>Valider l'inscription administrative</h2>
        <p style="font-size:0.9em; color:#666; margin-bottom:15px;">Seuls les étudiants sans spécialité apparaissent ici.</p>
        <form action="admin" method="post">
            <input type="hidden" name="action" value="createEtudiant">
            
            <div class="form-row">
                <select name="usernameEtudiant" required>
                    <option value="" disabled selected>-- Sélectionner un étudiant non-inscrit --</option>
                    <% 
                    List<User> etudiantsNonInscrits = (List<User>) request.getAttribute("etudiantsNonInscrits");
                    if (etudiantsNonInscrits != null && !etudiantsNonInscrits.isEmpty()) {
                        for (User u : etudiantsNonInscrits) { 
                    %>
                        <option value="<%= u.getUsername() %>">
                            <%= u.getName() %> <%= u.getSurname() %> (<%= u.getUsername() %>)
                        </option>
                    <% 
                        } 
                    } else {
                    %>
                        <option disabled>Tous les étudiants ont une spécialité</option>
                    <% } %>
                </select>
            </div>
            
            <div class="form-row">
                <input type="text" name="ine" placeholder="Numéro INE à attribuer" pattern="[0-9]{11}" inputmode="numeric" maxlength="11" required>
                <select name="specialtyId" required>
                    <option value="" disabled selected>-- Spécialité --</option>
                    <% 
                    List<Specialty> specs = (List<Specialty>) request.getAttribute("listeSpecialites");
                    if (specs != null) {
                        for (Specialty s : specs) { 
                    %>
                        <option value="<%= s.getId() %>"><%= s.getName() %></option>
                    <% 
                        } 
                    } 
                    %>
                </select>
            </div>
            <button type="submit">Valider l'inscription</button>
        </form>
    </div>

    <div id="saisie_notes" class="card">
        <h2>Saisir une note</h2>
        <form action="admin" method="post">
            <input type="hidden" name="action" value="addNote">
            
            <div class="form-row">
                <select name="idEtudiant" required>
                    <option value="">-- Sélectionner un étudiant --</option>
                    <% 
                    List<User> etudiantsInscrits = (List<User>) request.getAttribute("etudiantsInscrits");
                    if(etudiantsInscrits != null) {
                        for(User u : etudiantsInscrits) { 
                    %>
                        <option value="<%= u.getId() %>">
                            <%= u.getName() %> <%= u.getSurname() %>
                        </option>
                    <% 
                        } 
                    } 
                    %>
                </select>

                <select name="idModule" required>
                    <option value="">-- Sélectionner un module --</option>
                    <% 
                    List<ModuleEntity> mods = (List<ModuleEntity>) request.getAttribute("listeModules");
                    if(mods != null) {
                        for(ModuleEntity m : mods) {
                    %>
                        <option value="<%= m.getId() %>"><%= m.getName() %></option>
                    <% 
                        } 
                    } 
                    %>
                </select>
            </div>

            <div class="form-row">
                <input type="number" step="0.5" name="valeur" placeholder="Note /20" min="0" max="20" required>
                <select name="typeNote">
                    <option value="Exam">Examen Final</option>
                    <option value="CC">Contrôle Continu</option>
                    <option value="TP">TP</option>
                </select>
                <input type="number" step="0.1" name="coef" placeholder="Coefficient" value="1.0" min="0">
            </div>
            <button type="submit">Enregistrer la note</button>
        </form>
    </div>

    <div class="card" id="suppression">
        <h2>Suppression Rapide (Maintenance)</h2>
        <div style="display:flex; gap:30px; flex-wrap: wrap;">
            
            <div style="flex:1; min-width: 300px;">
                <h3 style="color:var(--col-forest);">Professeurs</h3>
                <ul style="max-height:200px; overflow-y:auto; list-style:none; padding:0; border:1px solid #eee; border-radius:6px;">
                    <% 
                    List<User> tProfs = (List<User>) request.getAttribute("listeProfs");
                    if(tProfs != null) for(User p : tProfs) { %>
                    <li style="border-bottom:1px solid #eee; padding:10px; display:flex; justify-content:space-between; align-items:center;">
                        <span><%= p.getName() %> <%= p.getSurname() %></span>
                        <a href="#" onclick="confirmerSuppression('user', <%= p.getId() %>)" style="text-decoration:none;">❌</a>
                    </li>
                    <% } %>
                </ul>
            </div>
    
            <div style="flex:1; min-width: 300px;">
                <h3 style="color:var(--col-forest);">Modules</h3>
                <ul style="max-height:200px; overflow-y:auto; list-style:none; padding:0; border:1px solid #eee; border-radius:6px;">
                    <% 
                    List<ModuleEntity> tMods = (List<ModuleEntity>) request.getAttribute("listeModules");
                    if(tMods != null) for(ModuleEntity m : tMods) { %>
                    <li style="border-bottom:1px solid #eee; padding:10px; display:flex; justify-content:space-between; align-items:center;">
                        <span><%= m.getName() %></span>
                        <a href="#" onclick="confirmerSuppression('module', <%= m.getId() %>)" style="text-decoration:none;">❌</a>
                    </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </div>

    <div class="card" id="consultation_notes">
        <h2>Consultation des Notes par Spécialité & Modules</h2>
        
        <form action="admin" method="get">
            <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                <div style="flex: 1; min-width: 250px;">
                    <label>1. Choisir la Spécialité :</label>
                    <select name="filterSpecId" required onchange="this.form.submit()">
                        <option value="">-- Sélectionner --</option>
                        <% 
                        String selSpecId = (String) request.getAttribute("selectedSpecId");
                        if (specs != null) {
                            for (Specialty s : specs) { 
                                String isSel = (String.valueOf(s.getId()).equals(selSpecId)) ? "selected" : "";
                        %>
                            <option value="<%= s.getId() %>" <%= isSel %>><%= s.getName() %></option>
                        <% 
                            } 
                        } 
                        %>
                    </select>
                </div>

                <div style="flex: 1; min-width: 250px;">
                    <label>3. Trier par :</label>
                    <% String sort = (String) request.getAttribute("selectedSort"); %>
                    <select name="sortType">
                        <option value="name_asc" <%= "name_asc".equals(sort) ? "selected" : "" %>>Nom (A-Z)</option>
                        <option value="name_desc" <%= "name_desc".equals(sort) ? "selected" : "" %>>Nom (Z-A)</option>
                        <option value="note_desc" <%= "note_desc".equals(sort) ? "selected" : "" %>>Meilleures notes d'abord</option>
                        <option value="note_asc" <%= "note_asc".equals(sort) ? "selected" : "" %>>Moins bonnes notes d'abord</option>
                    </select>
                </div>
            </div>

            <div style="margin-top: 15px; border: 1px solid #ddd; padding: 15px; border-radius: 6px; background: #fcfcfc;">
                <label style="display:block; margin-bottom:10px;">2. Filtrer par Modules (Cocher pour afficher) :</label>
                <div style="display: flex; flex-wrap: wrap; gap: 15px; max-height: 100px; overflow-y: auto;">
                    <% 
                    List<ModuleEntity> filterMods = (List<ModuleEntity>) request.getAttribute("listeModules");
                    List<Integer> selMods = (List<Integer>) request.getAttribute("selectedModules");
                    
                    if (filterMods != null) {
                        for (ModuleEntity m : filterMods) {
                            String checked = (selMods != null && selMods.contains(m.getId())) ? "checked" : "";
                    %>
                        <div style="display: flex; align-items: center; gap: 5px;">
                            <input type="checkbox" id="mod_f_<%= m.getId() %>" name="filterModuleIds" value="<%= m.getId() %>" <%= checked %> style="flex:none;">
                            <label for="mod_f_<%= m.getId() %>" style="font-weight:normal; margin:0;"><%= m.getName() %></label>
                        </div>
                    <% 
                        } 
                    } 
                    %>
                </div>
                <p style="font-size: 0.8em; color: #666; margin-top: 8px; font-style: italic;">* Si aucun module n'est coché, aucun résultat ne s'affichera.</p>
            </div>

            <button type="submit" style="margin-top: 15px; width: 100%;">Afficher les notes filtrées</button>
        </form>

        <% 
        List<Map<String, Object>> resultats = (List<Map<String, Object>>) request.getAttribute("resultatsNotes");
        if (resultats != null && !resultats.isEmpty()) { 
        %>
            <table>
                <thead>
                    <tr>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Module</th>
                        <th>Note</th>
                        <th>Coef</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> row : resultats) { 
                        float nVal = (float) row.get("note");
                        String color = nVal < 10 ? "#d9534f" : "var(--col-forest)";
                    %>
                    <tr>
                        <td><strong><%= row.get("prenom") %></strong></td>
                        <td><%= row.get("nom") %></td>
                        <td><%= row.get("module") %></td>
                        <td style="color:<%= color %>; font-weight:bold;"><%= nVal %>/20</td>
                        <td><%= row.get("coef") %></td>
                        <td style="text-align: center;">
                            <a href="#" onclick="confirmerSuppression('note', <%= row.get("id") %>)" style="color:#d9534f; text-decoration:none; font-size: 1.2em;">❌</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else if (selSpecId != null && !selSpecId.isEmpty()) { %>
            <p style="text-align: center; margin-top: 20px; color: #666;">Aucune note trouvée pour cette sélection. (Avez-vous coché des modules ?)</p>
        <% } %>
    </div>

    <div id="consultation" class="card">
        <h2>Liste étudiants</h2>
        
        <form action="admin" method="get" style="margin-bottom: 20px;">
            <label>Afficher les étudiants par spécialité :</label>
            <div class="form-row">
                <select name="filtreSpecialite">
                    <option value="all">-- Toutes les spécialités --</option>
                    <% 
                    if (specs != null) {
                        String currentFilter = (String) request.getAttribute("filtreActif");
                        for (Specialty s : specs) { 
                            String selected = (s.getName().equals(currentFilter)) ? "selected" : "";
                    %>
                        <option value="<%= s.getName() %>" <%= selected %>><%= s.getName() %></option>
                    <% 
                        } 
                    } 
                    %>
                </select>
                <button type="submit" style="flex:0;">Filtrer</button>
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
                <% 
                Map<Integer, String> mapIne = (Map<Integer, String>) request.getAttribute("mapIne");
                Map<Integer, String> mapSpe = (Map<Integer, String>) request.getAttribute("mapSpecialiteName");

                if (etudiantsInscrits != null && !etudiantsInscrits.isEmpty()) {
                    for (User u : etudiantsInscrits) {
                        String ineDisplay = mapIne.getOrDefault(u.getId(), "-");
                        String speDisplay = mapSpe.getOrDefault(u.getId(), "-");
                %>
                <tr>
                    <td><%= ineDisplay %></td>
                    <td><%= u.getName() %></td>
                    <td><%= u.getSurname() %></td>
                    <td><%= speDisplay %></td>
                    <td>
                        <a href="GenererBulletinServlet?id=<%= u.getId() %>" target="_blank" style="color: var(--col-midnight); text-decoration: none; font-weight: bold;">📄 Bulletin</a> |
                        <a href="DetailEtudiantServlet?id=<%= u.getId() %>" style="color: var(--col-forest); text-decoration: none; font-weight: bold;">🔍 Détails</a>
                        <a href="#" onclick="confirmerSuppression('user', <%= u.getId() %>)" style="color:#d9534f; text-decoration:none; margin-left:10px;">❌ Supprimer</a>
                    </td>
                </tr>
                <% 
                    }
                } else {
                %>
                <tr>
                    <td colspan="5" style="text-align:center; padding: 30px;">Aucun étudiant inscrit trouvé.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div id="evaluations" class="card">
        <h2>Suivi Qualité & Statistiques</h2>
        <div class="form-row" style="justify-content: center; margin-top: 20px;">
            <a href="StatsServlet?type=evaluations">
                <button type="button">📊 Voir résultats évaluations modules</button>
            </a>
            
            <a href="StatsServlet?type=classement" class="btn-secondary">
                <button type="button">Voir Classement Promo</button>
            </a>
            
            <a href="LogoutServlet" class="btn-logout">
                <button type="button">Se déconnecter</button>
            </a>
        </div>
    </div>

</div>

</body>
</html>