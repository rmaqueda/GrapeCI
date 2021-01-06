pipeline {

  agent any

  environment {
    KEYCHAIN = "${HOME}/Library/Keychains/login.keychain-db"
    KEYCHAIN_PASSWORD = credentials('KEYCHAIN_PASSWORD')
  }

  stages {

    stage('Unlock Keychain') {
      steps {
        sh 'security unlock-keychain -p ${KEYCHAIN_PASSWORD} ${KEYCHAIN}'
      }
    }

	  stage('Install Carthage depencies') {
	  	steps {
				sh 'carthage update --platform macos'
			}
		}

		stage('Test') {
			steps {
				sh 'fastlane macos tests'
			}
		}

	}

  post {
    always {
    	junit 'fastlane/test_output/*.junit'
      cleanWs()
    }
  }

}
