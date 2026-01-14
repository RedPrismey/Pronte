6 Pages JSP à faire (admin,prof,étudiant,login,deconnection,sign up): 

### Admin :

- Inscrire un étudiant dans une spécialité via un formulaire permettant de sélection un étudiant puis d'entrer sa spécialité et son numéro INE

- Saisir la note d’un étudiant à l’aide d’un formulaire permettant de renseigner son nom, son prénom, l’intitulé du module ainsi que la note obtenue dans ce module.

- Afficher la liste des étudiants par spécialité.

- Afficher les notes des étudiants pour un module donné.

- Permettre la consultation des résultats des évaluations des modules et de la spécialité.

### Prof :

- Consulter les notes des modules dont il a la charge.

- Consulter les notes des modules dont il a la charge.

### Edudiant :

- S’authentifier dans l’application.

- Accéder à ses notes par semestre et par module.

- Evaluer les modules suivis au cours d’un semestre, en lui proposant différents critères d’évaluation (qualité des supports pédagogiques, qualité de l’équipe pédagogique,
temps consacré aux activités liées au module), ainsi qu’un champ de commentaire libre.

### Login : 

- Entrer un username et un mdp

### Deconnection  :

- Retour vers page de LOG

### Sign Up:

- Username, MDP, nom, prenom, role

Table User (IDUser, username, mdp, role,nom,prenom), Etudiant(IDEtudiant, Numero_INE,specialite, #IDInscription), Module(IDModule, nom, #IDUser),Notes(IDNote,Note,#IDEtudiant,#IDModule)

Créer Servlet et relier le tout
