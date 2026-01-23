<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/svg+xml" href="assets/logo.svg">
    <title>Inscription - Pronte</title>
    <style>
        :root {
            --col-midnight: #090446;
            --col-mint-light: #94E8B4;
            --col-mint-med: #72BDA3;
            --col-forest: #5E8C61;
            --col-olive: #404F40;
            --col-white: #ffffff;
            --col-error: #d9534f;
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex; 
            justify-content: center; 
            align-items: center; 
            min-height: 100vh; 
            margin: 0;
            background: linear-gradient(135deg, var(--col-mint-med), var(--col-midnight));
        }

        .signup-container { 
            background: var(--col-white); 
            padding: 40px; 
            border-radius: 12px; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.2); 
            width: 100%;
            max-width: 400px;
        }

        h2 { 
            text-align: center; 
            color: var(--col-midnight); 
            margin-top: 0;
            margin-bottom: 25px; 
            font-weight: 700;
        }

        .form-group { 
            margin-bottom: 20px; 
        }

        label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: var(--col-olive);
            font-size: 0.9em;
        }

        input[type="text"], input[type="password"], select { 
            width: 100%; 
            padding: 12px; 
            box-sizing: border-box; 
            border: 2px solid #eee; 
            border-radius: 6px; 
            font-size: 14px;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }

        input:focus, select:focus { 
            border-color: var(--col-mint-med); 
            outline: none; 
            background-color: #fff;
            box-shadow: 0 0 0 3px rgba(114, 189, 163, 0.2);
        }

        button { 
            width: 100%; 
            padding: 14px; 
            background-color: var(--col-forest); 
            color: white; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-size: 16px; 
            font-weight: bold; 
            margin-top: 15px; 
            transition: background 0.3s, transform 0.1s;
        }

        button:hover { 
            background-color: var(--col-olive); 
        }

        button:active {
            transform: scale(0.98);
        }

        .login-link { 
            text-align: center; 
            margin-top: 25px; 
            font-size: 0.95em; 
            color: #666;
        }

        .login-link a { 
            color: var(--col-midnight); 
            text-decoration: none; 
            font-weight: bold;
            transition: color 0.2s;
        }

        .login-link a:hover { 
            color: var(--col-mint-med); 
            text-decoration: underline;
        }

        .error-msg { 
            color: var(--col-error); 
            background-color: #fdeded;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #f5c6cb;
            text-align: center; 
            margin-bottom: 20px; 
            font-size: 0.9em; 
        }
    </style>
</head>
<body>

<div class="signup-container">
    <div style="text-align: center; margin-bottom: 20px;">
        <img src="assets/logo.svg" alt="Logo" width="60" height="60">
    </div>
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