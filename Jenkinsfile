pipeline {
  agent any

  stages {
    stage('build') {
      steps {
        sh 'mvn clean compile -DskipTests=true'
      }
    }

    stage('Unit Tests - JUnit & JaCoCo') {
      steps {
        sh 'mvn test'
        sh 'mvn jacoco:report'
        
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
    stage('dependency-check owasp-scan') {
      steps {
        sh 'mvn -Djava.io.tmpdir=/opt/dependency-check-data/tmp \
        org.owasp:dependency-check-maven:check'
      }
      post {
        always {
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml' 
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
        }/*
        timeout(time: 2, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }*/
      }
    }

    stage('package') {
      steps {
        sh 'mvn package -DskipTests=true'
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
    }

    stage('trivy-scan base-image') {
      steps {
        sh 'bash trivy-base-image-scan.sh'
      }
    }

    stage('opa-scan docker-file-conf') {
      steps {
        sh 'docker run --rm -v \$(pwd):/project openpolicyagent/conftest:v0.24.0 test --policy docker-conf.rego Dockerfile'
      }
    }

    stage('Docker Build') {
      steps {
        withDockerRegistry([credentialsId: 'docker-cred', url: '']) {
          sh 'docker build -t abdelrahmanvio/numeric-application:"$GIT_COMMIT" .'
        }
      }
    }

    stage('trivy-scan dockerized-image') {
      steps {
        sh 'docker run --rm -v $HOME/trivy-cache:/root/.cache/ aquasec/trivy:latest image --severity CRITICAL --exit-code 1 --quiet abdelrahmanvio/numeric-application:"$GIT_COMMIT"'
      }
    }

    stage('Docker push') {
      steps {
        withDockerRegistry([credentialsId: 'docker-cred', url: '']) {
          sh 'docker push abdelrahmanvio/numeric-application:"$GIT_COMMIT"'
        }
      }
    }
    
    /*stage('Kubernetes Deployment - DEV') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh 'sed -i "s#replace#abdelrahmanvio/numeric-application:${GIT_COMMIT}#g" k8s_deployment_service.yaml'
          sh 'kubectl apply -f k8s_deployment_service.yaml'
          sh 'kubectl rollout status deployment/devsecops'
        }
      }
    }*/
  }
}  
