pipeline {
  parameters {
    choice(name: 'cleanOld', choices: ['no', 'yes'], description: 'Delete old download archives')
    string(name: 'SERVER_HOST', defaultValue: 'relvm', description: '')
  }
  agent {
    label "linux"
  }
  stages {
    stage('get-version') {
      steps {
        sh 'ls -l'
        sh 'pwd'
        sh 'uname -a'
        sh 'hostname'
        sh 'env|sort'
      }
    }
    stage('checkout') {
      steps {
        step([  $class: 'CopyArtifact',
                filter: 'r2x/r2x_*.tar.gz',
                fingerprintArtifacts: true,
                flatten: true,
                projectName: "R2X"
        ])
        sh 'ls -l'
      }
    }
    stage('clean') {
      when { expression { params.cleanOld == "yes" } }
      environment {
        LANG = "C"
        LC_ALL = "C"
        LANGUAGE = "C"
      }
      steps {
        sshagent(credentials : ['joy-fs']) {
          sh "ssh ${params.SERVER_HOST} rm /var/www/ai-and-it.de/download/r2x_*.tar.gz"
        }
      }
    }
    stage('build') {
      environment {
        LANG = "C"
        LC_ALL = "C"
        LANGUAGE = "C"
      }
      steps {
        sshagent(credentials : ['joy-fs']) {
            sh "scp r2x_*.tar.gz ${params.SERVER_HOST}:/var/www/ai-and-it.de/download"
            sh "ssh ${params.SERVER_HOST} ls -l /var/www/ai-and-it.de/download"
        }
      }
    }
  }
}
