#!/bin/bash

#smoke-test.sh

sleep 5s

PORT=$(kubectl -n default get svc devsecops-svc -o json | jq .spec.ports[].nodePort)

echo "SERVICE_PORT=$PORT"
echo "APPLICATION_URL=$applicationURL:$PORT/increment/99"

if [[ ! -z "$PORT" ]];
then

    response=$(curl -s $applicationURL:$PORT/increment/99)
    http_code=$(curl -s -o /dev/null -w "%{http_code}" $applicationURL:$PORT/increment/99)

    if [[ "$response" == 100 ]];
        then
            echo "Increment Test Passed"
        else
            echo "Increment Test Failed"
            exit 1;
    fi;

    if [[ "$http_code" == 200 ]];
        then
            echo "HTTP Status Code Test Passed"
        else
            echo "HTTP Status code is not 200"
            exit 1;
    fi;

else
        echo "The Service does not have a NodePort"
        exit 1;
fi;