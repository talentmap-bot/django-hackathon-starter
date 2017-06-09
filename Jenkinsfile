node('talentmap_image') {
    stage('Test AWS CLI') {
        def login = getECRLoginCmd()
        echo "${login}"
    }
    stage('Test Docker CLI') {
        sh "FROM hello-world > Dockerfile"
        def docker = sh('docker build -t test .')
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

def getECRLoginCmd() {
    def loginCmd
    stage ('Get ECR Login'){
        sh "aws ecr get-login --region us-east-1 > login.txt"
        loginCmd = readFile('login.txt')
        sh "rm -f login.txt"
    }
    return loginCmd
}
