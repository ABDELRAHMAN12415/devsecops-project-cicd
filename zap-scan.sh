#!/bin/bash

PORT=$(kubectl -n default get svc devsecops-svc -o json | jq .spec.ports[].nodePort)

echo "SERVICE_PORT=$PORT"

docker run  --rm -v $(pwd):/zap/wrk/:rw   -t zaproxy/zap-stable   zap-api-scan.py     -t $applicationURL:$PORT/v3/api-docs     -f openapi     -r zap-report.html

exit_code=$?

echo "Exit Code : $exit_code"

 if [[ ${exit_code} -ne 0 ]];  then
    echo "OWASP ZAP Report has either Low/Medium/High Risk. Please check the HTML Report"
    exit 1;
   else
    echo "OWASP ZAP did not report any Risk"
 fi;