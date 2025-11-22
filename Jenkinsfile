pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-app-image"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
				url: 'https://github.com/gergpav/Docker-Homework.git',
				credentialsId: '0d791734-74dc-4d65-bbc3-76ebdb689ddb'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'chmod +x jenkins/build.sh'
                sh './jenkins/build.sh'
            }
        }

        stage('Test Container (optional)') {
            steps {
                sh 'docker run --rm my-app-image:latest python -c "print(1+1)"'
            }
        }

        stage('Publish Image (optional)') {
            when {
                expression { return env.BRANCH_NAME == "master" }
            }
            steps {
                // docker login -u $DOCKER_USER -p $DOCKER_PASS
                // sh "docker push ${IMAGE_NAME}:latest"
                echo "You can enable push to registry here"
            }
        }
    }

    post {
        success {
            echo "Build succeeded!"
        }
        failure {
            echo "Build failed!"
        }
    }
}
