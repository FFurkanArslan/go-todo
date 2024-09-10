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
                    // Build the Docker image for the application using Docker Compose
                    sh 'sudo docker-compose build app'
                }
            }
        }

        stage('Login to Docker Registry') {
            steps {
                script {
                    // Log in to Docker registry
                    sh 'echo $DOCKER_REGISTRY_CREDENTIALS_PSW | sudo docker login -u $DOCKER_REGISTRY_CREDENTIALS_USR --password-stdin'
                }
            }
        }

        stage('Push to Docker Registry') {
            steps {
                script {
                    // Tag and push the Docker image to Docker Registry
                    sh 'sudo docker tag docker.io/ffurkanarslan/furkan-app:latest $IMAGE_NAME:latest'
                    sh 'sudo docker push $IMAGE_NAME:latest'
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                script {
                    // Deploy using Docker Compose
                    sh 'sudo docker-compose up -d'
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // Optionally, you can add cleanup commands if needed
                    // For example, remove old images or containers
                }
            }
        }
    }
}
