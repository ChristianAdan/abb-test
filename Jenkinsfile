pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo "Display test.txt"
        sh '''
            #!/bin/bash
            cat test.txt
         ''' 
      }
    }
  }
}
