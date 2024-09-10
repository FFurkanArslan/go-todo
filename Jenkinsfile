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
                    // Build the Docker image for the application
                    sh 'sudo docker build -t $IMAGE_NAME:latest .'
                }
            }
        }

        stage('Login to Docker Registry') {
            steps {
                script {
                    // Log in to Docker registry
                    withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | sudo docker login -u $DOCKER_USERNAME --password-stdin'
                    }
                }
            }
        }

        stage('Push to Docker Registry') {
            steps {
                script {
                    // Push the Docker image to Docker Registry
                    sh 'sudo docker push $IMAGE_NAME:latest'
                }
            }
        }

        stage('Setup Docker Network') {
            steps {
                script {
                    // Create Docker network if it doesn't exist
                    sh '''
                    if ! sudo docker network inspect furkan-network > /dev/null 2>&1; then
                        sudo docker network create furkan-network
                    fi
                    '''
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                script {
                    // Stop and remove existing containers if they exist
                    sh '''
                    sudo docker-compose -f docker-compose.yml down
                    '''

                    // Start up new containers with Docker Compose
                    sh '''
                    sudo docker-compose -f docker-compose.yml up -d
                    '''
                }
            }
        }
    }
}
