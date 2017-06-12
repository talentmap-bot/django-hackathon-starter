node('talentmap_image') {
    try {
        stage ('Checkout'){
            git branch: "${BRANCH_NAME}", credentialsId: '7a1c5125-103d-4a1a-8b2f-6a99da04d499', url: "https://github.com/cyber-swat-team/django-hackathon-starter"
        }   
        stage ('Build') {
            sh 'chmod +x build.sh'
            //sh './build.sh'
            buildDockerImage("talentmap/test")
            pushDockerImage("talentmap/test","latest")
        }
        stage ('Test – Bandit') {
            sh 'pip --no-cache-dir install bandit'
            //sh 'bandit -r .'
        }
    } catch (Exception err) {
        currentBuild.result = 'FAILURE' 
        println err
    }
}

def pushDockerImage(String dockerRepoName, String tag){
    stage ('Push Image') {
        docker.withRegistry([credentialsId: 'ecr:us-east-1:7a1c5125-103d-4a1a-8b2f-6a99da04d499', url: 'https://346011101664.dkr.ecr.us-east-1.amazonaws.com']) {
            docker.image("${dockerRepoName}").push("${tag}")
        }
    }
}

def buildDockerImage(String dockerRepoName){
    stage ('Build Image') {
        docker.build("${dockerRepoName}")
    }
}

def getECRLoginCmd() {
    def loginCmd
    stage ('Get ECR Login'){
        sh "aws ecr get-login --region us-west-2 > login.txt"
        loginCmd = readFile('login.txt')
        sh "rm -f login.txt"
    }
    return loginCmd
}
