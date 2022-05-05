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
            withCredentials([usernamePassword(credentialsId: 'aws_jenkins_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {pipeline {
    agent {
      kubernetes {
    yaml '''
      apiVersion: v1
      kind: Pod
      metadata:
        labels:
          build: agent
      spec:
        containers:
        - name: terraform
          image: hashicorp/terraform:1.2.0-rc1
          command:
          - cat
          tty: true
      '''
  }
    }
    

    stages {
        stage('terraform format check') {
          container('terraform') {
            steps{
              sh 'terraform fmt'
            }
          }
        }

        stage('terraform init') {
            container('terraform') {
            steps {
                sh 'terraform init'
            }
          }
        }
      }
    }

    stage('terraform apply') {
      steps {


        stage('terraform plan') {
            container('terraform') {
            steps {
            withCredentials([usernamePassword(credentialsId: 'aws_jenkins_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
              sh 'terraform apply --auto-approve'
            }
          } else {
            withCredentials([usernamePassword(credentialsId: 'aws_jenkins_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                sh 'terraform ${params.Action} --auto-approve'
              }
            }
            }
          }
        }
      }
    }

}

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
