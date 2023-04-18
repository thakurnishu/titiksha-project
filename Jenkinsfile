def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger'
]

pipeline {
    agent any

    environment {
        docker_registry = "nishant0510/titiksha-test"
        docker_registryCredential = 'docker_id'
        imageTag = "v${env.BUILD_ID}"
        RESOURCE_GROUP = 'titksha-test'
        CONTAINER_NAME = "titiksha-test"
        LOCATION = "centralindia"
        STORAGE_NAME = 'testterraformtitiksha'
        STORAGE_CONTAINER = 'titiksha'
        AZURE_SUBSCRIPTION_ID = credentials('subscription_id')
        AZURE_TENANT_ID = credentials('tenant_id')
        SERVICE_PRINCIPAL_ID = credentials('principal_id')
        STORAGE_KEY = credentials('azure_storage_key')
    }
    
    stages {

        // stage('Fetch code') {
        //     steps {
        //         checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/thakurnishu/titiksha-project.git']]])
        //     }
        // }

        // stage('Building image') {
        //     steps{
        //         script {
        //             dockerImage = docker.build "${docker_registry}:${imageTag}"
        //         }
                
        //     }
        // }

        // stage('Push image') {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: docker_registryCredential, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
        //             sh 'docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}'
        //             sh 'docker push ${docker_registry}:${imageTag}'
        //         }
                
        //         sh 'docker rmi ${docker_registry}:${imageTag}'
                
        //     }
        // }

        // stage('Running Image in Container instances') {
        //     steps {
        //         sh '''
        //         chmod +x BashScript.sh
        //         ./BashScript.sh
        //         '''

        //         sh '''
        //         cd Terraform-scripts
        //         terraform init
        //         terraform validate
                
        //         terraform apply -var AZURE_SUBSCRIPTION_ID=${AZURE_SUBSCRIPTION_ID} \
        //         -var AZURE_TENANT_ID=${AZURE_TENANT_ID} \
        //         -var SERVICE_PRINCIPAL_ID=${SERVICE_PRINCIPAL_ID} \
        //         -var SERVICE_PRINCIPAL_PASSWORD=${SERVICE_PRINCIPAL_PASSWORD} \
        //         -var RESOURCE_GROUP=${RESOURCE_GROUP} \
        //         -var CONTAINER_IMAGE=${docker_registry}:${imageTag} \
        //         -var LOCATION=${LOCATION} -var CONTAINER_NAME=${CONTAINER_NAME} -auto-approve
        //         '''
        //     }
        // }

        stage('Terraform Init') {
            steps {
                sh '''
                    cd Terraform-scripts
                    terraform init \
                    -backend-config="access_key=${STORAGE_KEY}" 
                    '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var AZURE_SUBSCRIPTION_ID=${AZURE_SUBSCRIPTION_ID} \
                    -var AZURE_TENANT_ID=${AZURE_TENANT_ID} \
                    -var SERVICE_PRINCIPAL_ID=${SERVICE_PRINCIPAL_ID} \
                    -var SERVICE_PRINCIPAL_PASSWORD=${SERVICE_PRINCIPAL_PASSWORD} \
                    -var RESOURCE_GROUP=${RESOURCE_GROUP} \
                    -var CONTAINER_IMAGE=${docker_registry}:${imageTag} \
                    -var LOCATION=${LOCATION} -var CONTAINER_NAME=${CONTAINER_NAME} \
                    -out="terraform.tfplan"'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply \
                    -auto-approve \
                    "terraform.tfplan"'
            }
        }

        stage('Pushing terraform State') {
            steps {
                sh 'terraform state push terraform.tfstate'
            }
        }
    }
    // post {
    //     always {
    //         echo 'Slack Notification.'
    //         slackSend channel: '#tech-event',
    //         color: COLOR_MAP[currentBuild.currentResult],
    //         message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
    //     }
    // }
}
