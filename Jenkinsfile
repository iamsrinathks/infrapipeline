pipeline {
    agent {
        label 'infra'
    }

    stages {
        stage('terraform format check') {
            steps{
              sh 'terraform fmt'
            }
        }

        stage('terraform init') {
            steps {
                sh 'terraform init'
            }
        }


        stage('terraform plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('terraform apply') {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
    }
}
