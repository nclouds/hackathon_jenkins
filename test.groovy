import Params

def params = new Params()

job("${params.conf.env}-ken-demo-dsl-job") {

  parameters {
    stringParam('deploy_branch', "${params.config.branch}")
     stringParam('env', "${params.conf.env}")
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
        shell('build.sh')
  }
}
