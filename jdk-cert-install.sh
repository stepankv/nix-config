#!/usr/bin/env bash

set -eu

# Check if java on PATH
java --version

# Downloads TCS certificates.
cert=$(mktemp -t "$(basename "$0")")
wget -O "$cert" "url-path"

# Patch JDK specified by JAVA_HOME variable.
export JDK_KEYSTORE="${JAVA_HOME}/lib/security/cacerts"
for N in $(seq 0 $((3 -1))); do
  cat "$cert" \
    | awk "n==$N {print }; /END CERTIFICATE/ { n++ }" \
    | keytool -noprompt -import -trustcacerts -alias "TCS_$N" -keystore ${JDK_KEYSTORE} -storepass changeit;
done
rm "$cert"

