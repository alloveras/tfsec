#!/usr/bin/env bash

# Builds, tests, and generates the binary artifacts of a tfsec release.

set -eu -o pipefail

BINARY="tfsec"
TAG="${BUILDKITE_TAG}"
OUTPUT_DIR="bin"

# Here is the documentation for the provided build arguments:
# -ldflags: used to pass in flags to the underlying linker in the Go toolchain
#     -X: used to write information into a variable at link time, in this case the version is being updated
#     -s: omit the symbol table and debug information
#     -w: omit the DWARF symbol table
# -extldflags: Set space-separated flags to pass to the external linker.
#     -fno-PIC: Do not use position-independent code (PIC).
#     -static: Does not require dependency or dynamic libraries at runtime to run
GO_BUILD_ARGS=("-ldflags" "-X github.com/Canva/tfsec/version.Version=${TAG} -s -w -extldflags '-fno-PIC -static'")

main () {
  # Force using Go modules even if the project is checked-out within GOPATH. Requires go.mod to work.
  export GO111MODULE=on

  # Disabling C compilation support as tfsec is purely written in Go.
  export CGO_ENABLED=0

  # The -mod=vendor flag (e.g., go build -mod=vendor) instructs the go commands to use the main
  # module's top-level vendor directory to satisfy dependencies.
  export GOFLAGS=-mod=vendor

  # Make sure the output directory exists and it's empty.
  rm -rf "${OUTPUT_DIR}"
  mkdir -p "${OUTPUT_DIR}"

  # Note that `go test -v` will produce an exit code != 0 if any test fails.
  go test -v ./...

  # Set the operating system before building the binaries
  GOOS="darwin" GOARCH="amd64" go build -o "${OUTPUT_DIR}/${BINARY}-${TAG}-darwin-amd64" "${GO_BUILD_ARGS[@]}" ./cmd/tfsec
  GOOS="linux" GOARCH="amd64" go build -o "${OUTPUT_DIR}/${BINARY}-${TAG}-linux-amd64" "${GO_BUILD_ARGS[@]}" ./cmd/tfsec
}

main "$@"
