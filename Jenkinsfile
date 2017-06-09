node('talentmap_image') {
    stage('Test AWS CLI') {
        def login = sh('aws ecr get-login --region us-east-1')
        echo "${login}"
    }
    stage('Test Docker CLI') {
        def docker = sh('docker ps')
        echo "${docker}"
    }
}
node('talentmap_image') {
    stage('Test Python') {
        def py = sh('python -version')
        echo "${py}"
    }
    stage('Test NPM') {
        def npm = sh('npm -v')
        echo "${npm}"
    }
}
