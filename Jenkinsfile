pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mahesh2452/bootstrap-app"
        GIT_CREDENTIALS_ID = "Github"
        GIT_BRANCH = "main"

        // Kubernetes details (store in Jenkins credentials)
        K8S_SERVER = "https://<K8S_API_SERVER>"
        K8S_NAMESPACE = "default"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: "${GIT_BRANCH}",
                    credentialsId: "${GIT_CREDENTIALS_ID}",
                    url: 'https://github.com/Mahesh1-code141/Electro_Bootstrap.git'
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

        stage('Deploy to Kubernetes (No kubeconfig)') {
            steps {
                withCredentials([
                    string(credentialsId: 'k8s-token', variable: 'K8S_TOKEN'),
                    file(credentialsId: 'k8s-ca-cert', variable: 'K8S_CA')
                ]) {
                    sh '''
                        kubectl config set-cluster k8s-cluster \
                          --server=$K8S_SERVER \
                          --certificate-authority=$K8S_CA

                        kubectl config set-credentials jenkins-user \
                          --token=$K8S_TOKEN

                        kubectl config set-context jenkins-context \
                          --cluster=k8s-cluster \
                          --user=jenkins-user \
                          --namespace=$K8S_NAMESPACE

                        kubectl config use-context jenkins-context

                        kubectl set image deployment/my-app my-app=${DOCKER_IMAGE}:${BUILD_NUMBER} --record
                        kubectl apply -f mahesh.yml
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh "kubectl rollout status deployment/my-app"
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
