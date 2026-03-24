pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "your-dockerhub-username/electro-app"
        DOCKER_TAG = "${BUILD_NUMBER}"
        KUBE_CONFIG = credentials('kubeconfig')   // Jenkins credential
        DOCKER_CREDS = credentials('Docker_CRED')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Mahesh1-code141/Electro_K8s.git', branch: 'main'
            }
        }

        stage('Build Application') {
            steps {
                sh 'echo "Build step (customize for your app)"'
                // Example:
                // sh 'npm install'
                // sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                script {
                    sh """
                    echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin
                    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                    export KUBECONFIG=${KUBE_CONFIG}

                    # Update image dynamically
                    sed -i 's|IMAGE_PLACEHOLDER|${DOCKER_IMAGE}:${DOCKER_TAG}|g' k8s/deployment.yaml

                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh """
                kubectl get pods
                kubectl get svc
                """
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful!"
        }
        failure {
            echo "❌ Pipeline Failed!"
        }
    }
}
