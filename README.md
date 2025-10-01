# Numeric Application – DevSecOps CI/CD Pipeline 🚀🔐

![untitleddiagram drawio(7)_25e44115](https://github.com/user-attachments/assets/26778b47-594f-464f-a4ba-2dc0799e42bd)


## 📌 Overview

This project is a sample **Spring Boot + Node.js numeric application** that demonstrates how to implement a **complete DevSecOps CI/CD pipeline** using Jenkins.
The pipeline automates build, test, security scanning, containerization, deployment to Kubernetes, and runtime security testing.

---

## ⚙️ Features

* **Git Pre-Commit Hook: Talisman**
  
  * to block secrets/keys from being committed
 
* **Build & Test**

  * Maven build, unit tests (JUnit), and code coverage (JaCoCo).
  * Mutation testing with PIT for test robustness.

* **Static Security**

  * OWASP Dependency-Check for vulnerable libraries.
  * SonarQube analysis with quality gates.
  * OPA (Conftest) for Dockerfile & Kubernetes manifest policies.

* **Container Security**

  * Trivy scan for base image vulnerabilities.
  * Trivy scan for built Docker images before push.

* **Continuous Delivery**

  * Docker build, tag, and push to Docker Hub.
  * Kubernetes deployment using `kubectl`.
  * Smoke testing to verify application availability.

* **Dynamic Security**

  * OWASP ZAP (DAST) to detect runtime vulnerabilities.
  * HTML report publishing in Jenkins.

---

## 📂 Project Structure

```
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
```

---

## 🛠️ Prerequisites

* **Jenkins** with plugins:

  * Pipeline
  * OWASP Dependency-Check
  * JUnit
  * JaCoCo
  * PIT Mutation Testing
  * SonarQube
  * HTML Publisher
  * Docker & Kubernetes plugins
* **Tools**

  * Docker & Docker Hub account
  * Kubernetes cluster (Minikube, EKS, AKS, or GKE)
  * SonarQube server
  * Trivy
  * OWASP ZAP
  * OPA Conftest
  * 

---

## 🔄 Jenkins Pipeline Stages

1. **Build** – Maven clean & compile.
2. **Unit Tests** – Run JUnit tests & collect JaCoCo coverage.
3. **Dependency Scan** – OWASP Dependency-Check.
4. **Mutation Testing** – PIT reports.
5. **Code Quality** – SonarQube analysis.
6. **Package** – Build JAR artifact.
7. **Trivy Base Scan** – Check vulnerabilities in base image.
8. **OPA Dockerfile Scan** – Policy validation on Dockerfile.
9. **Docker Build & Tag** – Build image tagged with commit SHA.
10. **Trivy Image Scan** – Vulnerability scan on built image.
11. **Docker Push** – Push to Docker Hub.
12. **OPA K8s Scan** – Validate deployment YAML.
13. **Kubernetes Deploy** – Apply manifest & rollout.
14. **Smoke Test** – Verify API responses.
15. **OWASP ZAP DAST** – Run API security scan & publish report.
16. **Notify** – (Optional) Slack notifications on pipeline result.

---

## 🔒 Git Pre-Commit Hook with Talisman

To prevent committing secrets/keys accidentally, **Talisman** is configured as a Git pre-push hook:

```bash
# Install Talisman
curl -L https://github.com/thoughtworks/talisman/releases/latest/download/talisman_linux_amd64 -o talisman
chmod +x talisman
sudo mv talisman /usr/local/bin/

# Add as a pre-push hook
talisman --install
```

Now, before every `git push`, Talisman scans the changes and blocks anything that looks like **secrets, tokens, or credentials**.

To bypass in special cases:

```bash
git push --no-verify
```

> ⚠️ Not recommended unless you’re 100% sure.

---

## 📊 Reports & Results

* **JUnit** → Test results in Jenkins.
* **JaCoCo** → Code coverage report.
* **Dependency-Check** → Vulnerable dependencies.
* **PIT** → Mutation testing results.
* **SonarQube** → Code quality dashboard.
* **Trivy** → Vulnerability scan logs.
* **OPA** → Policy compliance results.
* **OWASP ZAP** → DAST HTML report (published in Jenkins).

---

## 🔐 Security Practices

* Fail build on **critical/high vulnerabilities**.
* Enforce **OPA security policies**.
* Publish all security reports in Jenkins.
* Automate scans in every pipeline run.

---

## 📌 Future Enhancements

* Add **Prometheus + Grafana** for monitoring.
* Add **Production Deployment** stage
* Implement **ArgoCD** for GitOps-style deployments.
* kubernetes security tools

---

## 👨‍💻 Author

Abdelrahman Ahmed
