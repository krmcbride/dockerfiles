#!/usr/bin/env sh

set -eo pipefail
[[ "$TRACE" ]] && set -x

echo "generating base dockerfiles"
alpine_versions=(3.4 3.5 3.6)
for v in ${alpine_versions[@]}; do
    echo "generating alpine:${v}-dev Dockerfile"
    sed 's~^FROM.*$~FROM krmcbride/alpine:'"${v}"'-base~' base/alpine/Dockerfile.dev > base/alpine/"${v}"-dev/Dockerfile
done
