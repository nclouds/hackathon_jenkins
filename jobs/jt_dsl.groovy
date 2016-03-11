job('jt-dsl-job-test') {

  parameters {
     stringParam('deploy_branch', 'vpn-test')
     stringParam('s3_bucket_name', 'navdeep-test')
   }

  scm {
        git {
            remote {
                github('nclouds/vpn', 'https','bitbucket.org')
                credentials('navdeep-bitbucket-account')
            }
           branch('*/$deploy_branch')
        }
    }

  steps {
    shell('berks package cookbooks.tar.gz')
    shell('aws s3 cp cookbooks.tar.gz s3://$s3_bucket_name/')
  }

}
