pipeline {
    agent any // Use any available Jenkins agent

    stages {
        stage('Build Docker Image') {
            steps {
                // Build the Docker image using the provided Dockerfile
                script {
                   docker.build('my-php-app:latest', '-f Dockerfile .')
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                // Push the Docker image to a Docker registry (if needed)
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerregistry') {
                        docker.image('my-php-app:latest').push()
                    }
                }
            }
        }

        stage('Deploy Docker Image') {
            steps {
                // SSH into the target server and run the Docker container
                script {
                    sshagent(credentials: ['mudit_test']) {
                        sh '''
                            ssh ec2-user@18.206.147.42 "docker pull my-php-app:latest && \
                            docker run -d --name my-php-app -p 80:80 my-php-app:latest"
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed. Check the console output for errors.'
        }
    }
}
