pipeline {
agent any

environment {
    DOCKER_IMAGE = "mahesh2452/electro_bootstrap_project_img"
}

stages {

    stage('GIT CHECKOUT') {
        steps {
            git branch: 'main',
            credentialsId: 'Github',
            url: 'https://github.com/Mahesh1-code141/Electro_Bootstrap.git'
        }
    }

    stage('Docker Build') {
        steps {
            sh 'docker build -t $DOCKER_IMAGE:latest .'
        }
    }

    stage('Docker Login') {
        steps {
            withCredentials([usernamePassword(credentialsId: 'Docker_CRED', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                sh 'echo $PASS | docker login -u $USER --password-stdin'
            }
        }
    }

    stage('Push Image') {
        steps {
            sh 'docker push $DOCKER_IMAGE:latest'
        }
    }

    stage('Deploy Container') {
        steps {
            sh '''
            docker rm -f electro_cont || true
	    docker run -d -p 80:80 --name electro_cont $DOCKER_IMAGE:latest
            '''
        }
    }

}

}
