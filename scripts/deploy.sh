#!/bin/bash
echo "🚀 Desplegando entorno para la rama: $DEPLOY_ENV"

if [[ "$DEPLOY_ENV" == "dev" ]]; then
  echo "Entorno: Desarrollo 🛠️"
elif [[ "$DEPLOY_ENV" == "qa" ]]; then
  echo "Entorno: QA ��"
elif [[ "$DEPLOY_ENV" == "main" ]]; then
  echo "Entorno: Producción 🚨"
else
  echo "Rama no reconocida para despliegue."
fi

