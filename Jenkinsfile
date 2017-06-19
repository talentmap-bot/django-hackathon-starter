def IMAGE_BUILD_VERSION = "v_${BRANCH_NAME}_${env.BUILD_NUMBER}"
def CONTAINER_PORT = "8000"
def CLUSTER_NAME = "TalentMAP"
def TASK_FAMILY = "test"
def SERVICE_NAME = "test"
def TEMPLATE_NAME = "task-definition-template.json"
def DOCKER_REGISTRY = "https://346011101664.dkr.ecr.us-east-1.amazonaws.com"
def DOCKER_IMAGE_NAME = "talentmap/test"

node('talentmap_build') {
    try {
        stage ('Checkout'){
            git branch: "${BRANCH_NAME}", credentialsId: '7a1c5125-103d-4a1a-8b2f-6a99da04d499', url: "https://github.com/cyber-swat-team/django-hackathon-starter"
        }   
        stage ('Build') {
            sh 'chmod +x build.sh'
            buildDockerImage("${DOCKER_IMAGE_NAME}")
        }
        stage ('Push') {
            def loginCmd = getECRLoginCmd()
            sh "${loginCmd}"
            pushDockerImage("${DOCKER_REGISTRY}", "${DOCKER_IMAGE_NAME}", "${IMAGE_BUILD_VERSION}")
        }
        
        //stage ('Test – Bandit') {
        //    sh 'pip --no-cache-dir install bandit'
            //sh 'bandit -r .'
        //}
        
        stage ('Should deploy?') {
            def should_deploy = false
            def host_port = determineContainerPort("${BRANCH_NAME}")
            if (host_port > 0) {
                should_deploy = true
                echo "The branch is ${BRANCH_NAME}, so this will run on port ${host_port}"
            }
            else {
                echo "The branch is ${BRANCH_NAME}, so this will not deploy"
            }
        }
        
        if (should_deploy) {
            stage ("Deploy – Update Task Definition") {
                // Create a new task definition for this build
                updateTaskDefinition("${TEMPLATE_NAME}", "${env.BUILD_NUMBER}", "${IMAGE_BUILD_VERSION}", "${CONTAINER_PORT}", "${host_port}", "${TASK_FAMILY}")
            }
            stage ("Deploy – Update Service") {
                // Update the service with the new task definition and desired count
                def taskRevision = getTaskDefRevision("${TASK_FAMILY}")
                def desiredCount = getEcsServiceDesiredCount("${SERVICE_NAME}")
                updateEcsService("${CLUSTER_NAME}", "${SERVICE_NAME}", "${TASK_FAMILY}", taskRevision, desiredCount)
            }
        }
    } catch (Exception err) {
        currentBuild.result = 'FAILURE' 
        println err
    }
}

def determineContainerPort(String branch) {
    def result = ""
    switch(branch) {
        case "develop":
            result = 8000
            break
        case "master":
            result = 80
            break
        default:
            result = -1
            break
    }
    return result
}

def pushDockerImage(String dockerRegistry, String dockerRepoName, String tag){
    stage ('Push Image') {
        docker.withRegistry("${dockerRegistry}") {
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

def updateTaskDefinition(String templateName, String buildNumber, String buildTag, String containerPort, String hostPort, String taskFamily) {
    def outputFileName = createTaskDefinitionJson(templateName, buildNumber, buildTag, containerPort, hostPort)
    createTaskDefinition(outputFileName, taskFamily)
}

def createTaskDefinitionJson(String templateName, String buildNumber, String buildTag, String containerPort, String hostPort){
    if (templateName.endsWidth(".json")) {
        templateName = templateName.minus(".json")
    }
    
    def outputFileName = "${templateName}-v_${buildNumber}.json"
    
    sh "sed -e \"s;%BUILD_TAG%;${buildTag};g\" ${templateName}.json > ${outputFileName}"
    sh "sed -e \"s;%CONTAINER_PORT%;${containerPort};g\" ${outputFileName} > ${outputFileName}"
    sh "sed -e \"s;%HOST_PORT%;${hostPort};g\" ${outputFileName} > ${outputFileName}"
    
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
