package org.insa.sae;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.insa.sae.Inscription;
import org.insa.sae.ModuleEntity;
import org.insa.sae.Note;
import org.insa.sae.Specialty;
import org.insa.sae.User;

/**
 * Servlet implementation class GenererBulletinServlet
 */
@WebServlet("/GenererBulletinServlet")
public class GenererBulletinServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GenererBulletinServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		String studentIdStr = request.getParameter("id");
		if (studentIdStr == null || studentIdStr.isEmpty()) {
			response.sendError(400,"ID étudiant manquant");
			return;
		}
		
		try {
			int studentId = Integer.parseInt(studentIdStr);
			
			//Regarde si l'etudiant existe
			User etudiant = User.findById(studentId);
			if (etudiant == null) {
				response.sendError(404, "Etudiant non trouvé");
				return;
			}
			
			//Recupere toutes ses notes de modules 
			List<Map<String,Object>> notesModules = getNotesModules(studentId);
			
			//Moyenne generale
			double moy = calculerMoyenne(notesModules);
			
			Inscription inscription = getInscription(studentId);
			String specialite ="";
			if (inscription != null) {
				Specialty spec = Specialty.findById(inscription.getSpecialtyId());
				if (spec != null) {
					specialite = spec.getName();
				}
			}
			
			request.setAttribute("etudiant", etudiant);
			request.setAttribute("notes", notesModules);
			request.setAttribute("moyenne", String.format("%.2f", moy));
			request.setAttribute("specialite", specialite);
			request.setAttribute("dateGeneration", new java.util.Date());
			
			request.getRequestDispatcher("/bulletinEtudiant.jsp").forward(request, response);
		}catch(NumberFormatException e) {
			response.sendError(400,"ID invalide");
		}catch(SQLException e) {
			e.printStackTrace();
			response.sendError(500,"Erreur DB");
		}
	}

	private List<Map<String,Object>> getNotesModules(int studentId) throws SQLException{
		List<Map<String,Object>> result = new ArrayList<>();
		List<Note> notes = Note.findAll();
		for (Note n: notes) {
			if (n.getStudentId() == studentId) {
				Map<String,Object> notedetail = new HashMap<>();
				notedetail.put("id", n.getId());
				notedetail.put("valeur", n.getNote());
				ModuleEntity module = ModuleEntity.findById(n.getModuleId());
				if (module != null) {
					notedetail.put("moduleId", module.getId());
					notedetail.put("module", module.getName());
					User enseignant = User.findById(module.getTeacherId());
					if (enseignant != null) {
						notedetail.put("enseignant", enseignant.getSurname() + " " + enseignant.getName());
					}
				}else {
					notedetail.put("module", "module inconnu");
				}
				result.add(notedetail);
			}
		}
		return result;
	}
	
	private double calculerMoyenne(List<Map<String,Object>> notes) {
		if (notes.isEmpty()) return 0.0;
		double somme = 0;
		int nbr_note = 0;
		for (Map<String,Object> note : notes) {
			double valeur = (double) note.get("valeur");
			somme += valeur;
			nbr_note += 1;
		}
		return somme/nbr_note;
	}
	
	private Inscription getInscription(int studentId) throws SQLException{
		List<Inscription> inscription = Inscription.findAll();
		for (Inscription ins : inscription) {
			if (ins.getStudentId() == studentId) {
				return ins;
			}
		}
		return null;	
	}
	
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */

}
