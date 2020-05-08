#!/bin/bash
export PATH=/Users/ricardomaqueda/.gem/ruby/2.6.0/bin:/usr/local/opt/libressl/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/ricardomaqueda/Library/Python/2.7/bin/:/usr/local/sbin/
set -e -x -o pipefail

# Set Variables
PROJECT="CryptoParrot"
SCHEME=$PROJECT
SOURCES_DIR="Source"
TESTS_DIR="Tests"
BUILD_DIR=".build"

SONAR_URL="https://sonarcloud.io"
SONAR_LOGIN="sonar_secret_here"
SONAR_ORGANIZATION="rmaqueda-github"

# Common
rm -f swiftlint.json
rm -f cobertura.xml
rm -f lizard.xml
rm -f tailor.txt

# Git Clean and Check out
git clean -f -d
git fetch --prune --no-tags --quiet
if [ -n "$PR_BRANCH" ]; then
    git reset --hard origin/$PR_BRANCH
else
    git reset --hard origin/$MAIN_BRANCH
fi

# Build
swift package clean
swift package resolve
swift package generate-xcodeproj --enable-code-coverage

xcodebuild -project CryptoParrot.xcodeproj \
    -scheme CryptoParrot \
    -derivedDataPath .build \
    -enableCodeCoverage YES \
    test | xcpretty --test --no-color


# Lint
swiftlint lint --quiet --reporter json $SOURCES_DIR > swiftlint.json || true

# Generate Cobertura files
xccov-to-sonarqube-generic.sh $BUILD_DIR/Logs/Test/*.xcresult/ > coverage.xml 2> /dev/null

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
    -Dsonar.coverageReportPaths=cobertura.xml \
    -Dsonar.swift.coverage.reportPattern=cobertura.xml \
    -Dsonar.swift.swiftLint.reportPaths=swiftlint.json

else

sonar-scanner \
    -Dsonar.host.url=$SONAR_URL \
    -Dsonar.login=$SONAR_LOGIN \
    -Dsonar.organization=$SONAR_ORGANIZATION \
    -Dsonar.projectKey=$PROJECT \
    -Dsonar.sources=$SOURCES_DIR \
    -Dsonar.tests=$TESTS_DIR \
    -Dsonar.language=swift \
    -Dsonar.coverageReportPaths=cobertura.xml \
    -Dsonar.swift.coverage.reportPattern=cobertura.xml \
    -Dsonar.swift.swiftLint.reportPaths=swiftlint.json

fi


