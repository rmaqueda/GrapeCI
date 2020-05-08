### GRAPECI


## What is GrapeCI?

It's a work in progress, **serverless**, continuous integration software written in Swift.

Connect your Bitbucket or GitHub accounts and set up a build script for yours repository.
GrapeCI launch the build script when these changes are detected:

* New commit on the default branch
* New commit on a pull request

When the build script finish, a build status is created for this commit.

## How to install?

Easy way from this repository:

* [Download](https://raw.githubusercontent.com/rmaqueda/GrapeCI/develop/Archive/GrapeCI.app-1.0.0.tar.gz), unzip and install
* If an security alert appear, Go to: *Preferences -> Security* and allow run GrapeCI


Build by yourself:

* Update dependencies with Carthage
* Open Xcode project
* Edit the GrapeCI scheme and write the oauth secrets enviroment varialbes (You will need to setup the aouth configuration firstly on [Github](https://github.com/settings/applications/new) or [Bitbucket](https://developer.atlassian.com/cloud/bitbucket/oauth-2/))
* Run or Archive the project

## Build script

To create a custom builds for different scenarios, the build script receives these environment variables:

* REPOSITORY: Repository Name
* MAIN_BRANCH: The repository default branch 
* PROVIDER: GitHub or BitBucket
* PR_BRANCH: Destination branch name for pull request
* PR_BASE: Origin branch name for pull request
* PR_ID: Pull request identifier

The [documentation folder](./Documentation/PipelineExamples/) contains examples of build scripts for direcrent types of projects and tools:

* [MACOS](./Documentation/PipelineExamples/GrapeCI.sh)
* [iOS](./Documentation/PipelineExamples/OpenWeather.sh)
* [Command line tool](./Documentation/PipelineExamples/CryptoParrot.sh)


## Why am I building this?

* Learn Swift Combine and SwiftUI
* Have a free and easy to setup continuous integration tool
* Have fun :)
