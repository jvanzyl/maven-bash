#!/usr/bin/env bash

function mavenCoordinateToArtifactPath() {
  # Standard format for a Maven coordinate:
  # <groupId>:<artifactId>[:<extension>[:classifier]]:<version>
  # $1 = coordinate
  IFS=':' read -ra coordinateParts <<< "$1"
  groupId=$(echo ${coordinateParts[0]} | sed 's/\./\//g')
  artifactId=${coordinateParts[1]}
  if [ ${#coordinateParts[@]} -eq 3 ]; then
    # <groupId>:<artifactId>:<version>
    version=${coordinateParts[2]}
    artifactPath="${groupId}/${artifactId}/${version}/${artifactId}-${version}.jar"
  elif [ ${#coordinateParts[@]} -eq 4 ]; then
    # <groupId>:<artifactId>:<extension>:<version>
    version=${coordinateParts[3]}
    extension=${coordinateParts[2]}
    artifactPath="${groupId}/${artifactId}/${version}/${artifactId}-${version}.${extension}"
  elif [ ${#coordinateParts[@]} -eq 5 ]; then
    # <groupId>:<artifactId>:<extension>:<classifier>:<version>
    version=${coordinateParts[4]}
    extension=${coordinateParts[2]}
    classifier=${coordinateParts[3]}
    artifactPath="${groupId}/${artifactId}/${version}/${artifactId}-${version}-${classifier}.${extension}"
  fi
  echo $artifactPath
}

function mavenMetadataPath() {
  # Standard format for a Maven coordinate:
  # <groupId>:<artifactId>[:<extension>[:classifier]]:<version>
  # $1 = coordinate
  IFS=':' read -ra coordinateParts <<< "$1"
  groupId=$(echo ${coordinateParts[0]} | sed 's/\./\//g')
  artifactId=${coordinateParts[1]}
  if [ ${#coordinateParts[@]} -eq 3 ]; then
    # <groupId>:<artifactId>:<version>
    version=${coordinateParts[2]}
    metadataPath="${groupId}/${artifactId}/maven-metadata.xml"
  elif [ ${#coordinateParts[@]} -eq 4 ]; then
    # <groupId>:<artifactId>:<extension>:<version>
    version=${coordinateParts[3]}
    extension=${coordinateParts[2]}
    metadataPath="${groupId}/${artifactId}/${version}/maven-metadata.xml"
  elif [ ${#coordinateParts[@]} -eq 5 ]; then
    # <groupId>:<artifactId>:<extension>:<classifier>:<version>
    version=${coordinateParts[4]}
    extension=${coordinateParts[2]}
    classifier=${coordinateParts[3]}
    metadataPath="${groupId}/${artifactId}/${version}/maven-metadata.xml"
  fi
  echo $metadataPath
}

function mavenProjectVersion() {
  # $1 = pom.xml

  # Strip all the whitespace out of the pom.xml
  pom=`cat "$1" | tr -d " \t\n\r"`

  # If a parent element exists extract the specified version
  if grep -q '<parent>' <<< "${pom}"
  then
    parentVersion=`echo "${pom}" | \
      sed -n "s@\(.*\)\(<parent>.*</parent>\)\(.*\)@\2@p" | \
      sed -n "s@\(.*<version>\)\(.*\)\(</version>\)\(.*\)@\2@p"`
  fi

  # Strip out all blocks that may contain a <version/> tag which will only
  # leave the project version if it's present
  version=`echo "${pom}" | \
    sed -e 's@<dependencyManagement>.*</dependencyManagement>@@' | \
    sed -e 's@<properties>.*</properties>@@' | \
    sed -e 's@<profiles>.*</profiles>@@' | \
    sed -e 's@<dependencies>.*</dependencies>@@' | \
    sed -e 's@<build>.*</build>@@' | \
    sed -e 's@<parent>.*</parent>@@' | \
    sed -n "s@\(.*<version>\)\(.*\)\(.*</version>\)\(.*\)@\2@p"`

  # If the project version is present use it, otherwise use the parent version
  [ ! -z "${version}" ] && echo "${version}" || echo "${parentVersion}"
}
