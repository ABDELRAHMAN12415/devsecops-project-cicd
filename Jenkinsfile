pipeline {
  agent {
        docker {
            image 'maven:3.8.7-openjdk-17'
            args '-v /root/.m2:/root/.m2'
        }
  }

  stages {
    stage('Checkout1') {
      steps {
        git branch: 'main', url: 'https://github.com/ABDELRAHMAN12415/devsecops-project-cicd'
      }
    }
    stage('build') {
      steps {
        sh 'mvn clean package -DskipTests=true'
      }
    }
    stage('Unit Tests - JUnit & JaCoCo') {
      steps {
        sh 'mvn test'
        sh 'mvn jacoco:report'
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
      post {
        always {
          junit '**/target/surefire-reports/*.xml'
          jacoco(
            execPattern: '**/target/jacoco.exec',
            classPattern: '**/target/classes',
            sourcePattern: '**/src/main/java',
            inclusionPattern: '**/*.class',
            exclusionPattern: ''
          )
        }
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
    stage('Code Quality - SonarQube') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh 'mvn sonar:sonar -Dsonar.projectKey=numeric-application'
        }
      }
      post {
        always {
          waitForQualityGate abortPipeline: true
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
    stage('Kubernetes Deployment - DEV') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh 'sed -i "s#replace#abdelrahmanvio/numeric-application:${GIT_COMMIT}#g" k8s_deployment_service.yaml'
          sh 'kubectl apply -f k8s_deployment_service.yaml'
          sh 'kubectl rollout status deployment/devsecops'
        }
      }
    }
  }
}  
