<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/svg+xml" href="assets/logo.svg">
    <title>Pronte - Accueil</title>
    <style>
        :root {
            --col-midnight: #090446;
            --col-mint-light: #94E8B4;
            --col-mint-med: #72BDA3;
            --col-forest: #5E8C61;
            --col-olive: #404F40;
            --col-white: #ffffff;
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--col-mint-med), var(--col-midnight)); 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            height: 100vh; 
            margin: 0;
        }

        .box { 
            background: var(--col-white); 
            padding: 40px; 
            border-radius: 12px; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.2); 
            width: 100%;
            max-width: 380px; 
            text-align: center; 
        }

        h1 { 
            color: var(--col-midnight); 
            margin-top: 10px;
            font-size: 24px;
        }

        p { color: #666; margin-bottom: 25px; }

        a.button { 
            display: block; 
            margin: 12px 0; 
            padding: 14px; 
            background: var(--col-forest); 
            color: white; 
            text-decoration: none; 
            border-radius: 6px; 
            font-weight: bold;
            transition: all 0.3s;
        }

        a.button:hover { 
            background: var(--col-olive); 
            transform: translateY(-2px);
        }

        a.link { 
            color: var(--col-midnight); 
            text-decoration: none; 
            font-size: 0.9em;
            font-weight: bold;
        }

        a.link:hover { 
            color: var(--col-mint-med); 
            text-decoration: underline; 
        }
    </style>
</head>
<body>
<div class="box">
    <div style="text-align: center; margin-bottom: 20px;">
        <img src="assets/logo.svg" alt="Logo Pronte" width="80" height="80">
    </div>
    <h1>Bienvenue sur Pronte</h1>
    <p>Système de gestion académique</p>
    
    <a class="button" href="login.jsp">Se connecter</a>
    <a class="button" href="sign_up.jsp">S'inscrire</a>
    
    <div style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;">
        <p style="font-size:0.85em; margin-bottom:10px;">Accès Rapides (Dev)</p>
        <div style="display:flex; gap:10px; justify-content:center;">
            <a class="link" href="prof">Professeur</a>
            <span style="color:#ddd;">|</span>
            <a class="link" href="etudiant">Étudiant</a>
        </div>
        <p style="margin-top:10px;"><a class="link" href="hello-servlet" style="color:#999; font-weight:normal;">Test Servlet</a></p>
    </div>
</div>
</body>
</html>