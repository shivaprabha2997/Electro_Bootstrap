pipeline {
    agent any

    environment {
        DOCKER_USER = "mahesh2452"
        IMAGE_NAME = "bootstrap"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Mahesh1-code141/Electro_Bootstrap.git'
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker_CRED', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                    echo "$PASS" | docker login -u "$USER" --password-stdin
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                sh 'kubectl apply -f mahesh.yml'
                sh 'kubectl rollout status deployment/bootstrap'
                sh 'kubectl rollout status deployment/electro-app'
                """
            }
        }
    }

    post {
        success {
            echo "Deployment Successful "
        }
        failure {
            echo "Deployment Failed "
        }
    }
}
