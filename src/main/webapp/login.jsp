<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/svg+xml" href="assets/logo.svg">
    <title>Connexion - Pronte</title>
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
            height: 100vh; 
            margin: 0;
            background: linear-gradient(135deg, var(--col-mint-med), var(--col-midnight));
        }

        .login-container { 
            background: var(--col-white); 
            padding: 40px; 
            border-radius: 12px; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.2); 
            width: 100%;
            max-width: 350px; 
            display: flex;
            flex-direction: column;
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

        input[type="text"], input[type="password"] { 
            width: 100%; 
            padding: 12px; 
            box-sizing: border-box; 
            border: 2px solid #eee; 
            border-radius: 6px; 
            font-size: 14px;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: var(--col-mint-med);
            background-color: #fff;
            box-shadow: 0 0 0 3px rgba(114, 189, 163, 0.2);
        }

        button { 
            width: 100%; 
            padding: 14px; 
            background-color: var(--col-midnight); 
            color: white; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-size: 16px;
            font-weight: 600;
            transition: background-color 0.3s, transform 0.1s;
            margin-top: 10px;
        }

        button:hover { 
            background-color: var(--col-forest); 
        }

        button:active {
            transform: scale(0.98);
        }

        .error { 
            color: var(--col-error); 
            font-size: 0.9em; 
            margin-bottom: 20px; 
            text-align: center; 
            background-color: #fdeded;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #f5c6cb;
        }

        .success-msg {
            color: var(--col-forest); 
            background-color: var(--col-mint-light); 
            border: 1px solid var(--col-mint-med); 
            padding: 10px; 
            margin-bottom: 20px; 
            text-align: center; 
            border-radius: 6px;
            font-size: 0.9em;
            font-weight: 600;
        }

        .signup-link { 
            text-align: center; 
            margin-top: 25px; 
            font-size: 0.95em; 
            color: #666;
        }

        .signup-link a {
            color: var(--col-midnight);
            text-decoration: none;
            font-weight: bold;
            transition: color 0.2s;
        }

        .signup-link a:hover {
            color: var(--col-mint-med);
            text-decoration: underline;
        }

        .logo-container {
            text-align: center; 
            margin-bottom: 20px;
        }
        
        .logo-container img {
            filter: drop-shadow(0 4px 6px rgba(0,0,0,0.1));
        }
    </style>
</head>
<body>
    
<div class="login-container">
    <div class="logo-container">
        <img src="assets/logo.svg" alt="Logo Pronte" width="80" height="80">
    </div>
    <h2>Connexion</h2>

    <% if (request.getParameter("logout") != null) { %>
        <div class="success-msg">
            Vous avez été déconnecté avec succès.
        </div>
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <form action="Login_Servlet" method="post">
        <div class="form-group">
            <label for="username">Nom d'utilisateur</label>
            <input type="text" id="username" name="username" required placeholder="Ex: jdupont">
        </div>

        <div class="form-group">
            <label for="mdp">Mot de passe</label>
            <input type="password" id="mdp" name="mdp" required placeholder="••••••••">
        </div>

        <button type="submit">Se connecter</button>
    </form>

    <div class="signup-link">
        Pas encore de compte ?
        <a href="sign_up.jsp">S'inscrire</a>
    </div>
</div> 

</body>
</html>