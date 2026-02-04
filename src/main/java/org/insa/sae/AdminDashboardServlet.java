package org.insa.sae;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");

        try {
            if ("createEtudiant".equals(action)) {
               
                String usernameCible = request.getParameter("usernameEtudiant");
                String ine = request.getParameter("ine");
                
               
                int specialtyId = Integer.parseInt(request.getParameter("specialtyId"));

                
                User etudiant = User.findByUsername(usernameCible);
                if (etudiant == null) {
                    throw new Exception("Erreur : Utilisateur introuvable.");
                }

                
                Inscription inscription = new Inscription(0, etudiant.getId(), ine, specialtyId);
                inscription.save();
                
                request.setAttribute("message", "Inscription validée pour " + etudiant.getName() + " " + etudiant.getSurname());

            } else if ("addNote".equals(action)) {
               
                int idEtudiant = Integer.parseInt(request.getParameter("idEtudiant"));
                int idModule = Integer.parseInt(request.getParameter("idModule"));
                float valeur = Float.parseFloat(request.getParameter("valeur"));
                String type = request.getParameter("typeNote");
                Double coef = (double) Float.parseFloat(request.getParameter("coef"));


               
                Note note = new Note(0, valeur,type,coef ,idEtudiant, idModule);
                note.save();

                request.setAttribute("message", "Note enregistrée avec succès !");
            }
                else if ("createSpecialty".equals(action)) {
        
                String nomSpecialite = request.getParameter("nomSpecialite");
                
                if (nomSpecialite != null && !nomSpecialite.trim().isEmpty()) {
                    Specialty spe = new Specialty(0, nomSpecialite.trim());
                    spe.save(); 
                    request.setAttribute("message", "Spécialité '" + nomSpecialite + "' ajoutée avec succès.");
                } else {
                    throw new Exception("Le nom de la spécialité ne peut pas être vide.");
                }
        }
         else if ("createModule".equals(action)) {
        
        String moduleName = request.getParameter("moduleName");
        int teacherId = Integer.parseInt(request.getParameter("teacherId"));
        
        
        ModuleEntity nouveauModule = new ModuleEntity(0, moduleName, teacherId);
        nouveauModule.save(); 
    
        
        String[] specialtyIds = request.getParameterValues("specialtyIds");
        
        if (specialtyIds != null) {
            
            int newModuleId = nouveauModule.getId(); 
            
            Connection c = DBConnection.getConnection();
                String sql = "INSERT INTO specialty_modules (id_module, id_specialty) VALUES (?, ?)";
                try (PreparedStatement ps = c.prepareStatement(sql)) {
                    for(String s : specialtyIds){
                    ps.setInt(1, newModuleId);
                    ps.setInt(2, Integer.parseInt(s));
                    ps.executeUpdate();
                }}
            c.close();
            }
        
    
        request.setAttribute("message", "Module '" + moduleName + "' créé et associé aux spécialités !");
    }else if ("delete".equals(action)) {
        String type = request.getParameter("type");
        int id = Integer.parseInt(request.getParameter("id"));
    
        if ("user".equals(type)) { 
            User u = User.findById(id);
            if (u != null) {
                u.delete(); 
                request.setAttribute("message", "Utilisateur (et ses données associées) supprimé avec succès.");
            }
        } 
        else if ("module".equals(type)) {
            ModuleEntity m = ModuleEntity.findById(id);
            if (m != null) {
                m.delete();
                request.setAttribute("message", "Module supprimé.");
            }
        }
        else if ("note".equals(type)) {
            Note n = Note.findById(id);
            if (n != null) {
                n.delete(); 
                request.setAttribute("message", "Note supprimée.");
            }
        }
    }

        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
          
            if (errorMsg != null && errorMsg.contains("duplicate key")) {
                errorMsg = "Cet étudiant ou ce numéro INE est déjà inscrit.";
            }
            request.setAttribute("message", "Erreur : " + errorMsg);
        }

       
        doGet(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        User loggedUser = null;

        try {
            if (userObj instanceof User) {
                loggedUser = (User) userObj;
            } else if (userObj instanceof String) {
                loggedUser = User.findByUsername((String) userObj);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (loggedUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            
            List<User> allUsers = User.findAll();
            List<ModuleEntity> listeModules = ModuleEntity.findAll();
            List<Specialty> listeSpecialites = Specialty.findAll(); 
            List<Inscription> inscriptions = Inscription.findAll();
            List<User> listeProfs = allUsers.stream()
            .filter(u -> u.getRole() == Role.teacher)
            .collect(Collectors.toList());


            List<User> tousLesEtudiants = allUsers.stream()
                .filter(u -> u.getRole() == Role.student)
                .collect(Collectors.toList());

            List<Integer> idsEtudiantsInscrits = inscriptions.stream()
                .map(Inscription::getStudentId)
                .collect(Collectors.toList());

            List<User> etudiantsNonInscrits = tousLesEtudiants.stream()
                .filter(u -> !idsEtudiantsInscrits.contains(u.getId()))
                .collect(Collectors.toList());
            
            List<User> etudiantsInscrits = tousLesEtudiants.stream()
                .filter(u -> idsEtudiantsInscrits.contains(u.getId()))
                .collect(Collectors.toList());
            
            String filterSpecIdStr = request.getParameter("filterSpecId");
            String[] filterModuleIdsStr = request.getParameterValues("filterModuleIds");
            String sortType = request.getParameter("sortType");


            List<Map<String, Object>> resultatsNotes = new ArrayList<>();

           
            if (filterSpecIdStr != null && !filterSpecIdStr.isEmpty()) {
                int specId = Integer.parseInt(filterSpecIdStr);
                
               
                List<Integer> studentIdsInSpec = inscriptions.stream()
                    .filter(i -> i.getSpecialtyId() == specId)
                    .map(Inscription::getStudentId)
                    .collect(Collectors.toList());

              
                List<Note> allNotes = Note.findAll();

               
                for (Note n : allNotes) {
                   
                    if (studentIdsInSpec.contains(n.getStudentId())) {
                        
                       
                        boolean moduleMatch = true;
                        if (filterModuleIdsStr != null && filterModuleIdsStr.length > 0) {
                            moduleMatch = false;
                            for (String mId : filterModuleIdsStr) {
                                if (Integer.parseInt(mId) == n.getModuleId()) {
                                    moduleMatch = true;
                                    break;
                                }
                            }
                        }

                        if (moduleMatch) {
                           
                            Map<String, Object> row = new HashMap<>();
                            
                            User etu = User.findById(n.getStudentId());
                            ModuleEntity mod = ModuleEntity.findById(n.getModuleId());
                            
                            if (etu != null && mod != null) {
                                row.put("id", n.getId());
                                row.put("nom", etu.getSurname());
                                row.put("prenom", etu.getName());
                                row.put("module", mod.getName());
                                row.put("note", n.getNote());
                                row.put("coef", n.getCoef());
                                resultatsNotes.add(row);
                            }
                        }
                    }
                }
            }

            
            if (sortType != null) {
                switch (sortType) {
                    case "name_asc":
                        resultatsNotes.sort((m1, m2) -> ((String)m1.get("nom")).compareToIgnoreCase((String)m2.get("nom")));
                        break;
                    case "name_desc":
                        resultatsNotes.sort((m1, m2) -> ((String)m2.get("nom")).compareToIgnoreCase((String)m1.get("nom")));
                        break;
                    case "note_asc":
                        resultatsNotes.sort((m1, m2) -> Float.compare((float)m1.get("note"), (float)m2.get("note")));
                        break;
                    case "note_desc":
                        resultatsNotes.sort((m1, m2) -> Float.compare((float)m2.get("note"), (float)m1.get("note")));
                        break;
                }
            }

           
            request.setAttribute("resultatsNotes", resultatsNotes);
            
         
            request.setAttribute("selectedSpecId", filterSpecIdStr);
            request.setAttribute("selectedSort", sortType);
           
            List<Integer> selectedModules = new ArrayList<>();
            if (filterModuleIdsStr != null) {
                for(String s : filterModuleIdsStr) selectedModules.add(Integer.parseInt(s));
            }
            request.setAttribute("selectedModules", selectedModules);


            Map<Integer, String> mapIne = new HashMap<>();
            Map<Integer, String> mapSpecialiteName = new HashMap<>();
            
            
            for (Inscription i : inscriptions) {
                mapIne.put(i.getStudentId(), i.getIne());
                
                
                String nomSpe = listeSpecialites.stream()
                    .filter(s -> s.getId() == i.getSpecialtyId())
                    .map(Specialty::getName)
                    .findFirst()
                    .orElse("Inconnu");
                mapSpecialiteName.put(i.getStudentId(), nomSpe);
            }
            String filtreSpecialite = request.getParameter("filtreSpecialite");
            if (filtreSpecialite != null && !filtreSpecialite.isEmpty() && !filtreSpecialite.equals("all")) {
                etudiantsInscrits = etudiantsInscrits.stream()
                    .filter(u -> {
                        String userSpecName = mapSpecialiteName.get(u.getId());
                        return userSpecName != null && userSpecName.equalsIgnoreCase(filtreSpecialite);
                    })
                    .collect(Collectors.toList());
                request.setAttribute("filtreActif", filtreSpecialite);
            }

            
            request.setAttribute("listeModules", listeModules);
            request.setAttribute("listeSpecialites", listeSpecialites);
            request.setAttribute("etudiantsNonInscrits", etudiantsNonInscrits);
            request.setAttribute("etudiantsInscrits", etudiantsInscrits);
            request.setAttribute("mapIne", mapIne);
            request.setAttribute("mapSpecialiteName", mapSpecialiteName);
            request.setAttribute("listeProfs", listeProfs);

            for (Inscription i : inscriptions) {
                mapIne.put(i.getStudentId(), i.getIne());
                String nomSpe = listeSpecialites.stream()
                    .filter(s -> s.getId() == i.getSpecialtyId())
                    .map(Specialty::getName)
                    .findFirst().orElse("Inconnu");
                mapSpecialiteName.put(i.getStudentId(), nomSpe);
            }
            request.setAttribute("mapIne", mapIne);
            request.setAttribute("mapSpecialiteName", mapSpecialiteName);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Erreur lors du chargement des données : " + e.getMessage());
        }

        request.getRequestDispatcher("WEB-INF/admin_dashboard.jsp").forward(request, response);
    }
}