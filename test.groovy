import Params

def params = new Params()

params.config.each { Map config ->

job("${config.env}-ken-demo-dsl-job") {
  parameters {
    stringParam('deploy_branch', "${config.branch}")
     stringParam('env', "${config.env}")
   }

  scm {
        git {
            remote {
                github('nclouds/ken', 'https','bitbucket.org')
                credentials('navdeep-bitbucket-account')
            }
           branch('*/$deploy_branch')
        }
    }

  steps {
    shell(readFileFromWorkspace('build.sh'))
  }

}
}
