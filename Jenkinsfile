pipeline {
    agent { label 'myLocalPHPAgent' }  // Label of your Jenkins node set up for EC2

    environment {
        DEPLOY_SERVER = 'ec2-user@18.206.147.42'  // SSH address of the target EC2 instance
        DEPLOY_PATH = '/var/www/html/'                 // Path where the PHP files will be served
        KEY_CREDENTIALS = '4626ae65-a68c-4c09-90b3-684720aa9217'                // ID of Jenkins credentials for SSH
    }

    stages {
        stage('Install PHP') {
            steps {
                script {
                    // Install PHP and required packages
                    sh 'sudo yum install -y php php-cli php-mysqlnd'
                    // Additional packages may be required depending on your application's dependencies
                }
            }
        }

        stage('Checkout') {
            steps {
                // Check out source code from Git
                git url: 'https://github.com/muditsoni32/php.git', branch: 'main'
            }
        }

        stage('Deploy') {
            steps {
                // Deployment step using rsync over SSH
                sshagent(credentials: [env.KEY_CREDENTIALS]) {
                    script {
                        sh """
                        rsync -avz --delete ./* ${DEPLOY_SERVER}:${DEPLOY_PATH}
                        """
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
