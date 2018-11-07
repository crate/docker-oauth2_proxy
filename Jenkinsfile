pipeline {
  agent none
  environment {
    AZ_REGISTRY = 'crate'
    DOCKER_IMAGE_NAME = 'crate/oauth2_proxy'
  }
  stages {
    stage('build') {
      parallel {
        stage('master') {
          when {
            beforeAgent true
            branch 'master'
          }
          agent {
            label 'az'
          }
          steps {
            container('az') {
              sh 'az login --service-principal -u ${AZ_ACR_USER} -p ${AZ_ACR_PASS} --tenant crate.io'
              sh 'az acr build --registry ${AZ_REGISTRY} --image ${DOCKER_IMAGE_NAME}:latest --no-format .'
            }
          }
        }
        stage('tag') {
          when {
            beforeAgent true
            buildingTag()
          }
          agent {
            label 'az'
          }
          steps {
            container('az') {
              sh 'az login --service-principal -u ${AZ_ACR_USER} -p ${AZ_ACR_PASS} --tenant crate.io'
              sh 'az acr build --registry ${AZ_REGISTRY} --image ${DOCKER_IMAGE_NAME}:${TAG_NAME} --no-format .'
            }
          }
        }
      }
    }
  }
}
