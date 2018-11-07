pipeline {
  agent none
  environment {
    AZ_REGISTRY = 'crate'
    DOCKER_IMAGE_NAME = 'crate/oauth2_proxy'
  }
  stages {
    stage('build') {
      when {
        beforeAgent true
        branch 'master'
        buildingTag()
      }
      agent {
        label 'az'
      }
      steps {
        container('az') {
          sh 'az login --service-principal -u ${AZ_ACR_USER} -p ${AZ_ACR_PASS} --tenant crate.io'
          sh '''
            if [[ BRANCH_NAME = 'master' ]]; then
                IMAGE_LATEST="--image ${DOCKER_IMAGE_NAME}:latest"
            fi
            if [[ ! -z TAG_NAME ]]; then
                IMAGE_TAG="--image ${DOCKER_IMAGE_NAME}:${TAG_NAME}"
            fi
            az acr build --registry ${AZ_REGISTRY} ${IMAGE_LATEST} ${IMAGE_TAG} --no-format .
          '''
        }
      }
    }
  }
}
