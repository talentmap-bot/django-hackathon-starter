node('talentmap_image') {
    stage ('Checkout'){
        git branch: "${BRANCH_NAME}", credentialsId: '7a1c5125-103d-4a1a-8b2f-6a99da04d499', url: "https://github.com/cyber-swat-team/django-hackathon-starter"
    }   
    stage ('Build') {
        sh 'chmod +x build.sh'
        sh './build.sh'
    }
}
stage('Test') {
    parallel zap: {
        node('talentmap_zap') {
            sh 'echo "Testing using OWASP ZAP"'
        }
    },
    bandit: {
        node('talentmap_bandit') {
            sh 'echo "Testing using Bandit"'
        }
    }
}
