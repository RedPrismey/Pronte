<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Inscription - Pronte</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #e9ecef; margin: 0; }
        .signup-container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 350px; }
        h2 { text-align: center; color: #333; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; }
        input[type="text"], input[type="password"], select { width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; transition: border 0.3s; }
        input:focus, select:focus { border-color: #0056b3; outline: none; }
        button { width: 100%; padding: 12px; background-color: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 10px; transition: background 0.3s; }
        button:hover { background-color: #218838; }
        .login-link { text-align: center; margin-top: 20px; font-size: 0.9em; }
        .login-link a { color: #0056b3; text-decoration: none; }
        .login-link a:hover { text-decoration: underline; }
        .error-msg { color: #dc3545; text-align: center; margin-bottom: 15px; font-size: 0.9em; }
    </style>
</head>
<body>

<div class="signup-container">
    <h2>Créer un compte</h2>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-msg"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <form action="SignUp_Servlet" method="post">
        <div class="form-group">
            <label for="nom">Nom</label>
            <input type="text" id="nom" name="nom" required placeholder="Votre nom">
        </div>

        <div class="form-group">
            <label for="prenom">Prénom</label>
            <input type="text" id="prenom" name="prenom" required placeholder="Votre prénom">
        </div>

        <div class="form-group">
            <label for="role">Rôle</label>
            <select id="role" name="role" required>
                <option value="" disabled selected>-- Choisir un rôle --</option>
                <option value="Etudiant">Étudiant</option>
                <option value="Enseignant">Enseignant</option>
                <option value="Admin">Administrateur</option>
            </select>
        </div>

        <div class="form-group">
            <label for="username">Nom d'utilisateur (Login)</label>
            <input type="text" id="username" name="username" required placeholder="Choisis un identifiant">
        </div>

        <div class="form-group">
            <label for="mdp">Mot de passe</label>
            <input type="password" id="mdp" name="mdp" required placeholder="********">
        </div>

        <button type="submit">S'inscrire</button>
    </form>

    <div class="login-link">
        Déjà un compte ? <a href="login.jsp">Se connecter</a>
    </div>
</div>

</body>
</html>