$!/bin/bash

az login --service-principal -u ${SERVICE_PRINCIPAL_ID} -p ${SERVICE_PRINCIPAL_PASSWORD} --tenant ${AZURE_TENANT_ID}

az container delete --name ${CONTAINER_NAME} --resource-group ${RESOURCE_GROUP} --yes

sleep 10

az container create --name ${CONTAINER_NAME} --resource-group ${RESOURCE_GROUP} \
--cpu 1 --memory 1.5  --location ${LOCATION} --image ${docker_registry}:${imageTag} \
--ip-address Public --dns-name-label ${CONTAINER_NAME} --ports 80
