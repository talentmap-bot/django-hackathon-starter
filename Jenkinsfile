pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                def login = sh('aws ecr get-login --region us-east-1')
                echo "${login}"
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
