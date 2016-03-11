import Prams

def params = new Prams()

job('uat-dsl-job-demo') {

  parameters {
    stringParam('deploy_branch', "${params.branch}")
   }

  scm {
        git {
            remote {
                github('nclouds/rss-integrator', 'ssh','bitbucket.org')
                credentials('jenkins')
            }
           branch('*/${params.branch}')
        }
    }

  steps {
    shell(readFileFromWorkspace('build.sh'))
    shell('ansible-playbook -v -i deploy/hosts deploy/rss.yml --extra-vars deploy_version=${params.branch} --vault-password-file /var/lib/jenkins/ken/rss-vault-password.txt')
  }

}
