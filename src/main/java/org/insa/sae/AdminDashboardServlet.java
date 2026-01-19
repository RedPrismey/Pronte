package org.insa.sae;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/admin")
public class AdminDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (role == null || !role.equals("Admin")) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // List<Etudiant> listeEtudiants = Etudiant.findAll();
            // List<Module> listeModules = Module.findAll();
            
            // request.setAttribute("listeEtudiants", listeEtudiants);
            // request.setAttribute("listeModules", listeModules);

        } catch (Exception e) {
            e.printStackTrace();
        }

    
        String filtreSpecialite = request.getParameter("filtreSpecialite");
        if(filtreSpecialite != null) {
            // List<Etudiant> etudiantsFiltres = Etudiant.findBySpecialite(filtreSpecialite);
            // request.setAttribute("resultatFiltre", etudiantsFiltres);
            request.setAttribute("filtreActif", filtreSpecialite);
        }

        request.getRequestDispatcher("WEB-INF/admin_dashboard.jsp").forward(request, response);
    }
}