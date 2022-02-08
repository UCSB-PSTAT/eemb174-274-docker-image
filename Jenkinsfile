pipeline {
    agent none
    stages {
        stage('Build and Test') {
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
                        sh 'podman run -it --rm localhost/eemb174 R -e "library(\"cmdstanr\");library(\"lme4\");library(\"rstan\")"'
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
