#!/usr/bin/env bash

export OPENEDX_RELEASE="open-release/ginkgo.1"
docker build -t vkaracic/xenial-base:ginkgo.1 .
