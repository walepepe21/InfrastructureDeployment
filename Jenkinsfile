pipeline {
    agent any
    environment {
<<<<<<< HEAD
        AWS_ACCOUNT_ID="xxxxxxxxxxx"
        AWS_DEFAULT_REGION="us-east-1"     
    }
    stages {
        stage('Git checkout') {
            steps {
                git 'https://github.com/tkibnyusuf/Infrastructure_Provisioning.git'
            }
        }
        
        stage('provision eks-cluster') {
=======
        AWS_ACCOUNT_ID="775012328020"
        AWS_DEFAULT_REGION="us-east-1"     
    }
    stages {
        stage('provision sonarqube-server') {
>>>>>>> b552ef057e5bf39dc451430a2da084d19bd488cc
           environment {
             AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
             AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
           }
           steps {
              script {
<<<<<<< HEAD
                  sh "terraform init"
                  sh "terraform validate"
                  sh "terraform plan"
                  sh " terraform destroy --auto-approve"
=======
                   sh "terraform init"
                   sh "terraform validate"
                   sh "terraform plan"
                   sh "terraform destroy --auto-approve"
>>>>>>> b552ef057e5bf39dc451430a2da084d19bd488cc
            }
        }
               
     }
    }
    
}
