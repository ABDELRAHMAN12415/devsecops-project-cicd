#!/bin/bash
set -e  # exit immediately if a command fails

# Scan all base images in the Dockerfile for vulnerabilities using Trivy
awk '$1 == "FROM" ? system("docker run --rm aquasec/trivy:latest image my-registry/my-app:tag
 --severity CRITICAL --exit-code 1 --quiet " $2) : 0' Dockerfile

# The script will exit with a non-zero status if any base image has CRITICAL vulnerabilities
exit_code=$?
if [[ "${exit_code}" == 1 ]]; then
    echo "Base image scanning failed. Vulnerabilities found"
    exit 1;
else
    echo "Base image scanning passed. No CRITICAL vulnerabilities found"
fi;
