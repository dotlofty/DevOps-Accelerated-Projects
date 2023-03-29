pipeline{
    agent any
    tools{
        maven 'maven'
    }
    environment {
        dockerusername = credentials('dockerhub-UN')
        dockerpassword = credentials('dockerhubPW')
    }
    stages{
        stage('Git pull'){
            steps{
                git branch: 'main', credentialsId: 'git', url: 'https://github.com/CloudHight/Pet-Adoption-Containerisation-Project-Application-Day-Team--06-Feb.git'
            }
        }
        stage('code analysis'){
            steps{
                withSonarQubeEnv('sonarQube') {
                    sh 'mvn sonar:sonar'  
               }
            }
        }
        stage('build code'){
            steps{
                sh 'mvn clean install'
            }
        }
        stage('build image'){
            steps{
                sh 'docker build -t $dockerusername/j-pipeline .'
            }
        }
        stage('login to dockerhub'){
            steps{
                sh 'docker login -u $dockerusername -p $dockerpassword'
            }
        }
        stage('push image'){
            steps{
                sh 'docker push $dockerusername/j-pipeline'
            }
        }
        stage('deploy to QA'){
            steps{
                sshagent(['jenkins-key']) {
                    sh 'ssh -t -t ec2-user@10.0.1.27 -o StrictHostKeyChecking=no "ansible-playbook /home/ec2-user/playbooks/dockerQAcontainer.yml"'
               }
            }
        }
        stage('slack notification'){
            steps{
                slackSend channel: 'jenkins-alert', message: 'successfuly deployed to dockerQA server Requires Approval to deploy to dockerPROD server', teamDomain: 'dothrakiinter-evh4406', tokenCredentialId: 'slack'
            }
        }
        stage('Approval'){
            steps{
                timeout(activity: true, time: 5) {
                  input message: 'Please approve for Deployment to Production ', submitter: 'admin'
               }
            }
        }
        stage('deploy to PROD'){
            steps{
               sshagent(['jenkins-key']) {
                    sh 'ssh -t -t ec2-user@10.0.1.27 -o StrictHostKeyChecking=no "ansible-playbook /home/ec2-user/playbooks/dockerPRODcontainer.yml"'
               }  
            }
        }
    }
    post {
     success {
       slackSend channel: 'jenkins-alert', message: 'successfully deployed to PROD Env ', teamDomain: 'dothrakiinter-evh4406', tokenCredentialId: 'slack'
     }
     failure {
       slackSend channel: 'jenkins-alert', message: 'failed to deploy to PROD Env', teamDomain: 'dothrakiinter-evh4406', tokenCredentialId: 'slack'
     }
  }

}