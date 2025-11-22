pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-app-image"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/YOUR_USERNAME/YOUR_REPO.git'
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
                expression { return env.BRANCH_NAME == "main" }
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
