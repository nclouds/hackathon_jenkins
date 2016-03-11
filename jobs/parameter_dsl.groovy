job('navdeep-test-dsl-job') {

readFileFromWorkspace('parameters.xml')

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
