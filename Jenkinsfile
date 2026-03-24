pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mahesh2452/bootstrap-app"
        KUBE_CONFIG_CREDENTIALS = "kubeconfig-id"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/Mahesh1-code141/Electro_Bootstrap.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'Docker_CRED') {
                        docker.image("${DOCKER_IMAGE}:${BUILD_NUMBER}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: "${KUBE_CONFIG_CREDENTIALS}", variable: 'KUBECONFIG')]) {
                    sh """
                        kubectl set image deployment/my-app my-app=${DOCKER_IMAGE}:${BUILD_NUMBER} --record
                        kubectl apply -f mahesh.yml
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                withCredentials([file(credentialsId: "${KUBE_CONFIG_CREDENTIALS}", variable: 'KUBECONFIG')]) {
                    sh "kubectl rollout status deployment/my-app"
                }
            }
        }
    }

    post {
        success {
            echo "Deployment Successful 🚀"
        }
        failure {
            echo "Deployment Failed ❌"
        }
    }
}
