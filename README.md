# Dockerfile for Azure App Service / CentOS 7 + NGINX
This repo contains the simple sample of Dockerfile for Azure App Service Container with CentOS 7 + NGINX.

## Image Spec
* Parent Image / CentOS:7
* Web Server / NGINX
* SSH for Azure App Service Containers / Enabled
* Azure App Service Persistent Storage / Enabled

## How to Use
### Setup Azure CLI
1. Install the Azure CLI - https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli
2. Sign in to Azure - https://docs.microsoft.com/ja-jp/cli/azure/get-started-with-azure-cli

### Prepare local test directory
1. Create some local test directory by the following command
```cmd
mkdir C:\docker\volume\home\Logfiles
mkdir C:\docker\volume\home\site\wwwroot
```
2. Create "index.html" to wwwroot directory

### Build Docker Image
1. Clone or Download this repositry
2. Build Docker Image
```cmd
docker build -t azurewebapp-sample-container .
```
3. Run Docker Container for test purpose
```cmd
docker run -d -p 8000:80 -p 2222:2222 -v c:\\docker\\volume\\home:/home azurewebapp-sample-container
```
4. You can see the index.html accessing from browser http://localhost:8000
5. You can connect from ssh client using localhost:2222

### Setup Azure Container Registry
1. Create an Azure Container Registry - https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal
2. Login Contaner Registry - https://docs.microsoft.com/en-us/cli/azure/get-started-with-azure-cli

```cmd
az acr login --name <registry-name>
```

3. Push Image to ACR - https://docs.microsoft.com/en-us/cli/azure/get-started-with-azure-cli

```cmd
docker tag azurewebapp-sample-container <registry-name>.azurecr.io/azurewebapp-sample-container:v1
docker push <RegistryName>.azurecr.io/azurewebapp-sample-container:v1
```

### Setup Azure Web App for Container
Please use the following documents to setup Azure Web App for Containers.

https://docs.microsoft.com/en-us/azure/app-service/quickstart-custom-container?pivots=container-linux
https://docs.microsoft.com/en-us/azure/app-service/tutorial-custom-container?pivots=container-linux

#### Important
Pleas setup "persistent shared storage" - https://docs.microsoft.com/ja-jp/azure/app-service/configure-custom-container?pivots=container-linux#use-persistent-shared-storage

The easiest way to setup persistent shared storage is run the following command from Azure CLI or Cloud Shell (bash)

```bash
az webapp config appsettings set --resource-group <group-name> --name <app-name> --settings WEBSITES_ENABLE_APP_SERVICE_STORAGE=true
```