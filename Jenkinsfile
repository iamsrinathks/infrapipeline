pipeline {
  agent {
    label 'infra'
  }
  parameters {
    choice choices: ['apply', 'destroy'], description: 'Terraform apply / destroy', name: 'ACTION'
  }

  stages {
    stage('terraform format check') {
      steps {
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
        //withCredentials([usernamePassword(credentialsId: 'aws_jenkins_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
        //sh 'terraform apply --auto-approve'
        //}
        //

        script {
          if (params.ACTION == "apply") {
            withCredentials([usernamePassword(credentialsId: 'aws_jenkins_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
              sh 'terraform apply --auto-approve'
            }
          } else {
            withCredentials([usernamePassword(credentialsId: 'aws_jenkins_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
              sh 'terraform destroy --auto-approve'
            }
          }
        }
      }
    }
  }
}
