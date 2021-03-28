pipeline {
  parameters {
    choice(name: 'build', choices: ['yes', 'no'], description: 'Build UOpt')
    choice(name: 'buildTests', choices: ['yes', 'no'], description: 'Run UOpt build tests')
    choice(name: 'MARCH', choices: ['x86-64', 'sandybridge', 'core2', 'amdfam10'], description: '')
    choice(name: 'deployLin', choices: ['no', 'yes'], description: 'Deploy to Linux Host')
    string(defaultValue: 'pc', description: 'Node name or label', name: 'host', trim: true)
    choice(name: 'deployWin', choices: ['no', 'yes'], description: 'Deploy to Windows Host')
    choice(name: 'testWin', choices: ['no', 'yes'], description: 'Deploy to Windows Host')
    string(defaultValue: 'vm-win10', description: 'Node name or label', name: 'winhost', trim: true)
    string(defaultValue: 'ruopt', description: 'Test suite name(s)', name: 'suite', trim: true)
    string(name: 'SERVER_HOST', defaultValue: 'relvm', description: 'Upload archives to web server')
  }

  agent any

  stages {

    stage('UOpt Build') {
      when { expression { params.build == "yes" } }
      steps {
        build(job: "R2X")
      }
    }

    stage('UOpt Upload to Server') {
      when { expression { params.SERVER_HOST.length() > 0 } }
      steps {
        build(job: "R2X-deploy-archives",
              parameters: [string(name: 'SERVER_HOST', value: "${params.SERVER_HOST}")]
        )
      }
    }
  }
}
