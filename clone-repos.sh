#!/usr/bin/env bash

set -e

repos=(
    "https://github.com/edx/edx-platform.git"
)

cd ${DEVSTACK_WORKSPACE}

for repo in ${repos[*]}
do
    git clone --branch open-release/ginkgo.master $repo
done

mkdir edx-themes
mkdir src
