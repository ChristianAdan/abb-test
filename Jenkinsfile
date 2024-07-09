pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo "Display test.txt"
        bash '''
            #!/bin/bash
            cat test.txt
         ''' 
      }
    }
  }
}
