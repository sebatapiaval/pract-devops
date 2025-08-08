// Jenkinsfile
pipeline {
  agent any
  options { timestamps() }

  // Disparo del pipeline: deja el polling o cambia a githubPush() si configuras webhooks
  triggers { pollSCM('H/2 * * * *') }
  // triggers { githubPush() }

  environment {
    REPO_URL = 'https://github.com/sebatapiaval/pract-devops.git'
    CRED_ID  = 'github-user-token'   // credencial "Username with password" (usuario + PAT)
  }

  stages {
    stage('Checkout') {
      steps {
        echo "Clonando repo..."
        git branch: 'main', url: "${env.REPO_URL}", credentialsId: env.CRED_ID
        sh 'ls -la'
      }
    }

    stage('Validaciones básicas') {
      steps {
        sh '''
          set -euo pipefail

          # === Reglas sobre archivos .txt ===
          # 1) No contener la palabra "FAIL"
          # 2) No tener líneas > 120 caracteres
          TXT_FILES="$(find . -type f -name "*.txt" | sort || true)"

          if [ -n "$TXT_FILES" ]; then
            grep -RIn "FAIL" $TXT_FILES > .fail_grep || true
            awk '\''length($0)>120 {print FILENAME ":" FNR " → " length($0)}'\'' $TXT_FILES > .long_lines || true
          fi

          # === Prohibir archivos .exe en el repo ===
          EXE_FILES="$(find . -type f -name "*.exe" | sort || true)"
          if [ -n "$EXE_FILES" ]; then
            echo "Se encontraron archivos .exe:"
            echo "$EXE_FILES"
            echo "BIN" > .val_fail
          fi

          # Si hubo incidencias en .txt, marcar fallo
          if [ -s .fail_grep ] || [ -s .long_lines ]; then
            echo "Incumplimientos en .txt (FAIL o líneas >120)"
            echo "TXT" > .val_fail
          fi
        '''
      }
    }

    stage('Tests (reporte JUnit)') {
      steps {
        sh '''
          set -euo pipefail
          FAILURES=0
          MSG=""

          if [ -f .val_fail ]; then
            FAILURES=1
            MSG="<failure message=\\"Se violaron reglas de validación\\">Revisa consola: .exe presentes, 'FAIL' en .txt o líneas >120.</failure>"
          fi

          cat > test-results.xml <<XML
<testsuite name="repoChecks" tests="1" failures="${FAILURES}">
  <testcase classname="repo" name="validaciones_basicas">
    ${MSG}
  </testcase>
</testsuite>
XML
        '''
        junit 'test-results.xml'   // Muestra el resultado como test en Jenkins
      }
    }
  }

  post {
    always {
      // Guarda evidencia del build
      archiveArtifacts artifacts: '**/*.txt, **/*.exe, test-results.xml', fingerprint: true
      echo 'Pipeline terminado.'
    }
  }
}
