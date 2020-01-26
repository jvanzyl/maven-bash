# Maven project version for BASH

A simple bash script/function to get the project version from a Maven `pom.xml` file.

## Usage

Use the provided `mpv` script:

```
./mpv pom.xml

which will output a single string with the project version

1.0.0
```

Or you can copy the function into any of your scripts that need to work with Maven `pom.xml` files to extract the version.

## Running Tests

If you want run the tests you need to install [BATS](https://github.com/bats-core/bats-core). BATS is a testing tool for BASH scripts/functions.

Running the tests should produce something like the following:

```
./mpv-tests-runner

bash-3.2$ ./mpv-tests-runner
 ✓ Find project version in parent element
 ✓ Find project version in project

2 tests, 0 failures
```
