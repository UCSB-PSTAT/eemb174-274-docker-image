pipeline {
    agent none
    stages {
        stage('Build Test Deploy') {
            agent {
                label 'jupyter'
            }
            stages{
                stage('Build') {
                    steps {
                        sh 'podman build -t eemb174 --pull  --no-cache .'
                     }
                }
                stage('Test') {
                    steps {
                        sh 'podman run -it --rm localhost/eemb174 R -e "library(\"cmdstanr\");library(\"lme4\");library(\"rstan\");library(\"coda\");library(\"mvtnorm\")"'
                        sh 'podman run -it --rm localhost/eemb174 which nano'
                    }                
                }
                stage('Deploy') {
                    when { branch 'main' }
                    environment {
                        DOCKER_HUB_CREDS = credentials('DockerHubToken')
                    }
                    steps {
                        sh 'podman login -u="${DOCKER_HUB_CREDS_USR}" -p="${DOCKER_HUB_CREDS_PWD}" docker.io'
                        sh 'skopeo copy containers-storage:localhost/eemb174 docker://docker.io/ucsb/eemb174-274 || skopeo copy containers-storage:localhost/eemb174 docker://docker.io/ucsb/eemb174-274'
                    }
                }                
            }
        }
    }
    post {
        success {
            slackSend(channel: '#infrastructure-build', username: 'jenkins', message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} just finished successfull! (<${env.BUILD_URL}|Details>)")
        }
        failure {
            slackSend(channel: '#infrastructure-build', username: 'jenkins', message: "Uh Oh! Build ${env.JOB_NAME} ${env.BUILD_NUMBER} had a failure! (<${env.BUILD_URL}|Find out why>).")
        }
    }
}
