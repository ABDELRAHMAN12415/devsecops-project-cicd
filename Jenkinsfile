pipeline {
  agent any

  stages {
    stage('build') {
      steps {
        sh 'mvn build -DskipTests'
      }
    }
    stage('Unit Tests - JUnit and JaCoCo') {
      steps {
        sh 'mvn test'
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
      }
    }
  }
}
