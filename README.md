### GRAPECI


## What is GrapeCI?

It's a work in progress, **serverless**, **free**, continuous integration software written in Swift.

Connect your Bitbucket or GitHub accounts and set up a build script for yours repository.
GrapeCI launch the build script when these changes are detected:

* New commit on the default branch
* New commit on a pull request

When the build script finish, a build status is created for this commit.
You could setup checks in the repository to allow merge pull request only when the statues success.

## How to install?

* Update dependencies with Carthage
* Open Xcode project
* Edit the GrapeCI scheme and set the oauth secrets (you will need to setup this aouth configuration first on Github or Bitbucket)
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
* Have a **free** and easy to setup continuous integration tool
* Have fun :)
