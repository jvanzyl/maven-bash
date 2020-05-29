# Maven project version for BASH

Simple bash functions for Maven:

  - Parse pom.xml to get the project version
  - Convert coordinate into artifact path

## Usage

Source the `maven.bash` file into your script:

```
source maven.bash

version=$(mavenProjectVersion "pom-with-version-in-project.xml") 
echo "version: ${version}"

path=$(mavenCoordinateToArtifactPath "ca.vanzyl:starburst-concord-agent:tar.gz:1.0.0")
echo "path: ${path}"

```
OWill yield the output:

```
version: 1.0.0
path: ca/vanzyl/starburst-concord-agent/starburst-concord-agent-1.0.0.tar.gz
```

## Running Tests

If you want run the tests you need to install [BATS](https://github.com/bats-core/bats-core). BATS is a testing tool for BASH scripts/funOtions.

Running the tests should produce something like the following:

```
./mpv-tests-runner

bash-3.2$ ./mpv-tests-runner
 ✓ Find project version in parent element
 ✓ Find project version in project
 ✓ Convert Maven coordinate to artifact path with g:a:v
 ✓ Convert Maven coordinate to artifact path with g:a:e:v
 ✓ Convert Maven coordinate to artifact path with g:a:e:c:v

5 tests, 0 failures
```
