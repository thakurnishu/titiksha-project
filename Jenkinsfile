pipeline {
    agent any

    environment {
        docker_registry = "nishant0510/titiksha-test"
        docker_registryCredential = 'docker_id'
        imageTag = "v${env.BUILD_ID}"
        RESOURCE_GROUP = 'titksha-2023'
        CONTAINER_NAME = "titiksha-test"
        AZURE_SUBSCRIPTION_ID = credentials('subscription_id')
        AZURE_TENANT_ID = credentials('tenant_id')
        SERVICE_PRINCIPAL_ID = credentials('principal_id')
        SERVICE_PRINCIPAL_PASSWORD = credentials('principal_password')
    }
    
    stages {

        stage('Fetch code') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/thakurnishu/titiksha2023.git']]])
            }
        }

        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build "${docker_registry}:${imageTag}"
                }
                
            }
        }

        stage('Push image') {
            steps {
                withCredentials([usernamePassword(credentialsId: docker_registryCredential, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}'
                    sh 'docker push ${docker_registry}:${imageTag}'
                }
                
                sh 'docker rmi ${docker_registry}:${imageTag}'
            }
        }

        stage('Running Image in Container instances') {
            steps {
                sh '''
                chmod +x BashScript.sh
                ./BashScript.sh
                '''
            }
        }
    }
}