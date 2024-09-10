pipeline {
    agent { label 'slave' }

    environment {
        DOCKER_REGISTRY_CREDENTIALS = credentials('docker-registry-credentials')
        REGISTRY = 'docker.io/ffurkanarslan'
        IMAGE_NAME = "${REGISTRY}/furkan-app"

        DB_HOST = credentials('db-host')
        DB_USER = credentials('db-user')
        DB_PASSWORD = credentials('db-password')
        DB_NAME = credentials('db-name')
        PORT = credentials('port')
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

        stage('Cleanup') {
            steps {
                script {
                    sh '''
                    sudo docker ps -aq -f name=furkan-app | xargs -r sudo docker rm -f
                    sudo docker ps -aq -f name=furkan-nginx | xargs -r sudo docker rm -f
                    '''
                }
            }
        }

        stage('Deploy App') {
            steps {
                script {
                    sh '''
                    sudo docker run -d --name furkan-app \
                        --network furkan-network \
                        -e DB_HOST=$DB_HOST \
                        -e DB_USER=$DB_USER \
                        -e DB_PASSWORD=$DB_PASSWORD \
                        -e DB_NAME=$DB_NAME \
                        -e PORT=$PORT \
                        -p 8081:8080 \
                        $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy Nginx') {
            steps {
                script {
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
