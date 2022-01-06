#!/bin/zsh

JAVA_HOME_11=$(/usr/libexec/java_home -v11 2>/dev/null)
if [ -n "$JAVA_HOME_11" ]; then
    export JAVA_HOME=$JAVA_HOME_11
fi
