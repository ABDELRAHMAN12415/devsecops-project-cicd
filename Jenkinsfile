pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh 'mvn compile -DskipTests=true'
      }
    }
    stage('Unit Tests - JUnit & JaCoCo') {
      steps {
        sh 'mvn clean test'
        sh 'mvn jacoco:report'
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
    }
    stage('Mutation Tests - PIT') {
      steps {
        sh 'mvn org.pitest:pitest-maven:mutationCoverage'
      }
      post {
        always {
          pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        }
      }
    }
    stage('Docker Build & Push') {
      steps {
        withDockerRegistry([credentialsId: 'docker', url: '']) {
          sh 'docker build -t abdelrahmanvio/numeric-application:"$GIT_COMMIT" .'
          sh 'docker push abdelrahmanvio/numeric-application:"$GIT_COMMIT"'
        }
      }
    }
    /*stage('Kubernetes Deployment - DEV') {
      steps {
        // Deployment steps
      }
    } */
  }
}