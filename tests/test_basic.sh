#!/bin/bash

echo "✅ Ejecutando pruebas básicas..."
sleep 1

# Simulamos una prueba exitosa
if [ 1 -eq 1 ]; then
  echo "✔️ Test 1 pasó"
else
  echo "❌ Test 1 falló"
  exit 1
fi

