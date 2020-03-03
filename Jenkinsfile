import groovy.json.*

def BUILD_NODE="jenkins_slave1"
def APPNAME="HelloWorld"
def VER='1.0-1'
def ARTIFACTORY_URL="http://10.176.2.113:8044/artifactory"


node (BUILD_NODE){
    def JENKINSWORKSPACE=pwd()
    def JAR_LOCATION="${JENKINSWORKSPACE}/target/${APPNAME}-${VER}.jar"
    def destinfo="vcs_devops@10.176.2.47"
    stage('Cleanup Workspace '){
        deleteDir()
    }
    stage('checkout') {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'common-tools-integration', url: 'http://10.176.2.11:8042/scm/dev/helloworld.git']]])
    }
    stage('Build')
    {
        sh "mvn clean package"
    }
    stage ('Upload to Artifactory')
    {
        def curlcmd=sh ('curl -sSf -H "X-JFrog-Art-Api:AKCp5ekSuhRL3zCTtSoG7B68dfKAYaq3vqvzsuY1Pz2Vn8b6WhuGZZrrB8eKC3YEN7jySKbrA" -X PUT -T ' + JENKINSWORKSPACE + '/target/' + APPNAME + '-' + VER + '.jar '  + ARTIFACTORY_URL + '/' + APPNAME + '/' + BUILD_NUMBER + '/' + APPNAME + '-' + VER + '.jar ' )
        echo "$curlcmd"
    }
    stage ('Extract the application artifacts ')
    {

        def copy_jar=('scp -q -oStrictHostKeyChecking=no -r ' + JENKINSWORKSPACE + '/target/ ' + destinfo + ':')
        sh copy_jar

        def copy_ansible=( 'scp -q -oStrictHostKeyChecking=no -r ' + JENKINSWORKSPACE + '/ansible/ ' + destinfo + ':')
        sh copy_ansible
    }
    stage ('Deploy'){
        def deploy_cmd= $/ ssh -q ${destinfo} -oStrictHostKeyChecking=no -C 'ansible-playbook -i ansible\/ansible.hosts ansible\/deploy.yaml' /$
        sh deploy_cmd
    }

}