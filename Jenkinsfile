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
                    sh 'docker build -t $IMAGE_NAME:latest .'
                }
            }
        }

        stage('Login to Docker Registry') {
            steps {
                script {
                    // Log in to the Docker registry
                    sh 'echo $DOCKER_REGISTRY_CREDENTIALS_PSW | docker login -u $DOCKER_REGISTRY_CREDENTIALS_USR --password-stdin'
                }
            }
        }

        stage('Push to Docker Registry') {
            steps {
                script {
                    // Push the Docker image to Docker Registry
                    sh 'docker push $IMAGE_NAME:latest'
                }
            }
        }

        stage('Deploy App') {
            steps {
                script {
                    // Deploy the application using docker run and attach to the custom network
                    sh '''
                    docker run -d --name furkan-app \
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
                    // Deploy Nginx as reverse proxy, mount the config file, and expose port 80
                    sh '''
                    docker run -d --name furkan-nginx \
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
