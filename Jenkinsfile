// Jenkinsfile
pipeline {
  agent any
  options { timestamps() }
  triggers { pollSCM('H/2 * * * *') } // revisa cambios cada ~2 min

  environment {
    REPO_URL = 'https://github.com/sebatapiaval/pract-devops.git'
    CRED_ID  = 'github-user-token'   // tu credencial "Username with password"
  }

  stages {
    stage('Checkout') {
      steps {
        echo "Clonando repo..."
        git branch: 'main', url: "${env.REPO_URL}", credentialsId: env.CRED_ID
        sh 'ls -la'
      }
    }

    stage('Validaciones básicas de .txt') {
      steps {
        sh '''
          # Busca .txt y aplica 2 reglas:
          # 1) No contener la palabra "FAIL"
          # 2) No tener líneas > 120 caracteres
          TXT_FILES="$(find . -type f -name "*.txt")"
          if [ -z "$TXT_FILES" ]; then
            echo "No hay .txt — nada que validar"
            exit 0
          fi

          grep -RIn "FAIL" $TXT_FILES > .fail_grep || true
          awk '\''length($0)>120 {print FILENAME ":" FNR " → " length($0)}'\'' $TXT_FILES > .long_lines || true

          if [ -s .fail_grep ] || [ -s .long_lines ]; then
            echo "Se incumplieron reglas"
            echo "FAIL" > .val_fail
          fi
        '''
      }
    }

    stage('Tests (reporte JUnit)') {
      steps {
        sh '''
          FAILURES=0
          MSGS=""
          if [ -f .val_fail ]; then
            FAILURES=1
            MSGS="<failure message=\\"Validaciones de .txt fallaron\\">Revisa consola: grep FAIL o líneas >120</failure>"
          fi

          cat > test-results.xml <<XML
<testsuite name="textChecks" tests="1" failures="${FAILURES}">
  <testcase classname="repo" name="validacion_txt">
    ${MSGS}
  </testcase>
</testsuite>
XML
        '''
        junit 'test-results.xml'   // Verás el test en Jenkins (verde/rojo)
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: '**/*.txt, test-results.xml', fingerprint: true
      echo 'Pipeline terminado.'
    }
  }
}

