package org.insa.sae;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// Représente la table `module`, juste le nom Module est déjà pris
public class ModuleEntity {
    private int id;
    private String name;
    private int teacherId; // references users(id)

    public ModuleEntity() {}

    public ModuleEntity(int id, String name, int teacherId) {
        this.id = id;
        this.name = name;
        this.teacherId = teacherId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getTeacherId() { return teacherId; }
    public void setTeacherId(int teacherId) { this.teacherId = teacherId; }

    public static ModuleEntity findById(int id) throws SQLException {
        String sql = "SELECT id, name, teacher FROM module WHERE id = ?";
        Connection c = DBConnection.getConnection();
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return fromResultSet(rs);
            }
        }
        return null;
    }

    public static List<ModuleEntity> findAll() throws SQLException {
        String sql = "SELECT id, name, teacher FROM module ORDER BY id";
        List<ModuleEntity> list = new ArrayList<>();
        Connection c = DBConnection.getConnection();
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(fromResultSet(rs));
        }
        return list;
    }

    private static ModuleEntity fromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        int teacherId = rs.getInt("teacher");
        return new ModuleEntity(id, name, teacherId);
    }

    public void save() throws SQLException {
        if (this.id == 0) {
            String sql = "INSERT INTO module (name, teacher) VALUES (?, ?)";
            Connection c = DBConnection.getConnection();
            try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, this.name);
                ps.setInt(2, this.teacherId);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) this.id = keys.getInt(1);
                }
            }
        } else {
            String sql = "UPDATE module SET name = ?, teacher = ? WHERE id = ?";
            Connection c = DBConnection.getConnection();
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, this.name);
                ps.setInt(2, this.teacherId);
                ps.setInt(3, this.id);
                ps.executeUpdate();
            }
        }
    }

    public void delete() throws SQLException {
        if (this.id == 0) return;
        String sql = "DELETE FROM module WHERE id = ?";
        Connection c = DBConnection.getConnection();
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, this.id);
            ps.executeUpdate();
        }
        this.id = 0;
    }
}
