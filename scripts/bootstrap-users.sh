#!/usr/bin/env bash
set -euo pipefail

RELEASE_NAME=${1:-postgres}
NAMESPACE=${2:-database}
DB_NAME=${DB_NAME:-app_db}
DB_USER=${DB_USER:-app_user}
PASSWORD_KEY=${PASSWORD_KEY:-POSTGRES_PASSWORD}
CHART_SUFFIX=${CHART_SUFFIX:-postgres-db}
SECRET_NAME=${SECRET_NAME:-"${RELEASE_NAME}-${CHART_SUFFIX}"}

if ! command -v oc >/dev/null 2>&1; then
  echo "oc CLI is required to run this script" >&2
  exit 1
fi

PASSWORD=$(oc -n "$NAMESPACE" get secret "$SECRET_NAME" -o jsonpath="{.data.${PASSWORD_KEY}}" | base64 --decode)
POD=$(oc -n "$NAMESPACE" get pods -l app.kubernetes.io/instance="$RELEASE_NAME" -o jsonpath='{.items[0].metadata.name}')

cat <<'SQL' | oc -n "$NAMESPACE" exec -i "$POD" -- env PGPASSWORD="$PASSWORD" psql -U "$DB_USER" "$DB_NAME"
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO users (username) VALUES
  ('Liam Rivera'),
  ('Mateo Lopez'),
  ('Sofia Ramirez'),
  ('Valentina Torres'),
  ('Sebastian Cruz'),
  ('Isabella Flores'),
  ('Camila Morales'),
  ('Diego Herrera'),
  ('Lucia Vargas'),
  ('Santiago Castillo'),
  ('Emilia Navarro'),
  ('Benjamin Ortega'),
  ('Emma Alvarez'),
  ('Thiago Serrano'),
  ('Mia Fuentes'),
  ('Daniela Mendez'),
  ('Julian Cardenas'),
  ('Victoria Salazar'),
  ('Gabriel Correa'),
  ('Martina Rios'),
  ('Andres Molina'),
  ('Antonella Suarez'),
  ('Samuel Cabrera'),
  ('Renata Valdez'),
  ('Aaron Bustos'),
  ('Elena Fajardo'),
  ('Adrian Becerra'),
  ('Laura Quinones'),
  ('Gael Zamora'),
  ('Sara Barrios'),
  ('Joaquin Tovar'),
  ('Paula Aranda'),
  ('Nicolas Godoy'),
  ('Josefina Meza'),
  ('Angel Pineda'),
  ('Catalina Esquivel'),
  ('Bruno Salas'),
  ('Alexa Buitrago'),
  ('Ian Santamaria'),
  ('Mariana Ibarra'),
  ('Maximiliano Olmos'),
  ('Paloma Galvez'),
  ('Emilio Cordova'),
  ('Noa Lucero'),
  ('Raul Pizarro'),
  ('Abril Manrique'),
  ('Damian Acosta'),
  ('Alma Beltran'),
  ('Hector Sarmiento'),
  ('Zoe Chamorro')
ON CONFLICT (username) DO NOTHING;
SQL
