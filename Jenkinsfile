// parallel tests_1: {
//     node('talentmap_image') {
//         stage('Test AWS CLI') {
//             def login = getECRLoginCmd()
//             echo "${login}"
//         }
//         stage('Test Docker CLI') {
//             sh "echo \"FROM scratch\nEXPOSE 80\" > Dockerfile"
//             def docker = sh('docker build -t test .')
//             echo "${docker}"
//         }
//     }
// }, tests_2: {
//     node('talentmap_image') {
//         stage('Test Python') {
//             def py = sh('python --version')
//             echo "${py}"
//         }
//         stage('Test NPM') {
//             def npm = sh('npm -v')
//             echo "${npm}"
//         }
//     }
// }
node('talentmap_image') {
    sh 'whoami'
    //stage('Test AWS CLI') {
    //    def login = getECRLoginCmd()
    //    echo "${login}"
    //}
    stage ('Checkout'){
        git branch: "${BRANCH_NAME}", credentialsId: '7a1c5125-103d-4a1a-8b2f-6a99da04d499', url: "https://github.com/cyber-swat-team/django-hackathon-starter"
    }   
    stage ('Build') {
        sh 'chmod +x build.sh'
        sh './build.sh'
        //sh 'virtualenv venv'
        //sh '. venv/bin/activate'
        //sh 'pip install -r requirements.txt'
        //sh 'npm install -g bower'
        //sh 'bower install'
        //sh 'python manage.py makemigrations'
        //sh 'python manage.py migrate'
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
