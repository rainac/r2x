pipeline {
  parameters {
    string(name: 'BUILDID', defaultValue: '', description: 'Unused')
  }
  agent {
    dockerfile {
      filename 'Dockerfile'
      dir 'docker/debian/10-buster'
      label "builder"
      additionalBuildArgs  '--build-arg version=1.0.2'
      args '-v /tmp:/tmp'
    }
  }
  stages {
    stage('get-version') {
      steps {
        sh 'ls -l'
      }
    }
    stage('checkout') {
      steps {

        sh 'env|sort'

        checkout([$class: 'GitSCM',
                  branches: [[name: "*/master"]],
                  doGenerateSubmoduleConfigurations: false,
                  extensions: [
                               [$class: 'CleanBeforeCheckout'],
                               [$class: 'RelativeTargetDirectory', relativeTargetDir: 'r2x']
                               ],
                  submoduleCfg: [],
                  userRemoteConfigs: [[credentialsId: 'joy-fs', url: 'famserv:git/r2x']]])

        sh 'ls -l'
        sh 'ls -l r2x'
      }
    }

    stage('build') {
      steps {
        sh 'cd r2x && git checkout dev -- Makefile'
        sh 'cd r2x && make package'

        sh 'ls -l'
        sh 'ls -l r2x'
      }
    }

    stage('pack') {
      steps {
        archiveArtifacts 'r2x/r2x_*.tar.gz'
      }
    }
  }
}
