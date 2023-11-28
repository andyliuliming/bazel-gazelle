#!/usr/bin/env bash

set -euo pipefail
set -x
THIS_DIR=$(cd "$(dirname "$0")" && pwd)

release_tag=${1}

if [[ -z "${release_tag}" ]]; then
  echo "Usage: $0 <release_tag>"
  exit 1
fi

git checkout ${release_tag}

mkdir -p ${THIS_DIR}/output
pushd ${THIS_DIR}/cmd/gazelle
    goos=(darwin linux)
    goarch=(amd64 arm64)

    for os in "${goos[@]}"; do
        for arch in "${goarch[@]}"; do
            export GOOS=${os}
            export GOARCH=${arch}
            export CGO_ENABLED=0
            go build -o gazelle-${os}-${arch}-${release_tag}
        done
    done
popd
