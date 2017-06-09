node {
    stage('Build') {
        def login = sh('aws ecr get-login --region us-east-1')
        echo "${login}"
    }
    stage('Test') {
        echo 'Building....'
    }
    stage('Deploy') {
        echo 'Deploying....'
    }
}
