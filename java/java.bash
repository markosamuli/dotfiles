#!/usr/bin/env bash

JAVA_HOME_14=$(/usr/libexec/java_home -v14 2>/dev/null)
if [ -n "$JAVA_HOME_14" ]; then
    export JAVA_HOME=$JAVA_HOME_14
fi
