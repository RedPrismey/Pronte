CREATE TYPE role AS ENUM ('student', 'teacher', 'admin');

CREATE TABLE IF NOT EXISTS specialties (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role role NOT NULL,
  name VARCHAR(255) NOT NULL,
  surname VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS inscriptions (
  id SERIAL PRIMARY KEY,
  id_student INTEGER REFERENCES users(id) NOT NULL,
  INE VARCHAR(255) UNIQUE NOT NULL,
  id_specialty INTEGER REFERENCES specialties(id) NOT NULL
);

CREATE TABLE IF NOT EXISTS module (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  teacher INTEGER REFERENCES users(id) NOT NULL
);

CREATE TABLE IF NOT EXISTS notes (
  id SERIAL PRIMARY KEY,
  note INTEGER NOT NULL,
  id_student INTEGER REFERENCES users(id) NOT NULL,
  id_module INTEGER REFERENCES module(id) NOT NULL
);

CREATE TABLE IF NOT EXISTS evaluations (
  id SERIAL PRIMARY KEY,
  id_module INTEGER REFERENCES module(id) NOT NULL,
  id_student INTEGER REFERENCES users(id) NOT NULL,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS evaluation_criteria (
  id SERIAL PRIMARY KEY,
  id_module INTEGER REFERENCES module(id) NOT NULL,
  criterion_name VARCHAR(255) NOT NULL,
  average_rating DECIMAL(3, 2)
);
