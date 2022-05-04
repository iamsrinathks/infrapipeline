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

            withAWS(credentials:'aws_jenkins_cred') {
                sh 'terraform plan'
            }


            }
        }
        stage('terraform apply') {
            steps {
                withAWS(credentials:'aws_jenkins_cred') {
                  sh 'terraform apply --auto-approve'
              }

            }
        }
    }
}
