pipeline {
    agent any

    environment {
        DOCKER_USER = "mahesh2452"
        IMAGE_NAME = "bootstrap"
        IMAGE_TAG = "${BUILD_NUMBER}"
        AWS_REGION = "us-east-1"
        CLUSTER_NAME = "mycluster1"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Mahesh1-code141/Electro_Bootstrap.git'
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker_CRED', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo "$PASS" | docker login -u "$USER" --password-stdin
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                echo "Updating kubeconfig from EKS..."
                aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME

                echo "Checking kubectl..."
                kubectl version --client

                echo "Cluster access check..."
                kubectl get nodes

                echo "Updating deployment image..."
                kubectl set image deployment/bootstrap \
                bootstrap=${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG} || true

                echo "Applying YAML..."
                kubectl apply -f mahesh.yml

                echo "Checking rollout status..."
                kubectl rollout status deployment/bootstrap
                '''
            }
        }
    }

    post {
        success {
            echo "Deployment Successful ✅"
        }
        failure {
            echo "Deployment Failed ❌"
        }
    }
}
