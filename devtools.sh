#!/bin/bash

### Copyright (2022-2023) Variocube GmbH
### This program supports setting up or refreshing Variocube software projects.

### Utility functions

# Die with an error message
die() {
	echo >&2 "$@"
	exit 1
}

# Print the usage message
usage() {
  die "Usage: $0 <command> [command]"
}

# Print the help screen
help() {
  echo "Variocube project setup tool"
  echo ""
  echo "Supported commands:"
  echo "    setup:          Setup this project from scratch, runs an initial npm run dev if a package.json is found and"
  echo "                    a ./gradlew build if a build.gradle is found."
  echo "    assertSetup:    Checks if all prerequisites are met and exits with an error if not."
  echo ""

  if [ ! -z "$1" ] ; then
    case "$1" in
      setup)
        echo "Setup does not require any additional parameters and tries to setup this project from scratch."
        ;;
      assertSetup)
        echo "assertSetup does not require any additional parameters and checks if all prerequisites are met."
        ;;
    esac
  fi

  usage
}

### Global variables and setup
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_FILE="$SCRIPT_DIR/.vc"
DEVTOOLS_DIR="$SCRIPT_DIR/.devtools"

# Init an empty .vc configuration
init() {
# Create initial .vc configuration file
  cat << EOF > "$CONFIG_FILE"
JAVA_VERSION=11
NODE_VERSION=14
NPM_VERSION=8
EOF
# Create .devtools directory and clone devtools
	mkdir "$DEVTOOLS_DIR"
  wget https://github.com/variocube/devtools/archive/refs/heads/main.zip -O "${SCRIPT_DIR}/devtools.zip"
  unzip "${SCRIPT_DIR}/devtools.zip"
  mv "${SCRIPT_DIR}/devtools-main" "${SCRIPT_DIR}/.devtools"
  rm "${SCRIPT_DIR}/devtools.zip"
}


if [ "$1" == "init" ] ; then
  if [[ -f "${CONFIG_FILE}" ]] ; then
    die "Configuration file already exists, aborting. Please delete ${CONFIG_FILE} if you want to reinitialize."
  fi
  if [[ -d "${DEVTOOLS_DIR}" ]] ; then
  	die "Devtools directory already exists, aborting. Please delete ${DEVTOOLS_DIR} if you want to reinitialize."
	fi
  init
  exit 0
fi

### Check and source configuration file
if [[ ! -f "$CONFIG_FILE" ]] ; then
  die "Configuration file $CONFIG_FILE not found. Please run ${0} init first."
fi
source "$CONFIG_FILE"

### Library functions

# Assert that Java is installed and at a certain version
assertJavaVersion() {
  if [ -z "$1" ] ; then
    die "No Java version specified"
  fi
  if ! command -v java &> /dev/null ; then
    die "Java is not installed"
  fi
  JAVA_VER=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)
  [ "$JAVA_VER" == "$1" ] || die "Java version $1 is required but we found ${JAVA_VER}"
}

# Assert that Node is installed and at a certain version
assertNodeVersion() {
  if [ -z "$1" ] ; then
    die "No Node version specified"
  fi
  if ! command -v node &> /dev/null ; then
    die "Node is not installed"
  fi
  NODE_VER=$(node -v | sed '/^v/s///' | cut -d'.' -f1)
  [ "$NODE_VER" == "$1" ] || die "Node version $1 is required but we found ${NODE_VER}"
}

# Assert that NPM is installed and at a certain version
assertNpmVersion() {
  if [ -z "$1" ] ; then
    die "No NPM version specified"
  fi
  if ! command -v npm &> /dev/null ; then
    die "NPM is not installed"
  fi
  NPM_VER=$(npm -v | cut -d'.' -f1)
  [ "$NPM_VER" == "$1" ] || die "NPM version $1 is required but we found ${NPM_VER}"
}

# Check if AWS CLI is installed
assertAwsCli() {
  if ! command -v aws &> /dev/null ; then
    die "AWS CLI is not installed"
  fi
}

### Actual payload functions

# Assert machine setup
assertSetup() {
  assertJavaVersion "${JAVA_VERSION}"
  assertNodeVersion "${NODE_VERSION}"
  assertNpmVersion "${NPM_VERSION}"
  assertAwsCli
}

# Setup the project
setup() {
  assertSetup
  if [ -f "package.json" ]; then
    echo "Found package.json, running npm install..."
    npm install
  fi
  if [ -f "build.gradle" ]; then
    echo "Found build.gradle, running ./gradlew build..."
    ./gradlew build
  fi
}


# Check if we have any command at all
[ "$#" -ge 1 ] || usage

case "$1" in
  # Simple commands with no arguments
  setup)
    COMMAND="$1"
    shift
    ;;
  assertSetup)
    COMMAND="$1"
    shift
    ;;
  *)
    echo "Unknown command: $1"
    help
    ;;
esac

# Parse options
while getopts ":h:v:" OPTION; do
  case $OPTARG in
    h)
      help "${COMMAND}"
      ;;
    v)
      VERBOSE=1
      ;;
    *)
      die "Invalid option: -$OPTARG"
      ;;
  esac
done

case "$COMMAND" in
  setup)
    setup
    ;;
  assertSetup)
    assertSetup
    ;;
esac
