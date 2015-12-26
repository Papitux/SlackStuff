#!/bin/sh
export JAVA_HOME=/usr/lib_slkbit/java
export MANPATH="${MANPATH}:${JAVA_HOME}/man"
export PATH="${PATH}:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin"
cd /opt/ovtr
java -Xmx512m -jar org.leo.traceroute.jar