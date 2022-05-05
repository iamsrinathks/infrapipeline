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
            withCredentials([usernamePassword(credentialsId: 'aws_jenkins_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                sh 'terraform plan'
              }

            }
        }
        stage('terraform apply') {
            steps {
              if (params.isapply == true) {
                 withCredentials([usernamePassword(credentialsId: 'aws_jenkins_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'terraform apply --auto-approve'
                  }
              }
             else {
                 withCredentials([usernamePassword(credentialsId: 'aws_jenkins_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'terraform destroy --auto-approve'
                }
            }
        }
    }
    post {
     always {
         deleteDir()
         cleanWs()
     }
  }
}
}
