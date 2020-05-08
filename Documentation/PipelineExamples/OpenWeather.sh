#!/bin/bash
export PATH=/Users/ricardomaqueda/.gem/ruby/2.6.0/bin:/usr/local/opt/libressl/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/ricardomaqueda/Library/Python/2.7/bin/
set -e -x -o pipefail

# Set Variables
PROJECT="OpenWeather"
SCHEME=$PROJECT
SOURCES_DIR=$PROJECT
TESTS_DIR="OpenWeatherTests"
BUILD_DIR="build"

SONAR_URL="https://sonarcloud.io"
SONAR_LOGIN="sonar_secret_here"
SONAR_ORGANIZATION="rmaqueda-github"

cd OpenWeather

# Common

rm -f swiftlint.json
rm -f cobertura.xml
rm -f lizard.xml
rm -f tailor.txt

# Git Clean and Check out
git clean -f -d
if [ -n "$PR_BRANCH" ]; then
    git reset --hard origin/$PR_BRANCH
else
    git reset --hard origin/$MAIN_BRANCH
fi

# Build
xcodebuild \
-project $PROJECT.xcodeproj \
-scheme $SCHEME \
-derivedDataPath $BUILD_DIR \
-enableCodeCoverage YES \
-destination 'id=7D3CB139-B777-4342-BFC1-06A667D9FEE1' \
clean build test | xcpretty --test --no-color

# Lint
swiftlint lint --reporter json $SOURCES_DIR > swiftlint.json || true

# Generate Cobertura files
xccov-to-sonarqube-generic.sh $BUILD_DIR/Logs/Test/*.xcresult/ > cobertura.xml

# Complexity
tailor \
--no-color \
--max-line-length=180 \
--max-file-length=500 \
--max-name-length=40 \
--max-name-length=40 \
--min-name-length=3 \
$SOURCES_DIR > tailor.txt

# Lizar
lizard --languages swift --length 30 --CCN 3 --arguments 3 -Eduplicate --xml $SOURCES_DIR/* > lizard.xml

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
    -Dsonar.swift.swiftLint.reportPaths=swiftlint.json \
    -Dsonar.swift.lizard.report=lizard.xml \
    -Dsonar.swift.tailor.report=tailor.txt
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
    -Dsonar.swift.swiftLint.reportPaths=swiftlint.json \
    -Dsonar.swift.lizard.report=lizard.xml \
    -Dsonar.swift.tailor.report=tailor.txt
fi
