pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'manoj701m'
        DOCKERHUB_PASSWORD = 'Mrmanojn1'
        IMAGE_NAME = 'simplejavaapp'
        TAG = "${env.BUILD_NUMBER}"
        DOCKERFILE_PATH = './Dockerfile'
    }
    
    stages {
        stage('Check Username') {
            steps {
                script {
                    // Use 'whoami' command to get the current username
                    def username = sh(script: 'whoami', returnStdout: true).trim()
                    // Print the username
                    echo "Current username: ${username}"
                }
            }
        }

        stage('Checkout the repo') {
            steps {
                script {
                    // Checkout the Git repository
                    git branch: 'master', url: 'https://github.com/manoj701m/Amazon.git'
                }
            }
        }

        stage('Build and Package') {
            steps {
                script {
                    // Run Maven build
                    sh 'mvn clean install'
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Docker login using hardcoded credentials
                    echo "Logging in to Docker Hub"
                    sh "docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}"

                    // Build Docker image
                    echo "Building Docker image"
                    sh "docker build -t ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG} -f ${DOCKERFILE_PATH} ."
                    
                    // Push Docker image to Docker Hub
                    echo "Pushing Docker image to Docker Hub"
                    sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}"
                }
            }
        }
        stage('Stop and Remove Container on Port 9001') {
            steps {
                script {
                    // Check if a container is running on port 9001
                    def containerId = sh(script: 'docker ps -q --filter "expose=9001"', returnStdout: true).trim()

                    if (containerId) {
                        // Stop the container
                        sh "docker stop ${containerId}"

                        // Remove the container
                        sh "docker rm ${containerId}"
                        
                        echo "Container on port 9001 stopped and removed."
                    } else {
                        echo "No container found running on port 9001."
                    }
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    // Run Docker container
                    sh "docker run -d -p 9001:8080 ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}"
                    sh "docker ps"
                }
            }
        }
    }

    post {
        always {
            script {
                // Cleanup: Logout from Docker Hub after the job is done
                echo "Logging out from Docker Hub"
                sh "docker logout"
            }
        }
    }
}
