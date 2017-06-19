node('talentmap_build') {
    try {
        stage ('Checkout'){
            git branch: "${BRANCH_NAME}", credentialsId: '7a1c5125-103d-4a1a-8b2f-6a99da04d499', url: "https://github.com/cyber-swat-team/django-hackathon-starter"
        }   
        stage ('Build') {
            sh 'chmod +x build.sh'
            buildDockerImage("talentmap/test")
        }
        stage ('Push') {
            def loginCmd = getECRLoginCmd()
            sh "${loginCmd}"
            pushDockerImage("talentmap/test","latest")
        }
        
        //stage ('Test – Bandit') {
        //    sh 'pip --no-cache-dir install bandit'
            //sh 'bandit -r .'
        //}
    } catch (Exception err) {
        currentBuild.result = 'FAILURE' 
        println err
    }
}

def pushDockerImage(String dockerRepoName, String tag){
    stage ('Push Image') {
        docker.withRegistry("https://346011101664.dkr.ecr.us-east-1.amazonaws.com") {
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
        sh "aws ecr get-login --region us-east-1 > login.txt"
        loginCmd = readFile('login.txt')
        sh "rm -f login.txt"
    }
    return loginCmd
}

def deployEcsService(String clusterName, String templateName, String taskFamily, String serviceName){
    // Create a new task definition for this build
    updateTaskDefinition(templateName, taskFamily)
    
    // Update the service with the new task definition and desired count
    def taskRevision = getTaskDefRevision(taskFamily)
    def desiredCount = getEcsServiceDesiredCount(serviceName)
    updateEcsService(clusterName, serviceName, taskFamily, taskRevision, desiredCount)
}

def updateTaskDefinition(String templateName, String taskFamily) {
    def buildNumber = "${env.BUILD_NUMBER}"
    def outputFileName = createTaskDefinitionJson(templateName, buildNumber)
    createTaskDefinition(outputFileName, taskFamily)
}

def createTaskDefinitionJson(String templateName, String buildNumber){
    if (templateName.endsWidth(".json")) {
        templateName = templateName.minus(".json")
    }
    
    def outputFileName = "${templateName}-v_${buildNumber}.json"
    
    sh "sed -e \"s;%BUILD_NUMBER%;${buildNumber};g\" ${templateName}.json > ${outputFileName}"
    
    if (!fileExists("${outputFileName}")) {
        throw new IOException("File ${outputFileName} was not created for task definition")
    }
    return "${outputFileName}"
}

def createTaskDefinition(String taskDefFileName, String taskFamily) {
    sh "aws ecs register-task-definition --family ${taskFamily} --cli-input-json file://${taskDefFileName}"
}

def getTaskDefRevision(String taskFamily) {
    return sh "aws ecs describe-task-definition --task-definition ${taskFamily} | egrep \"revision\" | tr \"\/\" \" \" | awk '{print $2}' | sed 's\/\"$\/\/'"
}

def getEcsServiceDesiredCount(String serviceName) {
    def desiredCount = sh "aws ecs describe-services --services ${SERVICE_NAME} | egrep \"desiredCount\" | tr \"\/\" \" \" | awk '{print $2}' | sed 's\/,$\/\/'"
    desiredCount = String.valueOf(desiredCount)
    if (desiredCount == "0") {
        desiredCount = "1"
    }
    return desiredCount
}

def updateEcsService(String clusterName, String serviceName, String taskFamily, String taskRevision, String desiredCount) {
    sh "aws ecs update-service --cluster ${clusterName} --service ${serviceName} --task-definition ${taskFamily}:${taskRevision} --desired-count ${desiredCount}"
}
