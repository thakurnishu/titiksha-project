
# Documentation for Jenkins Pipeline: Streamlining CICD

This Jenkins Pipeline is for Continuous Integration and Deployment of Website for College Tech Event [Titiksha 2023]


## Technology used 

* Git    
* Terraform                       
* Jenkins
* Docker
* Azure Cloud
    - Virtual Machine[Jenkins Server]
    - Container Instance
    - Traffic Manager[Loadbalancer]
    - Storage Account[Containers storage]
    - Active Directory[App registrations]


## Setup Azure Cloud 

Create Azure Cloud Account for free get $200 credits for one month.

### Virtual Machine

* Create Virtual Machine install above mention Packges on it.
* Open Port 8080 on security firewall on VM for Jenkins.


### Storage Account

* Create one Storage Account for terraform states.
* Create Container to store terrafrom.tfstate file.
* Note Account Name and Secret Key in Access key section.  


### Active Directory

* Create registry for app to access azure resources from App Registrations.
* In App Registry Create Client Secret
* Note  that Clinet Secret, Application (client) ID, Tenant ID and Subscriptions ID  
## Installation

Installing Jenkins in Ubuntu Server 

```bash
sudo apt-get update 
sudo apt-get install openjdk-11-jdk -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install jenkins -y
```
Installing Docker on Jenkins Machine

```
sudo apt install docker.io -y
```

Installing Terraform on Jenkins Machine
```
wget https://releases.hashicorp.com/terraform/1.4.5/terraform_1.4.5_darwin_amd64.zip

sudo unzip terraform_1.4.5_darwin_amd64.zip -d /usr/local/bin

terraform --version
```

Installing Azure CLI
```
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y
```
Download and install the Microsoft signing key:
```
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
```
Add the Azure CLI software repository:
```
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
```
Update repository information and install the azure-cli package:

```
sudo apt-get update
sudo apt-get install azure-cli -y
```

## Jenkins Setup

* On Browser search <ip-add-jenkins-server>:8080
* New Page will pop up 

![App Screenshot](https://www.jenkins.io/doc/book/resources/tutorials/setup-jenkins-01-unlock-jenkins-page.jpg)

* On Jenkins server :
```
sudo cat /var/jenkins_home/secrets/initialAdminPassword

# Copy Output and paste in Admin Password 
``` 

* Click on Start Jenkins and set Admin `Username` and `Password` remember it.

* Install Plugins mention below through Manage Plugins 
## Plugins for Jenkins Server

| Plugin             | Use                                                                |
| ----------------- | ------------------------------------------------------------------ |
| Github Integration | Advanced trigger for GitHub Pull Requests and Branches|
| Docker Pipeline and Docker| Jenkins plugin which allows building, testing, and using Docker images from Jenkins Pipeline projects |


## Credentials Setup

We Require credentials for access Azure resources and DockerHub as Images Repository for our docker images.

### DockerHub 

Store Dockerhub username and password in jenkins credentials with ID mention in Jenkinsfile

### Azure cloud

Store Azure credentials like  Application (clinet) Secret, Application (client) ID, Tenant ID and Subscriptions ID, Storage Account and it Secret Key in Secret Text of Jenkins credentials with ID mention in Jenkinsfile.

### Github

Store Github Credentials if Repo is private.
## GitHub Webhook

* To run Jenkins Pipeline After every push in GitHub Repo. We can use GitHub Webhook to trigger Jenkins Pipeline after every push

* In GitHub Repo > Setting > Webhook > Add Webhook

* In Payload URL add :
```
http://<ip-add-jenkins-server>:8080/github-webhook/
```

* Content Type = `application/json` and Click Add Webhook



## Jenkins Pipeline

