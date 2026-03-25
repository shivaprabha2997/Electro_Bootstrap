pipeline {
    agent any
    environment {
        DOCKER_USER = "shivadocker2997"
        IMAGE_NAME = "gadgets"
        IMAGE_TAG = "latest"
        CLUSTER_NAME = "cluster007"
        AWS_REGION = "us-east-1"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shivaprabha2997/Electro_Bootstrap.git'
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
                    sh '''
                    echo "$PASS" | docker login -u "$USER" --password-stdin
                    docker tag gadgets:latest shivadocker2997/gadgets:latest
                    docker push shivadocker2997/gadgets:latest
                    '''
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                    # Configure AWS credentials on the fly
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    export AWS_DEFAULT_REGION=us-east-1

                    # Generate kubeconfig dynamically (no file needed permanently)
                    aws eks update-kubeconfig --region us-east-1 --name cluster007 --kubeconfig /tmp/kubeconfig

                    # Deploy using the temp kubeconfig
                    kubectl --kubeconfig=/tmp/kubeconfig apply -f mahesh.yml
                    kubectl --kubeconfig=/tmp/kubeconfig get pods

                    # Cleanup
                    rm -f /tmp/kubeconfig
                    '''
                }
            }
        }
    }
    post {
        success {
            echo "Deployment Successful"
        }
        failure {
            echo "Deployment Failed"
        }
    }
}
