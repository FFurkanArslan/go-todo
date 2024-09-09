pipeline {
    agent any

    environment {
        // Docker Registry credentials stored in Jenkins
        DOCKER_REGISTRY_CREDENTIALS = credentials('docker-registry-credentials')
        REGISTRY = 'docker.io/ffurkanarslan' // e.g., docker.io
        IMAGE_FRONTEND = "${REGISTRY}/furkan-frontend"
        IMAGE_BACKEND = "${REGISTRY}/furkan-backend"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/FFurkanArslan/go-todo'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_FRONTEND:latest -f frontend/Dockerfile .'
                    sh 'docker build -t $IMAGE_BACKEND:latest -f backend/Dockerfile .'
                }
            }
        }

        stage('Login to Docker Registry') {
            steps {
                script {
                    sh 'echo $DOCKER_REGISTRY_CREDENTIALS_PSW | docker login -u $DOCKER_REGISTRY_CREDENTIALS_USR --password-stdin'
                }
            }
        }

        stage('Push to Docker Registry') {
            steps {
                script {
                    sh 'docker push $IMAGE_FRONTEND:latest'
                    sh 'docker push $IMAGE_BACKEND:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'gcloud compute ssh furkan-frontend --zone us-central1-a --command "docker run -d -p 80:80 $IMAGE_FRONTEND:latest"'
                    sh 'gcloud compute ssh furkan-backend --zone us-central1-a --command "docker run -d -p 8080:8080 $IMAGE_BACKEND:latest"'
                }
            }
        }
    }
}
