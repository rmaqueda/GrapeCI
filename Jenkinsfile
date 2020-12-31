node {
    
	ansiColor('xterm') {

	  stage('Checkout and Setup') {
			checkout scm
		}

	  stage('Install depencies') {
	    sh script:
	    '''
	      #!/bin/bash
	      carthage update --platform macos
	      bundle install
	    '''
	  }

		stage('Test') {
			sh script:
			'''
	      #!/bin/bash
        security unlock-keychain -p `whoami` ${HOME}/Library/Keychains/login.keychain
				bundle exec fastlane macos tests
	    '''
		}

		post {
    	always {
				junit 'fastlane/test_output/*.junit'
			}
		}

	}

}
