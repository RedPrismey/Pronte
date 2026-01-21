<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pronte - Accueil</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f6fb; display:flex; align-items:center; justify-content:center; height:100vh; }
        .box { background:white; padding:30px; border-radius:8px; box-shadow:0 2px 12px rgba(0,0,0,0.06); width:360px; text-align:center; }
        a.button { display:block; margin:8px 0; padding:10px; background:#0056b3; color:white; text-decoration:none; border-radius:4px; }
        a.link { color:#0056b3; text-decoration:none; }
    </style>
</head>
<body>
<div class="box">
    <h1>Bienvenue sur Pronte</h1>
    <p>Accédez rapidement :</p>
    <a class="button" href="login.jsp">Se connecter</a>
    <a class="button" href="signup.jsp">S'inscrire</a>
    <a class="button" href="prof">Espace Professeur</a>
    <a class="button" href="etudiant">Espace Étudiant</a>
    <p style="margin-top:12px;"><a class="link" href="hello-servlet">Hello Servlet</a></p>
</div>
</body>
</html>