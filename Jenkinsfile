pipeline {
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
          resources:
            requests:
              memory: 100Mi
              cpu: 100m
            limits:
              memory: 300Mi
              cpu: 150m
          command:
          - cat
          tty: true
      '''
  }
    }


    stages {
        stage('terraform format check') {
            steps{
          container('terraform') {

              sh 'terraform fmt'
            }
          }
        }


        stage('terraform init') {
            steps {
            container('terraform') {

                sh 'terraform init'
            }
          }
        }


        stage('terraform apply') {
          steps {

                container('terraform') {
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'aws_jenkins_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                            sh 'terraform apply --auto-approve'
                          }
                    }
                }

          }
        }

      }
}
