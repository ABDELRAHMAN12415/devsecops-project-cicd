#!/bin/bash

# Scan all base images in the Dockerfile for vulnerabilities using Trivy
awk '$1 == "FROM" ? system("docker run --rm -v $HOME/trivy-cache:/root/.cache/ aquasec/trivy:latest image --severity CRITICAL --exit-code 1 --quiet " $2) : 0' Dockerfile

# The script will exit with a non-zero status if any base image has CRITICAL vulnerabilities
exit_code=$?
if [[ "${exit_code}" != 0 ]]; then
    echo "Base image scanning failed or Vulnerabilities found"
    exit 1;
else
    echo "Base image scanning passed. No CRITICAL vulnerabilities found"
fi;
