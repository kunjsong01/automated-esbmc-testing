#!/bin/sh

# Set arguments:
# - REGRESSION_ARGS: which test suite to run
# - TOOL_ARGS: which esbmc binary
# - MODE_ARGS: ALL|CORE|KNOWNBUG
# - LIBRARY_ARGS: C++ OM library
REGRESSION_ARGS="--regression"
TOOL_ARGS="--tool"
MODE_ARGS="--mode"
LIBRARY_ARGS="--library"

TRUE=1
FALSE=0
WITH_LIBRARY=FALSE

# Ubuntu setup (pre-config)
ubuntu_setup () {
    # Tested on ubuntu 22.04
    echo "Configuring Ubuntu build"
    sudo apt-get update && sudo apt-get install -y clang clang-tidy python-is-python3 csmith python3 git ccache unzip wget curl libcsmith-dev gperf libgmp-dev cmake bison flex gcc-multilib linux-libc-dev libboost-all-dev ninja-build python3-setuptools libtinfo-dev pkg-config python3-pip python3-toml python-is-python3 openjdk-11-jdk &&
    # Hack: Boolector might fail to download some dependencies using curl (maybe we should patch it?)
    # curl: (60) SSL: no alternative certificate subject name matches target host name 'codeload.github.com'
    # As a unsafe workaround... we can just tell curl to be unsafe
    echo "insecure" > $HOME/.curlrc
}

# Detect the platform ($OSTYPE was not working on github actions for ubuntu)
# Note: Linux here means Ubuntu, this will mostly not work anywhere else.
OS="`uname`"
case $OS in
  'Linux')
    ubuntu_setup
    ;;
  *) echo "Unsupported OS $OSTYPE" ; exit 1; ;;
esac || exit $?

# Setup build flags (regression, tool, mode, library)
while getopts r:t:m:l: flag
do
    case "${flag}" in
        r) REGRESSION_ARGS="$REGRESSION_ARGS ${OPTARG}";;
        t) TOOL_ARGS="$TOOL_ARGS ${OPTARG}";;
        m) MODE_ARGS="$MODE_ARGS ${OPTARG}";;
        l) LIBRARY_ARGS="$LIBRARY_ARGS ${OPTARG}"
           WITH_LIBRARY=TRUE;;
    esac
done

# unzip the binaries
unzip ./esbmc_binary.zip

# Run the test suite
printf "Run python script:"
if [ $WITH_LIBRARY -eq 1]
then
  printf " '%s'" testing_tool_old.py $REGRESSION_ARGS $TOOL_ARGS $MODE_ARGS
  # Run test suite with the given arguments
  python3 testing_tool_old.py $REGRESSION_ARGS $TOOL_ARGS $MODE_ARGS
else
  printf " '%s'" testing_tool_old.py $REGRESSION_ARGS $TOOL_ARGS $MODE_ARGS $LIBRARY_ARGS
  # Run test suite with the given arguments
  python3 testing_tool_old.py $REGRESSION_ARGS $TOOL_ARGS $MODE_ARGS $LIBRARY_ARGS
fi
