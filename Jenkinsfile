pipeline {
  agent {
    label 'kubernetes && az'
  }
  stages {
    stage('az login') {
      steps {
        container('az') {
          sh 'az login --service-principal -u ${AZ_ACR_USER} -p ${AZ_ACR_PASS} --tenant crate.io'
        }
      }
    }
    stage('az acr build') {
      parallel {
        stage('az acr build latest') {
          when {
            branch 'master'
          }
          steps {
            container('az') {
              sh 'az acr build --registry crate --image crate/oauth2_proxy:latest --no-format .'
            }
          }
        }
        stage('az acr build tag') {
          when {
            buildingTag()
          }
          steps {
            container('az') {
              sh 'az acr build --registry crate --image crate/oauth2_proxy:${TAG_NAME} --no-format .'
            }
          }
        }
      }
    }
  }
}
