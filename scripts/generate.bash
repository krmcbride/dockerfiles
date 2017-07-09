#!/usr/bin/env bash

set -eo pipefail
[[ "$TRACE" ]] && set -x
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../ && pwd )"

generate_base () {
    alpine_versions=(3.4 3.5 3.6)
    debian_versions=(jessie)

    echo "generating base dockerfiles"

    for v in ${alpine_versions[@]}; do
        echo "generating alpine:${v}-dev Dockerfile"
        sed 's~^FROM.*$~FROM krmcbride/alpine:'"${v}"'-base~' "${DIR}/base/alpine/Dockerfile.dev" > "${DIR}/base/alpine/${v}-dev/Dockerfile"
    done

    for v in ${debian_versions[@]}; do
        echo "generating debian:${v}-dev Dockerfile"
        sed 's~^FROM.*$~FROM krmcbride/debian:'"${v}"'-base~' "${DIR}/base/debian/Dockerfile.dev" > "${DIR}/base/debian/${v}-dev/Dockerfile"
    done
}

generate_base
