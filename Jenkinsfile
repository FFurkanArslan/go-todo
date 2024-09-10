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
                    // Build the Docker image for the application with sudo
                    sh 'sudo docker build -t $IMAGE_NAME:latest .'
                }
            }
        }

        stage('Login to Docker Registry') {
            steps {
                script {
                    // Log in to the Docker registry with sudo
                    sh 'echo $DOCKER_REGISTRY_CREDENTIALS_PSW | sudo docker login -u $DOCKER_REGISTRY_CREDENTIALS_USR --password-stdin'
                }
            }
        }

        stage('Check .env file') {
            steps {
                script {
                    // Verify the existence of the .env file
                    sh 'ls -l .env || echo ".env file not found!"'
                }
            }
        }

        stage('Deploy App') {
            steps {
                script {
                    // Deploy the application using docker run with sudo and attach to the custom network
                    sh '''
                    sudo docker run -d --name furkan-app \
                        --network furkan-network \
                        --env-file .env \
                        -p 8081:8080 \
                        $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy Nginx') {
            steps {
                script {
                    // Deploy Nginx as reverse proxy with sudo, mount the config file, and expose port 80
                    sh '''
                    sudo docker run -d --name furkan-nginx \
                        --network furkan-network \
                        -v $(pwd)/nginx_reverse_proxy.conf:/etc/nginx/conf.d/default.conf \
                        -p 80:80 \
                        nginx:alpine
                    '''
                }
            }
        }
    }
}
