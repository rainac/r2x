pipeline {
  parameters {
    string(name: 'BUILDID', defaultValue: '', description: 'Unused')
    string(name: 'branch', defaultValue: 'master', description: 'Unused')
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
                  branches: [[name: "*/$branch"]],
                  doGenerateSubmoduleConfigurations: false,
                  extensions: [
                               [$class: 'CleanBeforeCheckout'],
                               [$class: 'LocalBranch', localBranch: '**'],
                               [$class: 'RelativeTargetDirectory', relativeTargetDir: 'r2x']
                               ],
                  submoduleCfg: [],
                  userRemoteConfigs: [[credentialsId: 'joy-fs', url: "$GIT_URL"]]])

        sh 'ls -l'
        sh 'ls -l r2x'
      }
    }

    stage('build') {
      steps {
        sh 'cd r2x && make package'
        sh 'ls -l'
        sh 'ls -l r2x'
      }
    }

    stage('pack') {
      steps {
        dir("r2x") {
          sh 'env | sort | grep GIT_            > buildinfo.txt'
          sh "echo 'branch=$branch'            >> buildinfo.txt"
          sh 'git rev-parse HEAD               >> buildinfo.txt'
          sh 'git rev-parse --abbrev-ref HEAD  >> buildinfo.txt'
          archiveArtifacts 'buildinfo.txt'
          archiveArtifacts 'r2x_*.tar.gz'
        }
      }
    }
  }
}
