pipeline {
    agent { label 'slave' }

    environment {
        DOCKER_REGISTRY_CREDENTIALS = credentials('docker-registry-credentials')
        REGISTRY = 'docker.io/ffurkanarslan'
        IMAGE_NAME = "${REGISTRY}/furkan-app"
        // Add other environment variables if needed
        DB_HOST = credentials('db-host')
        DB_USER = credentials('db-user')
        DB_PASSWORD = credentials('db-password')
        DB_NAME = credentials('db-name')
        PORT = credentials('port')
        APP_INSTANCE_IP = credentials('frontend-instance-ip') 
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
                    withCredentials([
                        string(credentialsId: 'db-host', variable: 'DB_HOST'),
                        string(credentialsId: 'db-user', variable: 'DB_USER'),
                        string(credentialsId: 'db-password', variable: 'DB_PASS'),
                        string(credentialsId: 'db-name', variable: 'DB_NAME'),
                        string(credentialsId: 'port', variable: 'PORT'),
                        string(credentialsId: 'frontend-instance-ip', variable: 'APP_INSTANCE_IP')
                    ]) {
                        sh '''
                        export DB_HOST=${DB_HOST}
                        export DB_USER=${DB_USER}
                        export DB_PASS=${DB_PASS}
                        export DB_NAME=${DB_NAME}
                        export PORT=${PORT}
                        export APP_INSTANCE_IP=${APP_INSTANCE_IP}
                        export IMAGE_NAME=${IMAGE_NAME}
        
                         # Create a temporary file for Nginx config
                        TEMP_NGINX_CONF=$(mktemp)
        
                        # Process the Nginx configuration template
                        envsubst < /opt/go-todo/nginx_reverse_proxy.conf.j2 > $TEMP_NGINX_CONF
        
                        # Copy the temporary file to the actual Nginx configuration path
                        sudo cp $TEMP_NGINX_CONF /etc/nginx/nginx.conf
        
                        # Set correct permissions for the new config file
                        sudo chown root:root /etc/nginx/nginx.conf
                        sudo chmod 644 /etc/nginx/nginx.conf
        
                        # Restart Nginx to apply new configuration
                        sudo systemctl restart nginx
        
                        # Bring down any existing containers and bring up new ones
                        sudo -E docker-compose -f docker-compose.yml down
                        sudo -E docker-compose -f docker-compose.yml up -d --build
        
                        # Clean up the temporary file
                        rm $TEMP_NGINX_CONF
                        '''
                    }
                }
            }
        }
    }
}
