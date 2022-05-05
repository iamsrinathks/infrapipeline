pipeline {
  agent any
  
  options {
        buildDiscarder(logRotator(daysToKeepStr: '7', numToKeepStr: '50'))
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
  }
  
  parameters {
    choice choices: ['apply', 'destroy'], description: 'Terraform apply / destroy', name: 'ACTION'
  }

  stages {
    stage('formatting and validating the files') {
      steps {
        sh 'terraform fmt'
        sh 'terraform validate -json'
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
