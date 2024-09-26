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
                    dockerImage = docker.build("python-app:${env.BUILD_ID}")
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                script {
                    sshagent(['ec2-ssh-credentials']) {
                        sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@54.89.206.158 <<EOF
                        docker stop python-app || true
                        docker rm python-app || true
                        docker pull python-app:${env.BUILD_ID}
                        docker run -d -p 5000:5000 --name python-app python-app:${env.BUILD_ID}
                        EOF
                        '''
                    }
                }
            }
        }
    }
}
