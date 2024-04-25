pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node19'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        APP_NAME = "reddit-clone-pipeline"
        RELEASE = "1.0.0"
        DOCKER_USER = "gabin75"
        DOCKER_PASS = 'docker'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }

    stages {
        stage ('Clean workspace') {
            steps {
                cleanWs()
            }
        }

        stage ('Code checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/Gabinsime75/Project_4-reddit-clone.git'
            }
        }

        stage ('Sonarqube analysis') {
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Reddit-Clone-CI \
                    -Dsonar.projectKey=Reddit-Clone-CI'''
                }
            }
        }

        stage ('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-token'
                }
            }
        }

        stage ('Insatall Dependencies') {
            steps {
                sh "npm install"
            }
        }

        stage ('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage ('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }

    }
}
