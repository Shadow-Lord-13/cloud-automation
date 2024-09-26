pipeline {
    agent any

    stages {
        stage('Clone Git Repository') {
            steps {
                retry(3) {
                    git branch: 'main', url: 'https://github.com/Shadow-Lord-13/cloud-automation.git'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Use your Docker Hub username
                    dockerImage = docker.build("shadowlord13/python-app:${env.BUILD_ID}")
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Docker Hub repository name
                    def dockerHubRepo = "shadowlord13/python-app"

                    // Push the image to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-credentials-id') {
                        dockerImage.push("${env.BUILD_ID}")
                    }
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                script {
                    sshagent(['ec2-ssh-credentials']) {
                        sh '''
                        #!/bin/bash
                        set -e  # Exit on error
                        set -x  # Enable debug output
                        ssh -o StrictHostKeyChecking=no ubuntu@54.89.206.158 <<EOF

                        # Add user to Docker group if not already done
                        #sudo usermod -aG docker ubuntu

                        # Update permission
                        sudo chmod 666 /var/run/docker.sock
                        # Ensure Docker service is running
                        sudo systemctl start docker

                        # Stop and remove existing container if any
                        docker stop python-app || true
                        docker rm python-app || true
                        
                        # Pull the latest image from Docker Hub
                        docker pull shadowlord13/python-app:${BUILD_ID}
                        # Run the new container
                        docker run -d -p 5000:5000 --name python-app shadowlord13/python-app:${BUILD_ID}
                        '''
                    }
                }
            }
        }
    }
}