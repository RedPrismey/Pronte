package org.insa.sae;
import java.sql.*;

public class Specialty {
    private int id;
    private String name;

    public Specialty() {}

    public Specialty(String name) {
        this.name = name;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    // Active Record Methods
    public void save() throws SQLException {
        String sql = "INSERT INTO specialties (name) VALUES (?) RETURNING id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, this.name);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) this.id = rs.getInt(1);
        }
    }

    public static Specialty findById(int id) throws SQLException {
        String sql = "SELECT * FROM specialties WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Specialty s = new Specialty();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                return s;
            }
        }
        return null;
    }
}
