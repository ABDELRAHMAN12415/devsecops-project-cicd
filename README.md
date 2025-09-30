
Numeric Application – DevSecOps CI/CD Pipeline 🚀🔐
📌 Overview

This project is a sample Spring Boot + Node.js numeric application that demonstrates how to implement a complete DevSecOps CI/CD pipeline using Jenkins.
The pipeline automates build, test, security scanning, containerization, deployment to Kubernetes, and runtime security testing.

![untitleddiagram drawio(7)_25e44115](https://github.com/user-attachments/assets/eca45232-e9a1-4657-adfa-fc3e3c3586a5)

⚙️ Features

Build & Test

Maven build, unit tests (JUnit), and code coverage (JaCoCo).

Mutation testing with PIT for test robustness.

Static Security

OWASP Dependency-Check for vulnerable libraries.

SonarQube analysis with quality gates.

OPA (Conftest) for Dockerfile & Kubernetes manifest policies.

Container Security

Trivy scan for base image vulnerabilities.

Trivy scan for built Docker images before push.

Continuous Delivery

Docker build, tag, and push to Docker Hub.

Kubernetes deployment using kubectl.

Smoke testing to verify application availability.

Dynamic Security

OWASP ZAP (DAST) to detect runtime vulnerabilities.

HTML report publishing in Jenkins.

📂 Project Structure
devsecops-project/
├── src/                           # Application source code
├── target/                        # Build outputs
├── Dockerfile                     # Container image definition
├── k8s_deployment_service.yaml    # Kubernetes deployment manifest
├── trivy-base-image-scan.sh       # Trivy script for base image
├── zap-scan.sh                    # OWASP ZAP DAST scan script
├── docker-conf.rego               # OPA policy for Dockerfile
├── k8s-deployment-security.rego   # OPA policy for K8s manifest
├── smoke-test.sh                  # Post-deployment smoke tests
├── pom.xml                        # Maven project descriptor
└── Jenkinsfile                    # CI/CD pipeline definition

🛠️ Prerequisites

Jenkins with plugins:

Pipeline

OWASP Dependency-Check

JUnit

JaCoCo

PIT Mutation Testing

SonarQube

HTML Publisher

Docker & Kubernetes plugins

Tools

Docker & Docker Hub account

Kubernetes cluster (Minikube, EKS, AKS, or GKE)

SonarQube server

Trivy

OWASP ZAP

OPA Conftest

🔄 Jenkins Pipeline Stages

Build – Maven clean & compile.

Unit Tests – Run JUnit tests & collect JaCoCo coverage.

Dependency Scan – OWASP Dependency-Check.

Mutation Testing – PIT reports.

Code Quality – SonarQube analysis.

Package – Build JAR artifact.

Trivy Base Scan – Check vulnerabilities in base image.

OPA Dockerfile Scan – Policy validation on Dockerfile.

Docker Build & Tag – Build image tagged with commit SHA.

Trivy Image Scan – Vulnerability scan on built image.

Docker Push – Push to Docker Hub.

OPA K8s Scan – Validate deployment YAML.

Kubernetes Deploy – Apply manifest & rollout.

Smoke Test – Verify API responses.

OWASP ZAP DAST – Run API security scan & publish report.

Notify – (Optional) Slack notifications on pipeline result.

🚀 Usage
Build & Run Locally
# Compile and package the application
mvn clean package -DskipTests=true

# Build Docker image
docker build -t abdelrahmanvio/numeric-application:latest .

# Run locally
docker run -p 5000:5000 abdelrahmanvio/numeric-application:latest

Deploy on Kubernetes
# Replace image placeholder with your Docker Hub image
sed -i "s#replace#abdelrahmanvio/numeric-application:latest#g" k8s_deployment_service.yaml

# Apply manifest
kubectl apply -f k8s_deployment_service.yaml

# Check status
kubectl rollout status deployment/devsecops

📊 Reports & Results

JUnit → Test results in Jenkins.

JaCoCo → Code coverage report.

Dependency-Check → Vulnerable dependencies.

PIT → Mutation testing results.

SonarQube → Code quality dashboard.

Trivy → Vulnerability scan logs.

OPA → Policy compliance results.

OWASP ZAP → DAST HTML report (published in Jenkins).

🔐 Security Practices

Fail build on critical/high vulnerabilities.

Enforce OPA security policies.

Publish all security reports in Jenkins.

Automate scans in every pipeline run.

📌 Future Enhancements

Add Prometheus + Grafana for monitoring.

Extend ZAP scans with authenticated tests.

Implement ArgoCD for GitOps-style deployments.

Add SAST (e.g., Semgrep) for deeper static analysis.

👨‍💻 Author

Abdelrahman Ahmed
