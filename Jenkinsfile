node('talentmap_image') {
    stage ('Checkout'){
        git branch: "${BRANCH_NAME}", credentialsId: '7a1c5125-103d-4a1a-8b2f-6a99da04d499', url: "https://github.com/cyber-swat-team/django-hackathon-starter"
    }   
    stage ('Build') {
        sh 'chmod +x build.sh'
        sh './build.sh'
    }
    stage ('Test – Bandit') {
        sh 'pip --no-cache-dir install bandit'
        sh 'bandit -r .'
    }
}
