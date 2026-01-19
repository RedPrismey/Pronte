package org.insa.sae;

import io.github.cdimascio.dotenv.Dotenv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBConnection {
    private static Connection conn;
    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        if (conn == null) {
            Dotenv dotenv = Dotenv.load();

            String host = "localhost";
            String port = "5432";
            String db = "postgres";
            String user = dotenv.get("POSTGRES_USER");
            String pass = dotenv.get("POSTGRES_PASSWORD");

            String url = String.format("jdbc:postgresql://%s:%s/%s", host, port, db);
            conn = DriverManager.getConnection(url, user, pass);
        }

        return conn;
    }
}
