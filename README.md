# Deployment steps
## 1. Setup
```
SUFFIX=20230419temp
RG=rg-$SUFFIX
LOC=japaneast
SUB=<Your Subscription ID>

az account set --name $SUB

az group create -l $LOC -n rg-$SUFFIX
```
## 2. Deploy Azure Resources
```
az deployment group create --resource-group rg-$SUFFIX --template-file main.bicep
```

## 3. Build the container image
Use Docker to build the container image based on your Dockerfile. This will create an image with your compiled COBOL application
```
docker build -t my_cobol_app:latest .
```

Try running it locally
```
docker run -d -p 80:80 my_cobol_app:latest
```

Try accessing it from http://localhost/

## 4. Push the image to a container registry
Push the container image to Azure Container Registry (ACR): https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli
```
ACR=crcajnmrqfrbeqo
az login
az acr login --name $ACR
docker tag my_cobol_app:latest $ACR.azurecr.io/azuredocs/containerapps-helloworld:latest
docker push $ACR.azurecr.io/azuredocs/containerapps-helloworld:latest
```

## 5. Deploy your COBOL application to Azure Container Apps
Finally, you can deploy your COBOL application on Azure Container Apps. You can follow the official documentation for deploying a containerized application using Azure Container Apps: https://docs.microsoft.com/en-us/azure/container-apps/create-app-cli
```
ACA=app-cajnmrqfrbeqo
az containerapp update \
  --name $ACA \
  --resource-group $RG \
  --image $ACR.azurecr.io/azuredocs/containerapps-helloworld:latest | jq '.. |."fqdn"? | select(. != null)'
```
## 6. Check
Check the fqdn