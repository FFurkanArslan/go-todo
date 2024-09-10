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

        stage('Deploy App') {
            steps {
                script {
                    // Stop and remove any existing container
                    sh 'sudo docker rm -f furkan-app || true'

                    // Run the new Docker container
                    sh '''
                    sudo docker run -d --name furkan-app --network furkan-network \
                    -e DB_HOST=**** -e DB_USER=**** -e DB_PASSWORD=**** -e DB_NAME=**** \
                    -e PORT=8080 -p 8081:8080 $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy Nginx') {
            steps {
                script {
                    // Stop and remove any existing Nginx container
                    sh 'sudo docker rm -f furkan-nginx || true'

                    // Run the Nginx container
                    sh '''
                    sudo docker run -d --name furkan-nginx --network furkan-network \
                    -v /home/quiblord/workspace/todo/app/pipeline/nginx_reverse_proxy.conf.j2:/etc/nginx/conf.d/default.conf \
                    -p 80:80 nginx:alpine
                    '''
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // Optionally, you can add cleanup commands if needed
                    // For example, remove old images or containers
                    sh 'sudo docker system prune -f'
                }
            }
        }
    }
}
