#!/usr/bin/env bash

set -eo pipefail
[[ "$TRACE" ]] && set -x
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../ && pwd )"

echo "generating base dockerfiles"
alpine_versions=(3.4 3.5 3.6)
for v in ${alpine_versions[@]}; do
    echo "generating alpine:${v}-dev Dockerfile"
    sed 's~^FROM.*$~FROM krmcbride/alpine:'"${v}"'-base~' "${DIR}/base/alpine/Dockerfile.dev" > "${DIR}/base/alpine/${v}-dev/Dockerfile"
done
