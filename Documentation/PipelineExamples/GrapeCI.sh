#!/bin/bash
export PATH=/usr/local/bin:/usr/local/lib/ruby/gems/2.7.0/bin:$PATH
set -e -x -o pipefail

# Set Variables
PROJECT="GrapeCI"
SCHEME=$PROJECT
SOURCES_DIR=$PROJECT
TESTS_DIR="GrapeCITests"
BUILD_DIR="build"

SONAR_URL="https://sonarcloud.io"
SONAR_LOGIN="sonar-key-here"
SONAR_ORGANIZATION="rmaqueda-github"

# Git Clean and Check out
git clean -f -d
git fetch --prune --no-tags --quiet
if [ -n "$PR_BRANCH" ]; then
    git reset --hard origin/$PR_BRANCH
else
    git reset --hard origin/$MAIN_BRANCH
fi

# Update dependencies
carthage update --platform macOS --cache-builds --color never

# Build
xcodebuild \
-project $PROJECT.xcodeproj \
-scheme $SCHEME \
-derivedDataPath $BUILD_DIR \
-enableCodeCoverage YES \
clean build test | xcpretty --test --no-color

# Lint
swiftlint lint --quiet --reporter json $SOURCES_DIR > swiftlint.json || true

# Generate Cobertura files
slather coverage --sonarqube-xml --scheme GrapeCI --output-directory . --build-directory build GrapeCI.xcodeproj || true

# Upload to Sonar Cloud
if [ -n "$PR_BRANCH" ]; then

sonar-scanner \
    -Dsonar.host.url=$SONAR_URL \
    -Dsonar.login=$SONAR_LOGIN \
    -Dsonar.organization=$SONAR_ORGANIZATION \
    -Dsonar.projectKey=$PROJECT \
    -Dsonar.sources=$SOURCES_DIR \
    -Dsonar.tests=$TESTS_DIR \
    -Dsonar.pullrequest.key=$PR_ID \
    -Dsonar.pullrequest.branch=$PR_BRANCH \
    -Dsonar.pullrequest.base=$PR_BASE \
    -Dsonar.pullrequest.provider=$PROVIDER \
    -Dsonar.pullrequest.github.repository=$REPOSITORY \
    -Dsonar.language=swift \
    -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml \
    -Dsonar.swift.coverage.reportPattern=sonarqube-generic-coverage.xml \
    -Dsonar.swift.swiftLint.reportPaths=swiftlint.json  || true

else

sonar-scanner \
    -Dsonar.host.url=$SONAR_URL \
    -Dsonar.login=$SONAR_LOGIN \
    -Dsonar.organization=$SONAR_ORGANIZATION \
    -Dsonar.projectKey=$PROJECT \
    -Dsonar.sources=$SOURCES_DIR \
    -Dsonar.tests=$TESTS_DIR \
    -Dsonar.language=swift \
    -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml \
    -Dsonar.swift.coverage.reportPattern=sonarqube-generic-coverage.xml \
    -Dsonar.swift.swiftLint.reportPaths=swiftlint.json || true
    
fi