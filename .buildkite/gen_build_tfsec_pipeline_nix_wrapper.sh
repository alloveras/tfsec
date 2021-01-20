#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash default.nix

# nix wrapper of gen_build_tfsec_pipeline.py script

set -eu -o pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

main() {
    exec "${SCRIPT_DIR}/gen_build_tfsec_pipeline.py"
}

main "$@"
