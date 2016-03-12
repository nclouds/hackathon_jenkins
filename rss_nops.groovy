import Params

def params = new Params()

params.config.each { Map config ->

job("${config.env}-rss-demo-dsl-job") {
  parameters {
    stringParam('deploy_branch', "${config.branch}")
     stringParam('env', "${config.env}")
   }

   publishers {
        slackNotifications {
            notifyAborted()
            notifyFailure()
            notifyNotBuilt()
            notifyUnstable()
            notifyBackToNormal()
        }
    }

  scm {
        git {
            remote {
                github('nclouds/rss-integrator', 'ssh','bitbucket.org')
                credentials('f9eb3fc3-1176-436d-ac42-fd33e61b6651')
            }
           branch('*/$deploy_branch')
        }
    }

  steps {
    shell(readFileFromWorkspace('build.sh'))
  }

}
}
