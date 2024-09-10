pipeline {
    agent { label 'slave' }

    environment {
        DOCKER_REGISTRY_CREDENTIALS = credentials('docker-registry-credentials')
        REGISTRY = 'docker.io/ffurkanarslan'
        IMAGE_NAME = "${REGISTRY}/furkan-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/FFurkanArslan/go-todo'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'sudo docker build -t $IMAGE_NAME:latest .'
                }
            }
        }

        stage('Login to Docker Registry') {
            steps {
                script {
                    sh 'echo $DOCKER_REGISTRY_CREDENTIALS_PSW | sudo docker login -u $DOCKER_REGISTRY_CREDENTIALS_USR --password-stdin'
                }
            }
        }

        stage('Push to Docker Registry') {
            steps {
                script {
                    sh 'sudo docker push $IMAGE_NAME:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'sudo docker-compose up -d'
                }
            }
        }
    }
}
