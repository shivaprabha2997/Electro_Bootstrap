pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mahesh2452/electro-app"
        DOCKER_TAG = "${BUILD_NUMBER}"
        AWS_REGION = "us-east-1"
        CLUSTER_NAME = "mycluster1"
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/Mahesh1-code141/Electro_K8s.git', branch: 'main'
            }
        }

        stage('Build & Push Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'Docker_CRED',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $DOCKER_IMAGE:$DOCKER_TAG
                    '''
                }
            }
        }

        stage('Deploy to K8s') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG'),
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']
                ]) {
                    sh '''
                    aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

                    sed -i "s|IMAGE_PLACEHOLDER|$DOCKER_IMAGE:$DOCKER_TAG|g" k8s/deployment.yaml

                    kubectl apply -f k8s/
                    '''
                }
            }
        }

        stage('Verify') {
            steps {
                sh 'kubectl get pods && kubectl get svc'
            }
        }
    }
}
