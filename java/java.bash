#!/usr/bin/env bash

export JAVA_HOME_14=$(/usr/libexec/java_home -v14)
if [ -n "$JAVA_HOME_14" ]; then
    export JAVA_HOME=$JAVA_HOME_14
fi
